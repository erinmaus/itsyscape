--------------------------------------------------------------------------------
-- Resources/Game/Makes/Chop.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local GatherResourceCommand = require "ItsyScape.Game.GatherResourceCommand"
local Utility = require "ItsyScape.Game.Utility"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"
local Make = require "Resources.Game.Actions.Make"

local Chop = Class(Make)
Chop.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Chop.FLAGS = {
	['item-equipment'] = true,
	['item-inventory'] = true,
	['item-drop-excess'] = true
}

function Chop:perform(state, player, prop)
	return self:gather(state, player, prop, "hatchet", "woodcutting")
end

function Chop:getFailureReason(state, player)
	local reason = Make.getFailureReason(self, state, player)

	table.insert(reason.requirements, {
		type = "Item",
		resource = "BronzeHatchet",
		name = "Hatchet (any kind you can equip)",
		count = 1
	})

	return reason
end

return Chop
