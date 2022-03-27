--------------------------------------------------------------------------------
-- Resources/Game/Makes/Mine.lua
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

local Mine = Class(Make)
Mine.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Mine.FLAGS = {
	['item-inventory'] = true,
	['item-drop-excess'] = true
}

function Mine:perform(state, player, prop)
	return self:gather(state, player, prop, "pickaxe", "mining")
end

function Mine:getFailureReason(state, player)
	local reason = Make.getFailureReason(self, state, player)

	table.insert(reason.requirements, {
		type = "Item",
		resource = "BronzePickaxe",
		name = "Pickaxe (any kind you can equip)",
		count = 1
	})

	return reason
end

return Mine
