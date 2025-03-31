--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/CombatCortex2.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local AttackCommand = require "ItsyScape.Game.AttackCommand"
local CombatPower = require "ItsyScape.Game.CombatPower"
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local Variables = require "ItsyScape.Game.Variables"
local ZealPoke = require "ItsyScape.Game.ZealPoke"
local Cortex = require "ItsyScape.Peep.Cortex"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local CombatChargeBehavior = require "ItsyScape.Peep.Behaviors.CombatChargeBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PendingPowerBehavior = require "ItsyScape.Peep.Behaviors.PendingPowerBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local TilePathNode = require "ItsyScape.World.TilePathNode"
local WeaponBehavior = require "ItsyScape.Peep.Behaviors.WeaponBehavior"

local CombatCortex = Class(Cortex)
CombatCortex.QUEUE = {}

CombatCortex.TILE_TO_WORLD = 2
CombatCortex.STRAFE_DIRECTIONS = {
	{ -1, 0 },
	{  1, 0 },
	{  0, 1 },
	{  0, -1 }
}

function CombatCortex:new()
	Cortex.new(self)

	self:require(CombatStatusBehavior)

	self.config = Variables("Resources/Game/Variables/Combat.json")

	self.defaultWeapon = Weapon()
	self.currentTime = 0

	self.currentTarget = {}
	self.currentStance = {}
	self.currentRoll = {}
end

function CombatCortex:addPeep(peep)
	Cortex.addPeep(self, peep)

	local rollInfo = { rolledAttack = false, rolledDamage = false, initiateAttack = false, receiveAttack = false }
	self.currentRoll[peep] = rollInfo

	function rollInfo.onRollAttack(_, roll)
		rollInfo.accuracyRoll = roll
		rollInfo.accuracyBonus = roll:getAccuracyBonus()
		rollInfo.defenseBonus = roll:getDefenseBonus()
		rollInfo.attackSkillLevel = roll:getAttackLevel()
		rollInfo.rolledAttack = true
	end

	function rollInfo.onRollDamage(_, roll)
		rollInfo.damageRoll = roll
		rollInfo.baseHit = roll:getBaseHit()
		rollInfo.damageSkillLevel = roll:getLevel()
		rollInfo.rolledDamage = true
	end

	function rollInfo.onInitiateAttack(_, attack)
		rollInfo.damageAttackPoke = attack
		rollInfo.damageDealt = attack:getDamage()
		rollInfo.initiateAttack = true
	end

	function rollInfo.onReceiveAttack(_, attack)
		rollInfo.defendAttackPoke = attack
		rollInfo.damageReceived = attack:getDamage()
		rollInfo.receiveAttack = true
	end

	peep:listen("rollAttack", rollInfo.onRollAttack)
	peep:listen("rollDamage", rollInfo.onRollDamage)
	peep:listen("initiateAttack", rollInfo.onInitiateAttack)
	peep:listen("receiveAttack", rollInfo.onReceiveAttack)
end

function CombatCortex:removePeep(peep)
	Cortex.removePeep(self, peep)

	local rollInfo = self.currentRoll[peep]
	if rollInfo then
		peep:silence("rollAttack", rollInfo.onRollAttack)
		peep:silence("rollDamage", rollInfo.onRollDamage)
		peep:silence("initiateAttack", rollInfo.onInitiateAttack)
		peep:silence("receiveAttack", rollInfo.onInitiateAttack)
	end

	self.currentTarget[peep] = nil
	self.currentStance[peep] = nil
	self.currentRoll[peep] = nil
end

function CombatCortex:_getPeepTarget(peep)
	local combatTarget = peep:getBehavior(CombatTargetBehavior)
	combatTarget = combatTarget and combatTarget.actor
	combatTarget = combatTarget and combatTarget:getPeep()

	return combatTarget
end

function CombatCortex:_canPeepAttackTarget(selfPeep, targetPeep)
	return Utility.Peep.isAttackable(targetPeep) and
	       Utility.Peep.canAttack(targetPeep)
end

function CombatCortex:_canPeepReachTarget(selfPeep, targetPeep, weaponRange)
	local targetInstance = Utility.Peep.getInstance(targetPeep)
	local selfInstance = Utility.Peep.getInstance(selfPeep)
	if targetInstance ~= selfInstance then
		return false
	end

	local selfSize = Utility.Peep.getSize(selfPeep)
	selfSize = math.max(selfSize.x, selfSize.z)
	local targetSize = Utility.Peep.getSize(targetPeep)
	targetSize = math.max(targetSize.x, targetSize.z)

	local status = selfPeep:getBehavior(CombatStatusBehavior)

	local map = Utility.Peep.getMap(selfPeep)
	local worldWeaponRange = self.TILE_TO_WORLD * weaponRange
	local halfTile = self.TILE_TO_WORLD / 2

	local distance = Utility.Peep.getAbsoluteDistance(selfPeep, targetPeep)

	local canReachTarget = distance <= worldWeaponRange
	local isTooFar = status and distance > (status.maxChaseDistance + worldWeaponRange)
	local isTooClose = distance < selfSize + targetSize
	return canReachTarget, isTooFar, isTooClose
end

function CombatCortex:_getRelativeTile(selfPeep, targetPeep)
	local selfMap = Utility.Peep.getMap(selfPeep)
	local selfWorldTransform = Utility.Peep.getParentTransform(selfPeep)

	local selfPosition = Utility.Peep.getPosition(selfPeep)
	local targetAbsolutePosition = Utility.Peep.getAbsolutePosition(targetPeep)
	local targetPosition = Vector(selfWorldTransform:inverseTransformPoint(targetAbsolutePosition:get()))

	local _, s, t = selfMap:getTileAt(targetPosition.x, targetPosition.z)
	local _, u, v = selfMap:getTileAt(selfPosition.x, selfPosition.z)

	return s, t, u, v
end

function CombatCortex:_canPeepSeeTarget(selfPeep, targetPeep)
	local selfMap = Utility.Peep.getMap(selfPeep)
	local targetI, targetJ, selfI, selfJ = self:_getRelativeTile(selfPeep, targetPeep)

	local isSameTile = targetI == selfI and targetJ == selfJ
	local isLineOfSightClear = selfMap:lineOfSightPassable(selfI, selfJ, targetI, targetJ, true)

	return isSameTile or isLineOfSightClear
end

function CombatCortex:_getPeepWeapon(peep)
	local equippedWeapon = Utility.Peep.getEquippedWeapon(peep, true)
	if not equippedWeapon or not Class.isCompatibleType(equippedWeapon, Weapon) then
		equippedWeapon = self.defaultWeapon
	end

	return equippedWeapon
end

function CombatCortex:_isPeepWithinRange(selfPeep, targetPeep)
	local targetPeep = self:_getPeepTarget(selfPeep)
	if not targetPeep then
		return false
	end

	local equippedWeapon = self:_getPeepWeapon(selfPeep)
	local weaponRange = equippedWeapon:getAttackRange(selfPeep)

	local canReachTarget, isTooFar, isTooClose = self:_canPeepReachTarget(selfPeep, targetPeep, weaponRange)
	if not canReachTarget then
		return false, isTooFar, isTooClose
	end

	if not self:_canPeepSeeTarget(selfPeep, targetPeep) then
		return false, isTooFar, isTooClose
	end

	return true, isTooFar, isTooClose
end

local BASE_TARGET_SWITCH_ZEAL_LOSS = Variables.Path("baseTargetSwitchZealLoss")
local BASE_TARGET_SWITCH_ZEAL_LOSS_COOLDOWN_SECONDS = Variables.Path("baseTargetSwitchZealLossCooldownSeconds")
local BASE_NO_TARGET_ZEAL_DRAIN_START_SECONDS = Variables.Path("noTargetZealDrainStartSeconds")
local BASE_NO_TARGET_ZEAL_DRAIN_RATE_PER_SECOND = Variables.Path("noTargetZealDrainRatePerSecond")
function CombatCortex:updatePeepTarget(delta, peep)
	local combatTarget = self:_getPeepTarget(peep)

	local currentTargetInfo = self.currentTarget[peep]
	if not currentTargetInfo then
		currentTargetInfo = { cooldown = 0 }
		self.currentTarget[peep] = currentTargetInfo

		function currentTargetInfo.onDie(peep)
			currentTargetInfo.target = nil
			currentTargetInfo.cooldown = self.config:get(BASE_NO_TARGET_ZEAL_DRAIN_START_SECONDS)

			peep:silence("die", currentTargetInfo.onDie)
		end
	end
	currentTargetInfo.cooldown = math.max(currentTargetInfo.cooldown - delta, 0)

	local isTargetDifferent = combatTarget and currentTargetInfo.target ~= combatTarget
	local hasPreviousCombatTarget = currentTargetInfo.target ~= nil
	local hasCurrentCombatTarget = combatTarget ~= nil
	local isCooldownOver = currentTargetInfo.cooldown <= 0

	-- Target switched while engaging in active combat when the target switching cooldown has expired.
	-- Apply zeal loss penalty.
	if isTargetDifferent and hasPreviousCombatTarget and hasCurrentCombatTarget and isCooldownOver then
		peep:poke("zeal", ZealPoke.onTargetSwitch({
			previousTarget = currentTargetInfo.target,
			currentTarget = combatTarget,
			zeal = -self.config:get(BASE_TARGET_SWITCH_ZEAL_LOSS)
		}))

		currentTargetInfo.cooldown = self.config:get(BASE_TARGET_SWITCH_ZEAL_LOSS_COOLDOWN_SECONDS)
		currentTargetInfo.target:silence("die", currentTargetInfo.onDie)
	end

	-- New target. Listen for 'die' event to clear target without penalty.
	if isTargetDifferent and hasCurrentCombatTarget then
		currentTargetInfo.target = combatTarget
		currentTargetInfo.target:listen("die", currentTargetInfo.onDie)
	end

	-- Target lost (dis-engaged from combat). Begin zeal drain cooldown.
	if hasPreviousCombatTarget and not hasCurrentCombatTarget then
		currentTargetInfo.cooldown = self.config:get(BASE_NO_TARGET_ZEAL_DRAIN_START_SECONDS)
	end

	-- No target and drain cooldown over. Drain zeal.
	if not hasCurrentCombatTarget and isCooldownOver then
		local lossRatePerSecond = self.config:get(BASE_NO_TARGET_ZEAL_DRAIN_RATE_PER_SECOND)
		peep:poke("zeal", ZealPoke.onTargetLost({ zeal = -(delta * lossRatePerSecond) }))
	end
end

function CombatCortex:_tryUsePower(selfPeep, targetPeep, equippedWeapon)
	local power = selfPeep:getBehavior(PendingPowerBehavior)
	power = power and power.power

	if not power then
		return false
	end

	if not Class.isCompatibleType(power, CombatPower) then
		return false
	end

	local status = selfPeep:getBehavior(CombatStatusBehavior)
	if not status then
		return false
	end

	local currentZeal = math.floor(status.currentZeal * 100)
	local zealCost = math.floor(power:getCost(selfPeep) * 100)

	if zealCost >= currentZeal then
		return false
	end

	if not targetPeep and power:getRequiresTarget() then
		return false
	end

	local hasCooldown = selfPeep:hasBehavior(AttackCooldownBehavior)
	if hasCooldown and not power:getIsInstant() then
		return false
	end

	local didUsePower = power:perform(selfPeep, targetPeep)
	selfPeep:removeBehavior(PendingPowerBehavior)

	if not didUsePower then
		return false
	end

	power:activate(selfPeep, targetPeep)

	selfPeep:poke("zeal", ZealPoke.onUsePower({
		power = power,
		zeal = -(zealCost / 100)
	}))

	if not power:getIsQuick() and power:getRequiresTarget() then
		equippedWeapon:applyCooldown(selfPeep, targetPeep)
	end

	local actor = selfPeep:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor.actor:flash("Power", 0.5, power:getResource().name, power:getName())
	end

	local logicOverride = power:getXWeapon(selfPeep)
	return true, logicOverride
end

function CombatCortex:_makePeepFaceTarget(selfPeep, targetPeep)
	local selfPosition = Utility.Peep.getAbsolutePosition(selfPeep)
	local targetPosition = Utility.Peep.getAbsolutePosition(targetPeep)

	local movement = selfPeep:getBehavior(MovementBehavior)
	if not movement.targetFacing then
		if selfPosition.x > targetPosition.x then
			movement.facing = MovementBehavior.FACING_LEFT
		elseif selfPosition.x < targetPosition.x then
			movement.facing = MovementBehavior.FACING_RIGHT
		end
	end
end

local PROWESS_FLUX_CONTROLLED_INTERVAL = Variables.Path("prowessFluxControlledInterval")
local PROWESS_FLUX_DAMAGE_INTERVALS = Variables.Path("prowessFluxDamageIntervals")

function CombatCortex:_getDamageZeal(damage, maxHit)
	local prowess = self.config:get(PROWESS_FLUX_DAMAGE_INTERVALS)

	local currentIndex
	for i = 1, #prowess do
		if maxHit >= prowess[i].maxHit then
			currentIndex = i
		else
			break
		end
	end
	local nextIndex = math.min(currentIndex + 1, #prowess)

	local mu
	do
		local muNumerator = (maxHit - prowess[currentIndex].maxHit)
		local muDenominator = prowess[nextIndex].maxHit - prowess[currentIndex].maxHit

		if muDenominator == 0 then
			mu = 0
		else
			mu = muNumerator / muDenominator
		end
	end

	local delta = damage / maxHit

	local upper = math.lerp(prowess[currentIndex].upper, prowess[nextIndex].upper, mu)
	local lower = math.lerp(prowess[currentIndex].upper, prowess[nextIndex].upper, mu)
	local zeal = math.lerp(lower, upper, delta)

	return zeal
end

local ZEAL_INTERVAL_SECONDS = Variables.Path("zealIntervalSeconds")
function CombatCortex:_scaleZealByWeaponSpeed(zeal, weaponSpeed)
	local zealInterval = self.config:get(ZEAL_INTERVAL_SECONDS)
	local relativeWeaponZealInteral = weaponSpeed / zealInterval
	return zeal * relativeWeaponZealInteral
end

function CombatCortex:_getLevelZeal(averageLevel)
	averageLevel = math.ceil(averageLevel)

	local prowess = self.config:get(PROWESS_FLUX_CONTROLLED_INTERVAL)

	local currentIndex
	for i = 1, #prowess do
		if averageLevel >= prowess[i].averageLevel then
			currentIndex = i
		else
			break
		end
	end
	local nextIndex = math.min(currentIndex + 1, #prowess)

	local delta
	do
		local deltaNumerator = (averageLevel - prowess[currentIndex].averageLevel)
		local deltaDenominator = prowess[nextIndex].averageLevel - prowess[currentIndex].averageLevel

		if deltaDenominator == 0 then
			delta = 0
		else
			delta = deltaNumerator / deltaDenominator
		end
	end

	local zeal = math.lerp(prowess[currentIndex].zeal, prowess[nextIndex].zeal, delta)

	return zeal
end

local CRITICAL_FLUX_ZEAL_MULTIPLIER_STEP = Variables.Path("criticalFluxZealMultiplierStep")
local CRITICAL_FLUX_ZEAL_MAX_MULTIPLIER = Variables.Path("criticalFluxZealMaxMultiplier")
local CRITICAL_FLUX_ZEAL_MIN_MULTIPLIER = Variables.Path("criticalFluxZealMinMultiplier")

function CombatCortex:_givePeepZeal(peep, target)
	local rollInfo = self.currentRoll[peep]

	if not (rollInfo.initiateAttack and rollInfo.rolledAttack and rollInfo.rolledDamage) then
		return
	end

	local minCriticalMultiplier = self.config:get(CRITICAL_FLUX_ZEAL_MIN_MULTIPLIER)
	local maxCriticalMultiplier = self.config:get(CRITICAL_FLUX_ZEAL_MAX_MULTIPLIER)
	local criticalMultiplierStep = self.config:get(CRITICAL_FLUX_ZEAL_MULTIPLIER_STEP)

	local criticalMultiplier = 1 + (((rollInfo.accuracyBonus * 3) / rollInfo.defenseBonus - 1) * criticalMultiplierStep)
	criticalMultiplier = math.clamp(criticalMultiplier, minCriticalMultiplier, maxCriticalMultiplier)

	local currentStanceInfo = self.currentStance[peep]
	if currentStanceInfo.stance == Weapon.STANCE_CONTROLLED then
		local averageLevel = (rollInfo.damageSkillLevel + rollInfo.attackSkillLevel)
		local zeal = self:_getLevelZeal(averageLevel)

		local weapon = self:_getPeepWeapon(peep)
		zeal = self:_scaleZealByWeaponSpeed(zeal, weapon:getCooldown(peep))

		peep:poke("zeal", ZealPoke.onAttack({
			accurracyRoll = rollInfo.accuracyRoll,
			damageRoll = rollInfo.damageRoll,
			attack = rollInfo.damageAttackPoke,
			zeal = zeal
		}))
	elseif currentStanceInfo.stance == Weapon.STANCE_AGGRESSIVE then
		local zeal = self:_getDamageZeal(rollInfo.damageDealt, rollInfo.baseHit)

		local weapon = self:_getPeepWeapon(peep)
		zeal = self:_scaleZealByWeaponSpeed(zeal, weapon:getCooldown(peep))

		peep:poke("zeal", ZealPoke.onAttack({
			accurracyRoll = rollInfo.accuracyRoll,
			damageRoll = rollInfo.damageRoll,
			attack = rollInfo.damageAttackPoke,
			zeal = zeal
		}))
	end
end

function CombatCortex:_giveTargetZeal(selfPeep, targetPeep)
	local selfRollInfo = selfPeep.rollInfo[selfPeep]
	local targetRollInfo = targetPeep.rollInfo[targetPeep]

	if not (selfRollInfo.initiateAttack and selfRollInfo.rolledAttack and selfRollInfo.rolledDamage and targetRollInfo.receivedAttack) then
		return
	end

	local minCriticalMultiplier = self.config:get(CRITICAL_FLUX_ZEAL_MIN_MULTIPLIER)
	local maxCriticalMultiplier = self.config:get(CRITICAL_FLUX_ZEAL_MAX_MULTIPLIER)
	local criticalMultiplierStep = self.config:get(CRITICAL_FLUX_ZEAL_MULTIPLIER_STEP)

	local criticalMultiplier = 1 + ((roll.defenseBonus / (roll.accuracyBonus * 3) - 1) * criticalMultiplierStep)
	criticalMultiplier = math.clamp(criticalMultiplier, minCriticalMultiplier, maxCriticalMultiplier)

	local targetCurrentStanceInfo = self.currentStance[targetPeep]
	if targetCurrentStanceInfo.stance == Weapon.STANCE_DEFENSIVE then
		local zeal = self:_getDamageZeal(rollInfo.damageReceived, rollInfo.baseHit)

		targetPeep:poke("zeal", ZealPoke.onDefend({
			accurracyRoll = rollInfo.accuracyRoll,
			damageRoll = rollInfo.damageRoll,
			attack = rollInfo.damageAttackPoke,
			zeal = zeal
		}))
	end
end

local BASE_STANCE_SWITCH_ZEAL_LOSS = Variables.Path("baseStanceSwitchZealLoss")
local BASE_STANCE_SWITCH_ZEAL_LOSS_COOLDOWN_SECONDS = Variables.Path("baseStanceSwitchZealLossCooldownSeconds")
function CombatCortex:updatePeepStance(delta, peep)
	local stance = peep:getBehavior(StanceBehavior)
	stance = stance and stance.stance
	stance = stance or Weapon.STANCE_NONE

	local currentStanceInfo = self.currentStance[peep]
	if not currentStanceInfo then
		currentStanceInfo = { cooldown = 0, stance = stance }
		self.currentStance[peep] = currentStanceInfo
	end
	currentStanceInfo.cooldown = math.max(currentStanceInfo.cooldown - delta, 0)

	local isStanceDifferent = currentStanceInfo.stance ~= stance
	local isCooldownOver = currentStanceInfo.cooldown <= 0

	-- Stance changed and cooldown has expired.
	-- Apply zeal loss penalty.
	if isStanceDifferent and isCooldownOver then
		peep:poke("zeal", ZealPoke.onStanceSwitch({
			previousStance = currentStanceInfo.stance,
			currentStance = stance,
			zeal = -self.config:get(BASE_STANCE_SWITCH_ZEAL_LOSS), 
		}))

		currentStanceInfo.cooldown = self.config:get(BASE_STANCE_SWITCH_ZEAL_LOSS_COOLDOWN_SECONDS)
	end

	if isStanceDifferent then
		currentStanceInfo.stance = stance
	end
end

function CombatCortex:updatePeepCooldown(delta, peep)
	local cooldown = peep:getBehavior(AttackCooldownBehavior)
	if not cooldown then
		return
	end

	cooldown.cooldown = math.max((cooldown.cooldown or 0) - delta, 0)
	if cooldown.cooldown <= 0 then
		peep:removeBehavior(AttackCooldownBehavior)
	end
end

function CombatCortex:_onPeepWalkCalculated(peep, success)
	local charge = peep:getBehavior(CombatChargeBehavior)
	if charge then
		charge.currentWalkID = false
	end

	if not success then
		peep:removeBehavior(CombatTargetBehavior)
	end
end

function CombatCortex:movePeep(peep, i, j, k)
	local target = self:_getPeepTarget(peep)
	local charge = peep:getBehavior(CombatChargeBehavior)

	if not (charge and target) then
		return
	end

	local currentI, currentJ = self:_getRelativeTile(peep, target)
	local currentK = Utility.Peep.getLayer(peep)
	local previousI, previousJ, previousK = charge.i, charge.j, charge.k

	local targetI = i or currentI
	local targetJ = j or currentJ
	local targetK = k or currentK

	if targetI ~= previousI or targetJ ~= previousJ or targetK ~= previousK then
		if charge.currentWalkID then
			Utility.Peep.cancelWalk(charge.currentWalkID)
		end

		local callback, id = Utility.Peep.queueWalk(peep, targetI, targetJ, targetK, 0)
		charge.currentWalkID = id

		callback:register(self._onPeepWalkCalculated, self, peep)
		charge.i, charge.j, charge.k = targetI, targetJ, targetK
	end
end

function CombatCortex:strafePeep(peep)
	local charge = peep:getBehavior(CombatChargeBehavior)
	local target = self:_getPeepTarget(peep)
	if not (charge and target) then
		return
	end

	local equippedWeapon = self:_getPeepWeapon(peep)
	local weaponRange = equippedWeapon:getAttackRange(peep)
	weaponRange = self.TILE_TO_WORLD * weaponRange

	local distance = Utility.Peep.getAbsoluteDistance(peep, target)
	local strafeDistance = math.max(weaponRange - distance, 0)

	if strafeDistance == 0 then
		peep:removeBehavior(CombatChargeBehavior)
		return
	end

	local targetI, targetJ, selfI, selfJ = self:_getRelativeTile(peep, target)

	local bestSelfStrafeDistance = math.huge
	local bestTargetStrafeDistance = 0
	local bestI, bestJ, bestIsPassable

	local map = Utility.Peep.getMap(peep)
	local tiles = math.max(math.floor(strafeDistance / map:getCellSize()), 1)

	for _, direction in ipairs(self.STRAFE_DIRECTIONS) do
		local directionI, directionJ = unpack(direction)
		local i = directionI * tiles + targetI
		local j = directionJ * tiles + targetJ

		local isPassable, realI, realJ = map:lineOfSightPassable(selfI, selfJ, i, j, false)
		local targetDistance = math.abs(realI - targetI) + math.abs(realJ - targetJ)
		local selfDistance = math.abs(realI - selfI) + math.abs(realJ - selfJ)

		if isPassable then
			if selfDistance < bestSelfStrafeDistance then
				bestI = i
				bestJ = j
				bestSelfStrafeDistance = selfDistance
				bestIsPassable = true
			end
		elseif not bestIsPassable then
			if targetDistance > bestTargetStrafeDistance then
				bestI = realI
				bestJ = realJ
				bestTargetStrafeDistance = targetDistance
			end
		end
	end

	if bestI and bestJ then
		self:movePeep(peep, bestI, bestJ)
	else
		peep:removeBehavior(CombatChargeBehavior)
	end
end

function CombatCortex:cancelCharge(peep)
	local charge = peep:getBehavior(CombatChargeBehavior)
	if charge and charge.currentWalkID then
		Utility.Peep.cancelWalk(charge.currentWalkID)
	end

	peep:removeBehavior(CombatChargeBehavior)
	peep:removeBehavior(TargetTileBehavior)
end

function CombatCortex:tickPeep(delta, peep)
	local target = self:_getPeepTarget(peep)
	local equippedWeapon = self:_getPeepWeapon(peep)

	if not target then
		self:_tryUsePower(peep, nil, equippedWeapon)
		return
	end

	local isWithinRange, isTooFar, isTooClose = self:_isPeepWithinRange(peep, target)
	local isAttackable = self:_canPeepAttackTarget(peep, target)
	if not isAttackable or isTooFar then
		peep:removeBehavior(CombatTargetBehavior)
		return
	elseif not isWithinRange then
		peep:addBehavior(CombatChargeBehavior)
		self:movePeep(peep)
		return
	elseif isTooClose and not peep:hasBehavior(PlayerBehavior) then
		if target:hasBehavior(CombatChargeBehavior) then
			peep:removeBehavior(CombatChargeBehavior)
		else
			peep:addBehavior(CombatChargeBehavior)
			self:strafePeep(peep)
		end
	elseif peep:hasBehavior(CombatChargeBehavior) then
		self:cancelCharge(peep)
	end

	self:_makePeepFaceTarget(peep, target)

	local didUsePower, powerXWeapon = self:_tryUsePower(peep, target, equippedWeapon)
	local weapon = powerXWeapon or equippedWeapon
	if not (weapon and Class.isCompatibleType(weapon, Weapon)) then
		return
	end

	local hasCooldown = peep:hasBehavior(AttackCooldownBehavior)
	if not didUsePower and hasCooldown then
		return
	end

	local rollInfo = self.currentRoll[peep]
	rollInfo.rolledAttack = false
	rollInfo.rolledDamage = false
	rollInfo.hit = false

	local success = weapon:perform(peep, target)
	if not success then
		return
	end

	if not didUsePower then
		self:_givePeepZeal(peep)
	end

	local projectile = weapon:getProjectile(peep)
	if projectile then
		local stage = self:getDirector():getGameInstance():getStage()
		stage:fireProjectile(projectile, peep, target)
	end
end

function CombatCortex:tick(delta)
	for peep in self:iterate() do
		self:updatePeepTarget(delta, peep)
		self:updatePeepStance(delta, peep)
		self:updatePeepCooldown(delta, peep)
	end

	for peep in self:iterate() do
		self:tickPeep(delta, peep)
	end
end

local TICK_DURATION_SECONDS = Variables.Path("loop", "tickDurationSeconds")
function CombatCortex:update(delta)
	local tickDurationSeconds = self.config:get(TICK_DURATION_SECONDS)

	self.currentTime = self.currentTime + delta
	while self.currentTime > tickDurationSeconds do
		self.currentTime = self.currentTime - tickDurationSeconds

		self:tick(tickDurationSeconds)
	end
end

return CombatCortex
