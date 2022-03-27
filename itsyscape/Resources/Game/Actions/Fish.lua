--------------------------------------------------------------------------------
-- Resources/Game/Makes/Fish.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local GatherResourceCommand = require "ItsyScape.Game.GatherResourceCommand"
local Utility = require "ItsyScape.Game.Utility"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"
local Make = require "Resources.Game.Actions.Make"

local Fish = Class(Make)
Fish.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Fish.MAX_DISTANCE = 4
Fish.FLAGS = {
	['item-equipment'] = true,
	['item-inventory'] = true,
	['item-drop-excess'] = true
}

function Fish:perform(state, player, prop)
	return self:gather(state, player, prop, "fishing-rod", "fishing")
end

function Fish:getFailureReason(state, player)
	local reason = Make.getFailureReason(self, state, player)

	table.insert(reason.requirements, {
		type = "Item",
		resource = "WimpyFishingRod",
		name = "Fishing rod (any kind you can equip)",
		count = 1
	})

	return reason
end

return Fish
