--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Combat.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local CurveConfig = require "ItsyScape.Game.CurveConfig"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local ZealPoke = require "ItsyScape.Game.ZealPoke"
local AggressiveBehavior = require "ItsyScape.Peep.Behaviors.AggressiveBehavior"
local CombatChargeBehavior = require "ItsyScape.Peep.Behaviors.CombatChargeBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local PendingPowerBehavior = require "ItsyScape.Peep.Behaviors.PendingPowerBehavior"
local PowerRechargeBehavior = require "ItsyScape.Peep.Behaviors.PowerRechargeBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local CombatCortex = require "ItsyScape.Peep.Cortexes.CombatCortex2"

-- Contains utility methods that deal with combat.
local Combat = {}

Combat.DEFAULT_STRAFE_ROTATIONS = {
	Quaternion.Y_90,
	Quaternion.Y_270
}

function Combat.disengage(peep)
	Utility.Peep.cancelWalk(peep)

	local charge = peep:getBehavior(CombatChargeBehavior)
	if charge then
		peep:removeBehavior(CombatChargeBehavior)
		peep:removeBehavior(TargetTileBehavior)
	end

	peep:getCommandQueue(CombatCortex.QUEUE):interrupt()
	peep:removeBehavior(CombatTargetBehavior)

	local aggressive = peep:getBehavior(AggressiveBehavior)
	if aggressive then
		aggressive.pendingTarget = false
		aggressive.pendingResponseTime = 0
	end
end

function Combat.strafe(peep, target, distance, rotations, onStrafe)
	if not target then
		local possibleTarget = peep:getBehavior(CombatTargetBehavior)
		if not (possibleTarget and possibleTarget.actor and possibleTarget.actor:getPeep()) then
			return false
		end
		target = possibleTarget.actor:getPeep()
	end

	local pendingRotations = {}
	do
		rotations = rotations or Combat.DEFAULT_STRAFE_ROTATIONS
		for _, rotation in ipairs(rotations) do
			table.insert(pendingRotations, rotation)
		end
	end

	local map = Utility.Peep.getMap(peep)
	local selfI, selfJ, selfK = Utility.Peep.getTile(peep)

	while #pendingRotations >= 1 do
		local rotation = table.remove(pendingRotations, love.math.random(#pendingRotations))

		local peepPosition = Utility.Peep.getAbsolutePosition(peep) * Vector.PLANE_XZ
		local direction
		if Class.isCompatibleType(target, Vector) then
			direction = rotation:transformVector(target):getNormal()
		else
			local targetPosition = Utility.Peep.getAbsolutePosition(target) * Vector.PLANE_XZ
			direction = rotation:transformVector(peepPosition:direction(targetPosition)):getNormal()
		end

		local ray = Ray(Utility.Peep.getPosition(peep), direction)
		local position = ray:project(distance)

		local previousI, previousJ
		local isPassable = map:castRay(ray, function(_, tileI, tileJ, _, _, d)
			if previousI and previousJ and not map:canMove(previousI, previousJ, tileI - previousI, tileJ - previousJ) then
				return false
			end

			previousI = tileI
			previousJ = tileJ

			if d > distance then
				return true
			end
		end)

		if isPassable then
			local callback, n = Utility.Peep.queueWalk(peep, position.x, position.z, selfK, math.huge, { asCloseAsPossible = true, isPosition = true })
			callback:register(function(s)
				if onStrafe then
					onStrafe(peep, target, s)
				end
			end)

			return true, n
		end
	end

	return false, nil
end

function Combat.deflectPendingPower(power, activator, target)
	

	if target and target:hasBehavior(PendingPowerBehavior) then
		local pendingPower = target:getBehavior(PendingPowerBehavior)
		if pendingPower.power then
			local pendingPowerID = pendingPower.power:getResource().name

			Log.info("%s (activated by '%s') negated pending power '%s' on target '%s'.",
				power:getResource().name,
				activator:getName(),
				pendingPowerID,
				target:getName())

			local rechargeCost = pendingPower.power:getCost(target)
			local _, recharge = target:addBehavior(PowerRechargeBehavior)
			recharge.powers[pendingPowerID] = math.max(recharge.powers[pendingPowerID] or 0, rechargeCost)

			target:poke("zeal", ZealPoke.onLosePower({
				power = pendingPower.power,
				zeal = -rechargeCost
			}))

			target:poke("powerDeflected", {
				activator = activator,
				power = pendingPower.power,
				action = pendingPower.power:getAction()
			})

			target:removeBehavior(PendingPowerBehavior)

			return pendingPower.power
		end
	end
end

function Combat.getCombatLevel(peep)
	local stats = peep:getBehavior(StatsBehavior)
	if stats and stats.stats then
		local constitution, faith
		do
			local status = peep:getBehavior(CombatStatusBehavior)
			if status then
				constitution = status.maximumHitpoints
				faith = status.maximumPrayer
			else
				constitution = 1
				faith = 1
			end
		end

		stats = stats.stats
		local base = (
			stats:getSkill("Defense"):getBaseLevel() +
			math.max(stats:getSkill("Constitution"):getBaseLevel(), constitution) +
			math.floor(math.max(stats:getSkill("Faith"):getBaseLevel(), faith) / 2 + 0.5)) / 2
		local melee = (stats:getSkill("Attack"):getBaseLevel() + stats:getSkill("Strength"):getBaseLevel()) / 2
		local magic = (stats:getSkill("Magic"):getBaseLevel() + stats:getSkill("Wisdom"):getBaseLevel()) / 2
		local ranged = (stats:getSkill("Archery"):getBaseLevel() + stats:getSkill("Dexterity"):getBaseLevel()) / 2
		return math.floor(base + math.max(melee, magic, ranged) + 0.5)
	end

	return 0
end

function Combat.getCombatXP(peep)
	local stats = peep:getBehavior(StatsBehavior)
	do
		stats = stats and stats.stats
		if not stats then
			return 0
		end
	end

	local hitpoints
	do
		local status = peep:getBehavior(CombatStatusBehavior)
		hitpoints = status and status.maximumHitpoints
		if not hitpoints then
			return 0
		end

		hitpoints = math.min(hitpoints, 100000)
	end

	local tier
	do
		local melee = (stats:getSkill("Attack"):getWorkingLevel() + stats:getSkill("Strength"):getWorkingLevel()) / 2
		local magic = (stats:getSkill("Magic"):getWorkingLevel() + stats:getSkill("Wisdom"):getWorkingLevel()) / 2
		local ranged = (stats:getSkill("Archery"):getWorkingLevel() + stats:getSkill("Dexterity"):getWorkingLevel()) / 2

		tier = math.max(melee, magic, ranged)
		tier = math.min(tier, 100)
	end

	local xpForTier
	do
		local point1 = Utility.RESOURCE_CURVE(tier)
		local point2 = Utility.RESOURCE_CURVE(tier + 1)
		xpForTier = point2 - point1
	end

	local xpFromTier
	do
		local tierDivisor = CurveConfig.CombatXP:evaluate(tier)
		tierDivisor = math.max(tierDivisor, CurveConfig.CombatXP.C)

		xpFromTier = math.floor(xpForTier / tierDivisor)
	end

	local xpFromHitpoints = CurveConfig.HealthXP:evaluate(hitpoints)

	local totalXP = xpFromTier + xpFromHitpoints
	return totalXP, xpFromTier, xpFromHitpoints
end

function Combat.giveCombatXP(peep, xp)
	local stance = peep:getBehavior(StanceBehavior)
	if not stance then
		return
	else
		stance = stance.stance
	end

	local weapon = Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_RIGHT_HAND) or
		Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_TWO_HANDED)

	local strength, accuracy
	if weapon then
		local logic = peep:getDirector():getItemManager():getLogic(weapon:getID())
		if logic:isCompatibleType(Weapon) then
			local _, s, a = logic:getSkill(Weapon.PURPOSE_KILL)
			strength = s
			accuracy = a
		end
	end

	if not strength or not accuracy then
		strength = "Strength"
		accuracy = "Attack"
	end

	if stance == Weapon.STANCE_AGGRESSIVE then
		peep:getState():give("Skill", strength, math.floor(xp + 0.5))
	elseif stance == Weapon.STANCE_CONTROLLED then
		peep:getState():give("Skill", accuracy, math.floor(xp + 0.5))
	elseif stance == Weapon.STANCE_DEFENSIVE then
		peep:getState():give("Skill", "Defense", math.floor(xp + 0.5))
	end

	peep:getState():give("Skill", "Constitution", math.floor(xp / 3 + 0.5))
end

-- Calculates the maximum hit given the level (including boosts), multiplier,
-- and equipment strength bonus.
function Combat.calcMaxHit(level, multiplier, bonus)
	return math.max(math.floor(0.5 + level * multiplier * (bonus + 64) / 640), 1)
end

function Combat.calcAccuracyRoll(level, bonus)
	return (level + 16) * (bonus + 64) * 4
end

function Combat.calcDefenseRoll(level, bonus)
	return (level + 8) * (bonus + 128)
end

function Combat.calcBoost(level, minLevel, maxLevel, minBoost, maxBoost)
	local delta = math.min((math.max(level, minLevel) - minLevel) / (maxLevel - minLevel), 1)
	return minBoost + (maxBoost - minBoost) * delta
end

return Combat
