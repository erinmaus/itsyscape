--------------------------------------------------------------------------------
-- Resources/Game/Actions/PartyTravel.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local OpenInterfaceCommand = require "ItsyScape.UI.OpenInterfaceCommand"
local Action = require "ItsyScape.Peep.Action"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"

local PartyTravel = Class(Action)
PartyTravel.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
PartyTravel.FLAGS ={
	['item-inventory'] = true,
	['item-equipment'] = true
}

function PartyTravel:perform(state, player, target)
	if target and
	   self:canPerform(state, PartyTravel.FLAGS) and
	   self:canTransfer(state, PartyTravel.FLAGS)
	then
		local i, j, k = Utility.Peep.getTile(target)
		local walk = Utility.Peep.getWalk(player, i, j, k, 2.5, { asCloseAsPossible = true })

		if walk then
			local perform = CallbackCommand(Action.perform, self, state, player)
			local open = OpenInterfaceCommand("PartyQuestion", true, self:getRaid())
			local command = CompositeCommand(true, walk, perform, open)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end

	return false
end

function PartyTravel:getRaid()
	local gameDB = self:getGameDB()
	local record = gameDB:getRecord("PartyTravelDestination", { Action = self:getAction() })
	if not record then
		return
	end

	return record:get("Raid"), record:get("AnchorOverride")
end

return PartyTravel
