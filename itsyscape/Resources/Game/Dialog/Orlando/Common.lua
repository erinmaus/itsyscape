--------------------------------------------------------------------------------
-- ItsyScape/Game/Dialog/Orlando/Common.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Utility = require "ItsyScape.Game.Utility"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local Probe = require "ItsyScape.Peep.Probe"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"

local Common = {}

function Common.quest_tutorial_orlando_has_lit_fire(dialog)
	local peep = dialog:getSpeaker("_TARGET")
	if not peep then
		return false
	end

	local balsaFires = peep:getDirector():probe(
		peep:getLayerName(),
		Probe.passage("Passage_FishingArea"),
		Probe.resource("Prop", "BalsaFire"))

	return #balsaFires >= 1
end

function Common.quest_tutorial_is_orlando_dueling(dialog)
	local orlando = dialog:getSpeaker("Orlando")
	if not orlando then
		return false
	end

	local mashinaState = Utility.Peep.getMashinaState(orlando)
	if mashinaState == "tutorial-eat" or mashinaState == "tutorial-rite" or mashinaState == "tutorial-deflect" or mashinaState == "tutorial-yield" then
		return true
	end
	
	return false
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
