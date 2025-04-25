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

	local oldState = Utility.Peep.getMashinaState(orlando)
	local s = Utility.Combat.strafe(orlando, nil, distance, nil, function(_, target, s)
		if s then
			local wait = WaitCommand(0.5)
			local state = CallbackCommand(Utility.Peep.setMashinaState, orlando, oldState)
			local attack = CallbackCommand(Utility.Peep.attack, orlando, target)

			orlando:getCommandQueue():push(CompositeCommand(true, wait, state, attack))
		else
			Utility.Peep.setMashinaState(orlando, oldState)
			Utility.Peep.attack(orlando, target)
		end
	end)

	if s then
		Utility.Combat.disengage(orlando)
		Utility.Peep.setMashinaState(orlando, false)
	end

	return true
end

return Common
