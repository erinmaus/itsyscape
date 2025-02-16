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
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PendingPowerBehavior = require "ItsyScape.Peep.Behaviors.PendingPowerBehavior"
local PowerCoolDownBehavior = require "ItsyScape.Peep.Behaviors.PowerCoolDownBehavior"
local WeaponBehavior = require "ItsyScape.Peep.Behaviors.WeaponBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local TilePathNode = require "ItsyScape.World.TilePathNode"

local CombatCortex = Class(Cortex)

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
end

function CombatCortex:removePeep(peep)
	Cortex.removePeep(self, peep)

	self.currentTarget[peep] = nil
	self.currentStance[peep] = nil
end

function CombatCortex:_getPeepTarget(peep)
	local combatTarget = peep:getBehavior(CombatTargetBehavior)
	combatTarget = combatTarget and combatTarget.actor
	combatTarget = combatTarget and combatTarget:getPeep()

	return combatTarget
end

function CombatCortex:_canPeepAttackTarget(selfPeep, targetPeep)
	return Utility.Peep.isAttackable(combatTarget) and
	       Utility.Peep.canAttack(combatTarget)
end

-- function CombatCortex:_getBoundingBox(rotation, position, size)
-- 	local halfSize = size / 2

-- 	local topLeft = 
-- end

function CombatCortex:_canPeepReachTarget(selfPeep, targetPeep, weaponRange)
	local targetInstance = Utility.Peep.getInstance(targetPeep)
	local selfInstance = Utility.Peep.getInstance(selfPeep)
	if targetInstance ~= selfInstance then
		return false
	end

	local map = Utility.Peep.getMap(selfPeep)
	local worldWeaponRange = map:getCellSize() * weaponRange

	local selfPosition = Utility.Peep.getAbsolutePosition(selfPeep)
	local targetPosition = Utility.Peep.getAbsolutePosition(targetPeep)

	local distance = selfPosition:distance(targetPosition)
	return distance < worldWeaponRange
end

function CombatCortex:_canPeepSeeTarget(selfPeep, targetPeep)
	local selfMap = Utility.Peep.getMap(selfPeep)

	local selfWorldTransform = Utility.Peep.getAbsoluteTransform(selfPeep)
	local targetWorldTransform = Utility.Peep.getAbsoluteTransform(targetPeep)

	local selfPosition = Utility.Peep.getPosition(selfPeep)
	local targetAbsolutePosition = Utility.Peep.getAbsolutePosition(targetPeep)
	local targetPosition = Vector(selfWorldTransform:inverseTransformPoint(targetAbsolutePosition:get()))

	local _, s, t = selfMap:getTileAt(targetPosition.x, targetPosition.z)
	local _, u, v = selfMap:getTileAt(selfPosition.x, selfPosition.z)

	local isSameTile = s == u and t == v
	local isLineOfSightClear = selfMap:lineOfSightPassable(u, v, s, t, true)

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
	if not self:_canPeepReachTarget(selfPeep, targetPeep, weaponRange) then
		return false
	end

	if not self:_canPeepSeeTarget(selfPeep, targetPeep) then
		return false
	end
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
	if isTargetDifferent and hasCurrentCombatTarget and isCooldownOver then
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

	local didUsePower = power:perform(selfPeep, targetPeep)
	if not didUsePower then
		return false
	end

	power:activate(selfPeep, targetPeep)
	power:removeBehavior(PendingPowerBehavior)

	selfPeep:poke("zeal", ZealPoke.onUsePower({
		power = power,
		zeal = zealCost
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

local BASE_STANCE_SWITCH_ZEAL_LOSS = Variables.Path("baseStanceSwitchZealLoss")
local BASE_STANCE_SWITCH_ZEAL_LOSS_COOLDOWN_SECONDS = Variables.Path("baseStanceSwitchZealLossCooldownSeconds")
function CombatCortex:updatePeepStance(delta, peep)
	local stance = peep:getBehavior(StanceBehavior)
	stance = stance and stance.stance
	stance = stance or Weapon.STANCE_CONTROLLED

	local currentStanceInfo = self.currentStance[peep]
	if not currentStanceInfo then
		currentStanceInfo = { cooldown = 0, stance = stance }
		self.currentStance[peep] = currentStanceInfo
	end
	currentStanceInfo.cooldown = math.max(currentStanceInfo.cooldown - delta, 0)

	local isStanceDifferent = currentStanceInfo.stance ~= stance
	local isCooldownOver = currentTargetInfo.cooldown <= 0

	-- Stance changed and cooldown has expired.
	-- Apply zeal loss penalty.
	if isStanceDifferent and isCooldownOver then
		peep:poke("zeal", ZealPoke.onStanceSwitch({
			previousStance = currentStanceInfo.stance,
			currentStance = stance,
			zeal = -self.config:get(BASE_STANCE_SWITCH_ZEAL_LOSS), 
		}))

		currentStanceInfo.cooldown = self.config:get(BASE_STANCE_SWITCH_ZEAL_LOSS_COOLDOWN_SECONDS)
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

function CombatCortex:tickPeep(peep)
	local target = self:_getPeepTarget(selfPeep)
	local equippedWeapon = self:_getPeepWeapon(selfPeep)

	if not target then
		self:_tryUsePower(peep, nil, equippedWeapon)
		return
	end

	local isWithinRange = self:_isPeepWithinRange(peep, target)
	local isAttackable = self:_canPeepAttackTarget(peep, target)
	if not (isWithinRange and isAttackable) then
		peep:removeBehavior(CombatTargetBehavior)
		return
	end

	self:_makePeepFaceTarget(peep)

	local _, powerXWeapon = self:_tryUsePower(peep, target, equippedWeapon)
	local weapon = powerXWeapon or equippedWeapon
	if not (weapon and Class.isCompatibleType(weapon, Weapon)) then
		return
	end

	local hasCooldown = peep:hasBehavior(AttackCooldownBehavior)
	if hasCooldown then
		return
	end


	local success = weapon:perform(peep, target)
	if not success then
		return
	end

	local projectile = weapon:getProjectile(peep)
	if projectile then
		local stage = self:getDirector():getGameInstance()
		stage:fireProjectile(projectile, peep, target)
	end
end

function CombatCortex:tickPeep(peep)
	local hasCooldown = peep:hasBehavior(AttackCooldownBehavior)
	if hasCooldown then
		return false
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
