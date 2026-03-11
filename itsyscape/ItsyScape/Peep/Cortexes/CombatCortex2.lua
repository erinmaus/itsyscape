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
local CombatSpell = require "ItsyScape.Game.CombatSpell"
local Config = require "ItsyScape.Game.Config"
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local ZealPoke = require "ItsyScape.Game.ZealPoke"
local Cortex = require "ItsyScape.Peep.Cortex"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local ActiveSpellBehavior = require "ItsyScape.Peep.Behaviors.ActiveSpellBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"
local AggressiveBehavior = require "ItsyScape.Peep.Behaviors.AggressiveBehavior"
local CombatChargeBehavior = require "ItsyScape.Peep.Behaviors.CombatChargeBehavior"
local CombatDodgeBehavior = require "ItsyScape.Peep.Behaviors.CombatDodgeBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local FlyingBehavior = require "ItsyScape.Peep.Behaviors.FlyingBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PendingPowerBehavior = require "ItsyScape.Peep.Behaviors.PendingPowerBehavior"
local PendingStrategyGradeBehavior = require "ItsyScape.Peep.Behaviors.PendingStrategyGradeBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local PowerRechargeBehavior = require "ItsyScape.Peep.Behaviors.PowerRechargeBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local SpecialAttackBehavior = require "ItsyScape.Peep.Behaviors.SpecialAttackBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local TargetPositionBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"
local TilePathNode = require "ItsyScape.World.TilePathNode"
local WeaponBehavior = require "ItsyScape.Peep.Behaviors.WeaponBehavior"
local ZealEffect = require "ItsyScape.Peep.Effects.ZealEffect"

local CombatCortex = Class(Cortex)
CombatCortex.QUEUE = {}

CombatCortex.TILE_TO_WORLD = 2
CombatCortex.STRAFE_DIRECTIONS = {
	{ -1, 0 },
	{  1, 0 },
	{  0, 1 },
	{  0, -1 }
}

CombatCortex.DEFAULT_CLASS_SWITCH_ANIMATIONS = {
	[Weapon.STYLE_ARCHERY] = "Human_SwapGear_ToArchery_1",
	[Weapon.STYLE_MAGIC] = "Human_SwapGear_ToMagic_1",
	[Weapon.STYLE_MELEE] = "Human_SwapGear_ToMelee_1"
}

function CombatCortex:new()
	Cortex.new(self)

	self:require(CombatStatusBehavior)

	self.defaultWeapon = Weapon()
	self.currentTime = 0

	self.currentTarget = {}
	self.nextTarget = {}
	self.currentStance = {}
	self.currentRoll = {}
	self.previousCombatStyle = {}
end

function CombatCortex:addPeep(peep)
	Cortex.addPeep(self, peep)

	local rollInfo = {}
	self.currentRoll[peep] = rollInfo

	function onRollAttack(_, roll)
		rollInfo.accuracyRoll = roll
		rollInfo.accuracyBonus = roll:getAccuracyBonus()
		rollInfo.defenseBonus = roll:getDefenseBonus()
		rollInfo.attackSkillLevel = roll:getAttackLevel()
		rollInfo.rolledAttack = true
	end

	function onRollDamage(_, roll)
		rollInfo.damageRoll = roll
		rollInfo.baseHit = roll:getBaseHit()
		rollInfo.damageSkillLevel = roll:getLevel()
		rollInfo.rolledDamage = true
	end

	function onInitiateAttack(_, attack, target)
		rollInfo.damageAttackPoke = attack
		rollInfo.attackTarget = target 
		rollInfo.damageDealt = attack:getDamage()
		rollInfo.initiateAttack = true
	end

	function onReceiveAttack(_, attack, aggressor)
		rollInfo.defendAttackPoke = attack
		rollInfo.defendAggressor = aggressor
		rollInfo.damageReceived = attack:getDamage()
		rollInfo.receiveAttack = true

		if peep:hasBehavior(PendingStrategyGradeBehavior) then
			self:_gradePeep(peep, aggressor, attack)
		end
	end

	function onDodgeSuccess(_, aggressor)
		local grade = Config.get("Combat", "STRATEGY_PERFECT_GRADE")
		self:_giveGradeZeal(peep, aggressor, grade)
	end

	function reset()
		table.clear(rollInfo)

		rollInfo.rolledAttack = false
		rollInfo.rolledDamage = false
		rollInfo.initiateAttack = false
		rollInfo.receiveAttack = false

		rollInfo.onRollAttack = onRollAttack
		rollInfo.onRollDamage = onRollDamage
		rollInfo.onInitiateAttack = onInitiateAttack
		rollInfo.onReceiveAttack = onReceiveAttack
		rollInfo.onDodgeSuccess = onDodgeSuccess
		rollInfo.reset = reset
	end

	reset()

	peep:listen("rollAttack", rollInfo.onRollAttack)
	peep:listen("rollDamage", rollInfo.onRollDamage)
	peep:listen("initiateAttack", rollInfo.onInitiateAttack)
	peep:listen("receiveAttack", rollInfo.onReceiveAttack)
	peep:listen("dodgeSuccess", rollInfo.onDodgeSuccess)
end

function CombatCortex:removePeep(peep)
	Cortex.removePeep(self, peep)

	local rollInfo = self.currentRoll[peep]
	if rollInfo then
		peep:silence("rollAttack", rollInfo.onRollAttack)
		peep:silence("rollDamage", rollInfo.onRollDamage)
		peep:silence("initiateAttack", rollInfo.onInitiateAttack)
		peep:silence("receiveAttack", rollInfo.onInitiateAttack)
		peep:silence("dodgeSuccess", rollInfo.onDodgeSuccess)
	end

	self.currentTarget[peep] = nil
	self.currentStance[peep] = nil
	self.currentRoll[peep] = nil
	self.previousCombatStyle[peep] = nil
end

function CombatCortex:_getPeepTarget(peep)
	local combatTarget = peep:getBehavior(CombatTargetBehavior)
	combatTarget = combatTarget and combatTarget.actor
	combatTarget = combatTarget and combatTarget:getPeep()

	return combatTarget
end

function CombatCortex:_canPeepAttackTarget(selfPeep, targetPeep)
	return Utility.Peep.canPeepAttackTarget(selfPeep, targetPeep)
end

function CombatCortex:_canPeepReachTarget(selfPeep, targetPeep, weaponRange)
	local targetInstance = Utility.Peep.getInstance(targetPeep)
	local selfInstance = Utility.Peep.getInstance(selfPeep)
	if targetInstance ~= selfInstance then
		return false
	end

	local selfSize = Utility.Peep.getSize(selfPeep) * Utility.Peep.getScale(selfPeep)
	selfSize = math.max(selfSize.x, selfSize.z)
	local targetSize = Utility.Peep.getSize(targetPeep) * Utility.Peep.getScale(targetPeep)
	targetSize = math.max(targetSize.x, targetSize.z)

	local adjustWeaponedRange = weaponRange
	local flying = targetPeep:getBehavior(FlyingBehavior)
	if flying and flying.isFlying then
		adjustWeaponedRange = weaponRange - flying.range
	end

	local selfMovement = selfPeep:getBehavior(MovementBehavior)
	local targetMovement = targetPeep:getBehavior(MovementBehavior)
	local canMove = selfMovement and selfMovement.maxSpeed > 0 and targetMovement and targetMovement.maxSpeed > 0 

	local status = selfPeep:getBehavior(CombatStatusBehavior)

	local map = Utility.Peep.getMap(selfPeep)
	local worldWeaponRange = self.TILE_TO_WORLD * adjustWeaponedRange

	local distance = Utility.Peep.getAbsoluteDistance(selfPeep, targetPeep)
	local canReachTarget = distance <= worldWeaponRange and worldWeaponRange > 0
	local isOutOfRange = status and distance > (status.maxChaseDistance + worldWeaponRange) or worldWeaponRange <= 0
	local isTooFar = distance > worldWeaponRange
	local isTooClose = canMove and distance <= 0
	local maybeCanReach = (isTooClose or isTooFar) and worldWeaponRange > 0

	if selfPeep:getName():match("Orlando") then
		print(">>> Ser Orlando", Log.dump({
			distance = distance,
			canReachTarget = canReachTarget,
			isOutOfRange = isOutOfRange,
			isTooFar = isTooFar,
			isTooClose = isTooClose,
			maybeCanReach = maybeCanReach,
		}))
	end

	return canReachTarget, isTooFar, isTooClose, isOutOfRange, maybeCanReach
end

function CombatCortex:_getPeepSpell(peep, weapon)
	local stance = peep:getBehavior(StanceBehavior)
	if stance and stance.useSpell then
		local activeSpell = peep:getBehavior(ActiveSpellBehavior)
		if activeSpell
		   and activeSpell.spell
		   and activeSpell.spell:isCompatibleType(CombatSpell)
		   and activeSpell.spell:canCast(peep):good()
		then
			return activeSpell.spell
		end
	end

	return nil
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

	local canReachTarget, isTooFar, isTooClose, isOutOfRange, maybeCanReach = self:_canPeepReachTarget(selfPeep, targetPeep, weaponRange)
	if not canReachTarget then
		return false, isTooFar, isTooClose, isOutOfRange, maybeCanReach
	end

	if not Utility.Combat.canSeeTarget(selfPeep, targetPeep) then
		return false, isTooFar, isTooClose, isOutOfRange, maybeCanReach
	end

	return true, isTooFar, isTooClose, isOutOfRange, maybeCanReach
end

function CombatCortex:updatePeepCombatStyle(peep)
	local weapon = self:_getPeepWeapon(peep)
	if weapon == self.defaultWeapon then
		return
	end

	local currentCombatStyle = weapon:getStyle()
	local previousCombatStyle = self.previousCombatStyle[peep]
	if previousCombatStyle == currentCombatStyle then
		return
	end

	if previousCombatStyle then
		Utility.Peep.flash(peep, "ClassChange", 0, currentCombatStyle)
	end

	if previousCombatStyle and peep:hasBehavior(HumanoidBehavior) then
		local animation = self.DEFAULT_CLASS_SWITCH_ANIMATIONS[currentCombatStyle]
		if animation then
			Utility.Peep.playAnimation(peep, "main-swap-gear", 500, animation)
		end
	end

	self.previousCombatStyle[peep] = currentCombatStyle
end

function CombatCortex:updatePeepRecharge(delta, peep)
	local interval = Config.get("Combat", "POWER_ZEAL_RECHARGE_INTERVAL_SECONDS")
	local zealPerInterval = Config.get("Combat", "POWER_ZEAL_RECHARGE_PER_INTERVAL")
	local rechargePerInterval = delta / interval * zealPerInterval

	local pendingPowers = peep:getBehavior(PowerRechargeBehavior)
	if pendingPowers then
		for powerID, powerZeal in pairs(pendingPowers.powers) do
			local multiplier, offset = 1, 0
			for effect in peep:getEffects(ZealEffect) do
				local m, o = effect:modifyPassiveRecharge(p, powerID)
				multiplier = multiplier + m
				offset = offset + o
			end

			local recharge = math.max(rechargePerInterval * multiplier + offset, 0)
			powerZeal = powerZeal - recharge


			if powerZeal <= 0 then
				pendingPowers.powers[powerID] = nil
			else
				pendingPowers.powers[powerID] = powerZeal
			end
		end
	end
end

function CombatCortex:updatePeepTarget(delta, peep)
	local combatTarget = self:_getPeepTarget(peep)

	local currentTargetInfo = self.currentTarget[peep]
	if not currentTargetInfo then
		currentTargetInfo = { cooldown = 0 }
		self.currentTarget[peep] = currentTargetInfo

		function currentTargetInfo.onDie(peep)
			currentTargetInfo.target = nil
			currentTargetInfo.cooldown = Config.get("Combat", "NO_TARGET_ZEAL_DRAIN_START_SECONDS", "_", 0)

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
			zeal = -Config.get("Combat", "TARGET_SWITCH_ZEAL_COST", "_", 0)
		}))

		currentTargetInfo.cooldown = Config.get("Combat", "TARGET_SWITCH_ZEAL_COST_COOLDOWN_SECONDS", "_", 0)
		currentTargetInfo.target:silence("die", currentTargetInfo.onDie)
	end

	-- New target. Listen for 'die' event to clear target without penalty.
	if isTargetDifferent and hasCurrentCombatTarget then
		currentTargetInfo.target = combatTarget
		currentTargetInfo.target:listen("die", currentTargetInfo.onDie)
	end

	-- Target lost (dis-engaged from combat). Begin zeal drain cooldown.
	if hasPreviousCombatTarget and not hasCurrentCombatTarget then
		currentTargetInfo.cooldown = Config.get("Combat", "NO_TARGET_ZEAL_DRAIN_START_SECONDS", "_", 0)
	end

	-- No target and drain cooldown over. Drain zeal.
	if not hasCurrentCombatTarget and isCooldownOver then
		local lossRatePerSecond = Config.get("Combat", "NO_TARGET_ZEAL_DRAIN_RATE_PER_SECOND", "_", 0)
		peep:poke("zeal", ZealPoke.onTargetLost({ zeal = -(delta * lossRatePerSecond) }))
	end
end

function CombatCortex:_tickPower(selfPeep)
	local pendingPower = selfPeep:getBehavior(PendingPowerBehavior)
	local power = pendingPower and pendingPower.power

	if not power then
		return false
	end

	local status = selfPeep:getBehavior(CombatStatusBehavior)
	if not status then
		return false
	end

	local currentZeal = math.floor(status.currentZeal * 100)
	local zealCost = math.floor(power:getCost(selfPeep) * 100)

	if zealCost > currentZeal then
		return false
	end

	if pendingPower.turns > 0 then
		pendingPower.turns = math.max(pendingPower.turns - 1, 0)
		return false
	end


	return true
end

function CombatCortex:_tryUsePower(selfPeep, targetPeep, equippedWeapon)
	local power = selfPeep:getBehavior(PendingPowerBehavior)
	local turns = power and power.turns or 0
	power = power and power.power

	if not power then
		return false
	end

	if turns > 0 then
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

	if zealCost > currentZeal then
		return false
	end

	if not targetPeep and power:getRequiresTarget() then
		return false
	end

	local hasCooldown = selfPeep:hasBehavior(AttackCooldownBehavior)
	if hasCooldown and not power:getIsInstant() then
		return false
	end

	local isRecharging
	do
		local recharge = selfPeep:getBehavior(PowerRechargeBehavior)
		if recharge and (recharge.powers[power:getResource().name] or 0) > 0 then
			isRecharging = true
		else
			isRecharging = false
		end
	end

	if isRecharging then
		return false
	end

	if not power:getIsInstant() and selfPeep:hasBehavior(CombatDodgeBehavior) then
		return false
	end

	local didUsePower = power:perform(selfPeep, targetPeep)
	selfPeep:removeBehavior(PendingPowerBehavior)

	if not didUsePower then
		return false
	end

	power:activate(selfPeep, targetPeep)

	local cost = zealCost / 100
	selfPeep:poke("zeal", ZealPoke.onUsePower({
		power = power,
		zeal = -cost
	}))

	local _, recharge = selfPeep:addBehavior(PowerRechargeBehavior)
	recharge.powers[power:getResource().name] = cost

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

function CombatCortex:_getDamageZeal(damage, maxHit, stance)
	local prowess = Config.get("Combat", "PROWESS_FLUX_DAMAGE_INTERVALS")
	if not prowess then
		return 0
	end

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
	if stance == Weapon.STANCE_DEFENSIVE then
		delta = 1 - math.clamp(delta)
	end

	local upper = math.lerp(prowess[currentIndex].upper, prowess[nextIndex].upper, mu)
	local lower = math.lerp(prowess[currentIndex].upper, prowess[nextIndex].upper, mu)
	local zeal = math.lerp(lower, upper, delta)

	return zeal
end

function CombatCortex:_scaleZealByWeaponSpeed(zeal, weaponSpeed)
	local zealInterval = Config.get("Combat", "ZEAL_INTERVAL_SECONDS")
	local relativeWeaponZealInteral = weaponSpeed / zealInterval
	return zeal * relativeWeaponZealInteral
end

function CombatCortex:_getLevelZeal(averageLevel)
	averageLevel = math.ceil(averageLevel)

	local prowess = Config.get("Combat", "PROWESS_FLUX_CONTROLLED_INTERVALS")
	if not prowess then
		return 0
	end

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

function CombatCortex:_givePeepZeal(peep)
	local rollInfo = self.currentRoll[peep]

	if not rollInfo.initiateAttack then
		return
	end

	local minCriticalMultiplier = Config.get("Combat", "CRITICAL_FLUX_ZEAL_MIN_MULTIPLIER")
	local maxCriticalMultiplier = Config.get("Combat", "CRITICAL_FLUX_ZEAL_MAX_MULTIPLIER")
	local criticalMultiplierStep = Config.get("Combat", "CRITICAL_FLUX_ZEAL_MULTIPLIER_STEP")

	local criticalMultiplier = 1 + ((((rollInfo.accuracyBonus or 0) * 3) / (rollInfo.defenseBonus or 0) - 1) * criticalMultiplierStep)
	criticalMultiplier = math.clamp(criticalMultiplier, minCriticalMultiplier, maxCriticalMultiplier)

	local currentStanceInfo = self.currentStance[peep]
	if currentStanceInfo.stance == Weapon.STANCE_CONTROLLED and rollInfo.rolledAttack then
		local averageLevel = ((rollInfo.damageSkillLevel or 1) + rollInfo.attackSkillLevel) / 2
		local zeal = self:_getLevelZeal(averageLevel)

		local weapon = self:_getPeepWeapon(peep)
		zeal = self:_scaleZealByWeaponSpeed(zeal, weapon:getCooldown(peep))

		peep:poke("zeal", ZealPoke.onAttack({
			accurracyRoll = rollInfo.accuracyRoll,
			damageRoll = rollInfo.damageRoll,
			attack = rollInfo.damageAttackPoke,
			zeal = zeal
		}))
	elseif currentStanceInfo.stance == Weapon.STANCE_AGGRESSIVE and rollInfo.rolledDamage and rollInfo.initiateAttack then
		local zeal = self:_getDamageZeal(rollInfo.damageDealt, rollInfo.baseHit, Weapon.STANCE_AGGRESSIVE)

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
	local rollInfo = self.currentRoll[selfPeep]

	if not (rollInfo.initiateAttack and rollInfo.rolledAttack) then
		return
	end

	local baseHit
	if not rollInfo.rolledDamage then
		local weapon = self:_getPeepWeapon(selfPeep)

		local roll = Weapon.DamageRoll(weapon, selfPeep, Weapon.PURPOSE_KILL, targetPeep)
		weapon:applyDamageModifiers(roll)
		weapon:previewDamageRoll(roll)

		baseHit = roll:getBaseHit()
	else
		baseHit = rollInfo.baseHit
	end

	local minCriticalMultiplier = Config.get("Combat", "CRITICAL_FLUX_ZEAL_MIN_MULTIPLIER")
	local maxCriticalMultiplier = Config.get("Combat", "CRITICAL_FLUX_ZEAL_MAX_MULTIPLIER")
	local criticalMultiplierStep = Config.get("Combat", "CRITICAL_FLUX_ZEAL_MULTIPLIER_STEP")

	local criticalMultiplier = 1 + ((rollInfo.defenseBonus / (rollInfo.accuracyBonus * 3) - 1) * criticalMultiplierStep)
	criticalMultiplier = math.clamp(criticalMultiplier, minCriticalMultiplier, maxCriticalMultiplier)

	local targetCurrentStanceInfo = self.currentStance[targetPeep]
	if targetCurrentStanceInfo.stance == Weapon.STANCE_DEFENSIVE and rollInfo.receiveAttack then
		local zeal = self:_getDamageZeal(rollInfo.damageReceived, baseHit, Weapon.STANCE_DEFENSIVE)

		targetPeep:poke("zeal", ZealPoke.onDefend({
			accurracyRoll = rollInfo.accuracyRoll,
			damageRoll = rollInfo.damageRoll,
			attack = rollInfo.damageAttackPoke,
			zeal = zeal
		}))
	end
end

function CombatCortex:_takeSpellZeal(peep, spell, weapon)
	local zeal = -spell:getZealCost(peep, spell)

	peep:poke("zeal", ZealPoke.onCastSpell({
		spell = spell,
		weapon = weapon,
		zeal = zeal
	}))
end

function CombatCortex:_gradePeep(peep, aggressor, attack)
	local damageRoll = attack:getDamageRoll()
	if not damageRoll then
		return
	end

	local maxHit = damageRoll:getMaxHit()
	local damageReceived = attack:getDamage()

	local minGrade = Config.get("Combat", "STRATEGY_DEFAULT_MIN_GRADE", "_", 0)
	local maxGrade = Config.get("Combat", "STRATEGY_DEFAULT_MAX_GRADE", "_", 0)

	local grade
	if maxHit == 0 or damageReceived == 0 then
		grade = maxGrade
	else
		local ratio = math.clamp(damageReceived / maxHit)
		grade = math.lerp(minGrade, maxGrade, 1 - ratio)
	end

	self:_giveGradeZeal(peep, aggressor, grade)
end

function CombatCortex:_giveGradeZeal(peep, aggressor, grade)
	local grades = Config.get("Combat", "STRATEGY_GRADES")
	if not grades then
		return
	end

	local currentGrade = grades[1], nextGrade
	for i = 2, #grades do
		local gradeInfo = grades[i]
		if gradeInfo.grade > grade then
			nextGrade = gradeInfo
			break
		end

		currentGrade = gradeInfo
	end

	if not currentGrade then
		return
	end

	Log.info("Peep '%s' passed strategy test from '%s' with '%d' grade.", peep:getName(), aggressor:getName(), grade)

	local zeal
	if currentGrade and nextGrade then
		zeal = math.lerp(currentGrade.zeal, nextGrade.zeal, (grade - currentGrade.grade) / (nextGrade.grade - currentGrade.grade))
	else
		zeal = currentGrade.zeal
	end

	peep:poke("zeal", ZealPoke.onStrategy({
		grade = grade,
		zeal = zeal
	}))
end

function CombatCortex:_updateAggressiveTarget(peep)
	local rollInfo = self.currentRoll[peep]

	if not rollInfo.initiateAttack then
		return false
	end

	local poke = rollInfo.damageAttackPoke
	if not poke then
		return false
	end

	local target = rollInfo.attackTarget
	if not target or target:hasBehavior(CombatTargetBehavior) then
		return false
	end

	local aggressive = target:getBehavior(AggressiveBehavior)
	if not aggressive then
		return false
	end

	if aggressive.pendingTarget then
		return false
	end

	local minTime = math.max(math.min(aggressive.maxResponseTime, aggressive.minResponseTime), 0)
	local maxTime = math.max(math.max(aggressive.minResponseTime, aggressive.maxResponseTime), 0)

	local timeMultiplier = 1
	local timeOffset = 0

	for effect in target:getEffects(CombatEffect) do
		local m, o = effect:applyToSelfResponseTime(timeMultiplier)
		timeMultiplier = timeMultiplier + m
		timeOffset = timeMultiplier + o
	end

	for effect in peep:getEffects(CombatEffect) do
		local m, o = effect:applyToTargetResponseTime(timeMultiplier)
		timeMultiplier = timeMultiplier + m
		timeOffset = timeMultiplier + o
	end

	local cooldown = love.math.random() * (maxTime - minTime) + minTime
	cooldown = math.max(cooldown * timeMultiplier + timeOffset, 0)

	local tickDurationSeconds = Config.get("Combat", "TICK_DURATION_SECONDS", "_", 0)
	if tickDurationSeconds > 0 then
		cooldown = math.floor(cooldown / tickDurationSeconds) * tickDurationSeconds
	end

	aggressive.pendingResponseTime = cooldown
	aggressive.pendingTarget = peep

	Log.info("Target '%s' is aggressive and will retaliate against '%s' in %.2f seconds (min = %.2f seconds, max = %.2f seconds).", target:getName(), peep:getName(), cooldown, minTime, maxTime)
end

function CombatCortex:updateAggressivePeep(delta, peep)
	local aggressive = peep:getBehavior(AggressiveBehavior)
	if not aggressive then
		return
	end

	if not aggressive.pendingTarget then
		return
	end

	aggressive.pendingResponseTime = math.max(aggressive.pendingResponseTime - delta, 0)
	if aggressive.pendingResponseTime > 0 then
		return
	end

	Utility.Peep.attack(peep, aggressive.pendingTarget)
	aggressive.pendingTarget = false
end

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
			zeal = -Config.get("Combat", "STANCE_SWITCH_ZEAL_COST", "_", 0),
		}))

		currentStanceInfo.cooldown = Config.get("Combat", "TARGET_SWITCH_ZEAL_COST_COOLDOWN_SECONDS", "_", 0)
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

function CombatCortex:_onPeepWalkCalculated(peep, success, cancelled)
	local charge = peep:getBehavior(CombatChargeBehavior)
	if charge then
		charge.currentWalkID = false
	end

	if not success and not cancelled then
		peep:removeBehavior(CombatTargetBehavior)
	end
end

function CombatCortex:movePeep(peep, position)
	local target = self:_getPeepTarget(peep)
	local charge = peep:getBehavior(CombatChargeBehavior)

	if not (charge and target) then
		return
	end

	local currentPosition = Utility.Peep.getRelativePosition(peep, target)
	local currentI, currentJ = Utility.Peep.getRelativeTile(peep, target)
	local currentK = Utility.Peep.getLayer(peep)

	local previousI, previousJ, previousK = charge.i, charge.j, charge.k

	local targetI, targetJ, targetK
	if position then
		local map = Utility.Peep.getMap(peep)
		local _, i, j = map:getTileAt(position.x, position.z)
		targetI, targetJ = i, j
		targetK = currentK
	else
		targetI = currentI
		targetJ = currentJ
		targetK = currentK
	end

	if not (targetI == previousI and targetJ == previousJ and targetK == previousK) then
		if charge.currentWalkID then
			Utility.Peep.cancelWalk(charge.currentWalkID)
		end

		local callback, id = Utility.Peep.queueWalk(peep, position or currentPosition, targetK, 0)
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

	local peepSize = Utility.Peep.getSize(peep)
	local targetSize = Utility.Peep.getSize(target)
	local size = math.max(peepSize.x, peepSize.z) + math.max(targetSize.x, targetSize.z)

	local distance = Utility.Peep.getAbsoluteDistance(peep, target)
	local strafeDistance = math.max(size - distance, 0)

	if strafeDistance == 0 then
		peep:removeBehavior(CombatChargeBehavior)
		return
	end

	local selfPosition = Utility.Peep.getPosition(peep)
	local targetPosition = Utility.Peep.getRelativePosition(peep, target)
	local targetI, targetJ = Utility.Peep.getRelativeTile(peep, target)

	local bestSelfStrafeDistance = math.huge
	local bestTargetStrafeDistance = 0
	local bestPosition, bestIsPassable

	local map = Utility.Peep.getMap(peep)
	local tiles = math.max(math.floor(strafeDistance / map:getCellSize()), 1)

	for _, direction in ipairs(self.STRAFE_DIRECTIONS) do
		local directionI, directionJ = unpack(direction)
		local i = directionI * tiles + targetI
		local j = directionJ * tiles + targetJ

		local isPassable, realPosition = Utility.Map.isPassable(peep, map:getTileCenter(i, j))
		local targetDistance = targetPosition:distance(realPosition)
		local selfDistance = selfPosition:distance(realPosition)

		if isPassable then
			if selfDistance < bestSelfStrafeDistance then
				bestPosition = map:getTileCenter(i, j)
				bestSelfStrafeDistance = selfDistance
				bestIsPassable = true
			end
		elseif not bestIsPassable then
			if targetDistance > bestTargetStrafeDistance then
				bestPosition = realPosition
				bestTargetStrafeDistance = targetDistance
			end
		end
	end

	if bestPosition then
		self:movePeep(peep, bestPosition)
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
	peep:removeBehavior(TargetPositionBehavior)
end

function CombatCortex:tickPeep(delta, peep)
	local target = self:_getPeepTarget(peep)
	local equippedWeapon = self:_getPeepWeapon(peep)

	if not target then
		self:_tryUsePower(peep, nil, equippedWeapon)
		return
	end

	local isWithinRange, isTooFar, isTooClose, isOutOfRange, maybeCanReach = self:_isPeepWithinRange(peep, target)
	local isAttackable = self:_canPeepAttackTarget(peep, target)
	if not isAttackable or isOutOfRange then
		if peep:hasBehavior(PlayerBehavior) then
			if isAttackable then
				if not peep:hasBehavior(AttackCooldownBehavior) then
					if not maybeCanReach and Utility.Peep.isFlying(target) then
						Utility.Peep.notify(peep, "ui.notification.combat.targetFlyingAndOutOfRange")
					else
						Utility.Peep.notify(peep, "ui.notification.combat.targetOutOfRange")
					end

					local weapon = self:_getPeepWeapon(peep)
					weapon:applyCooldown(peep, target)
				end
			else
				peep:removeBehavior(CombatTargetBehavior)
			end
		else
			peep:getCommandQueue(CombatCortex.QUEUE):interrupt()
			peep:removeBehavior(CombatTargetBehavior)
		end

		return
	elseif not isWithinRange then
		if peep:getName():match("Orlando") then print(">>> not within range, is moving") end
		peep:addBehavior(CombatChargeBehavior)
		self:movePeep(peep)
		return
	elseif isTooClose and not peep:hasBehavior(PlayerBehavior) then
		if peep:getName():match("Orlando") then print(">>> is too close, is strafing") end
		if not target:hasBehavior(CombatChargeBehavior) then
			peep:addBehavior(CombatChargeBehavior)
			self:strafePeep(peep)
		end
	elseif peep:hasBehavior(CombatChargeBehavior) then
		if peep:getName():match("Orlando") then print(">>> good, cancel charge") end
		self:cancelCharge(peep)
	end

	self:_makePeepFaceTarget(peep, target)

	if Utility.Peep.isDisabled(target) then
		return
	end

	local didUsePower, powerXWeapon = self:_tryUsePower(peep, target, equippedWeapon)
	local weapon = powerXWeapon or equippedWeapon
	if not (weapon and Class.isCompatibleType(weapon, Weapon)) then
		return
	end

	local hasCooldown = peep:hasBehavior(AttackCooldownBehavior)
	if not didUsePower and hasCooldown then
		return
	end

	if peep:hasBehavior(CombatDodgeBehavior) or peep:hasBehavior(CombatChargeBehavior) then
		return
	end

	local rollInfo = self.currentRoll[peep]
	rollInfo.reset()

	if peep:hasBehavior(SpecialAttackBehavior) then
		local specialAttack = peep:getBehavior(SpecialAttackBehavior)
		specialAttack.attackInterval = specialAttack.attackInterval - 1

		if specialAttack.attackInterval <= 0 then
			peep:removeBehavior(SpecialAttackBehavior)
		end
	end

	local success = weapon:perform(peep, target)
	self:_updateAggressiveTarget(peep)

	if not success and success ~= nil then
		return
	end

	local spell
	if weapon:canCastSpells() then
		spell = self:_getPeepSpell(peep, weapon)
		if spell then
			spell:cast(peep, target)
		end
	end

	if not didUsePower then
		self:_givePeepZeal(peep)
	end
	self:_giveTargetZeal(peep, target)

	if spell then
		self:_takeSpellZeal(peep, spell, weapon)
	end

	local projectile = weapon:getProjectile(peep)
	if projectile then
		local stage = self:getDirector():getGameInstance():getStage()
		stage:fireProjectile(projectile, peep, target)
	end

	self:_tickPower(peep)
end

function CombatCortex:tick(delta)
	for peep in self:iterate() do
		if Utility.Peep.isEnabled(peep) then
			self:updatePeepCombatStyle(peep)
			self:updatePeepRecharge(delta, peep)
			self:updatePeepTarget(delta, peep)
			self:updatePeepStance(delta, peep)
			self:updatePeepCooldown(delta, peep)
			self:updateAggressivePeep(delta, peep)
		end
	end

	for peep in self:iterate() do
		if Utility.Peep.isEnabled(peep) then
			self:tickPeep(delta, peep)
		end
	end
end

function CombatCortex:update(delta)
	local tickDurationSeconds = Config.get("Combat", "TICK_DURATION_SECONDS")

	self.currentTime = self.currentTime + delta
	while self.currentTime > tickDurationSeconds do
		self.currentTime = self.currentTime - tickDurationSeconds

		self:tick(tickDurationSeconds)
	end
end

return CombatCortex
