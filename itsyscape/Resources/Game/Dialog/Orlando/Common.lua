--------------------------------------------------------------------------------
-- ItsyScape/Game/Dialog/Orlando/Common.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local Probe = require "ItsyScape.Peep.Probe"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local AggressiveBehavior = require "ItsyScape.Peep.Behaviors.AggressiveBehavior"
local CombatCortex = require "ItsyScape.Peep.Cortexes.CombatCortex2"

local Common = {}

function Common.quest_tutorial_orlando_has_lit_coconut_fire(dialog)
	local peep = dialog:getSpeaker("_TARGET")
	if not peep then
		return false
	end

	local coconutFires = peep:getDirector():probe(
		peep:getLayerName(),
		Probe.passage("Passage_FishingArea"),
		Probe.resource("Prop", "CoconutFire"))

	return #coconutFires >= 1
end

local DUMMY_RESOURCES = {
	[Weapon.STYLE_MAGIC] = "TutorialDummy_Wizard",
	[Weapon.STYLE_ARCHERY] = "TutorialDummy_Archery",
	[Weapon.STYLE_MELEE] = "TutorialDummy_Warrior"
}

function Common.quest_tutorial_orlando_has_dropped_dummy(dialog)
	local peep = dialog:getSpeaker("_TARGET")
	if not peep then
		return false
	end

	local class = Utility.Text.getDialogVariable(peep, "Orlando", "quest_tutorial_main_starting_player_class")
	local dummyResourceID = DUMMY_RESOURCES[class] or DUMMY_RESOURCES[Weapon.STYLE_MAGIC]

	local dummies = peep:getDirector():probe(
		peep:getLayerName(),
		Probe.resource("Peep", dummyResourceID),
		Probe.instance(Utility.Peep.getPlayerModel(peep)))

	local canAttackDummy = false
	for _, dummy in ipairs(dummies) do
		if Utility.Peep.canAttack(dummy) then
			canAttackDummy = true
			break
		end
	end

	return canAttackDummy
end

function Common.quest_tutorial_orlando_strafe_target(dialog, distance)
	local orlando = dialog:getSpeaker("Orlando")
	if not orlando then
		return false
	end

	local target = orlando:getBehavior(CombatTargetBehavior)
	if not (target and target.actor and target.actor:getPeep()) then
		return false
	end
	target = target.actor:getPeep()

	local orlandoPosition = Utility.Peep.getPosition(orlando) * Vector.PLANE_XZ
	local targetPosition = Utility.Peep.getPosition(target) * Vector.PLANE_XZ
	local direction = Quaternion.Y_90:transformVector(orlandoPosition:direction(targetPosition)):getNormal()

	local position = orlandoPosition + direction * distance
	local k = Utility.Peep.getLayer(orlando)

	orlando:getCommandQueue(CombatCortex.QUEUE):interrupt()
	orlando:removeBehavior(CombatTargetBehavior)

	local aggressive = orlando:getBehavior(AggressiveBehavior)
	if aggressive then
		aggressive.pendingTarget = false
		aggressive.pendingResponseTime = 0
	end


	local callback = Utility.Peep.queueWalk(orlando, position.x, position.z, k, math.huge, { asCloseAsPossible = true, isPosition = true })
	callback:register(function(s)
		Utility.Peep.setMashinaState(orlando, false)

		if s then
			local wait = WaitCommand(0.5)
			local attack = CallbackCommand(Utility.Peep.attack, orlando, target)

			orlando:getCommandQueue():push(CompositeCommand(true, wait, attack))
		end
	end)
	return true
end

return Common
