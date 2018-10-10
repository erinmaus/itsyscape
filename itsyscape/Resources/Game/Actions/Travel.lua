--------------------------------------------------------------------------------
-- Resources/Game/Actions/Travel.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local Action = require "ItsyScape.Peep.Action"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"

local Travel = Class(Action)
Travel.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Travel.FLAGS ={
	['item-inventory'] = true,
	['item-equipment'] = true
}

function Travel:perform(state, player, target)
	if target and
	   self:canPerform(state, Travel.FLAGS) and
	   self:canTransfer(state, Travel.FLAGS)
	then
		local i, j, k = Utility.Peep.getTile(target)
		local walk = Utility.Peep.getWalk(player, i, j, k, 1)

		if walk then
			local travel = CallbackCommand(self.travel, self, state, player, target)
			local command = CompositeCommand(true, walk, travel)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end
end

function Travel:travel(state, peep, target)
	local gameDB = self:getGameDB()
	local record = gameDB:getRecord("TravelDestination", { Action = self:getAction() })
	if not record then
		return
	end

	local map = record:get("Map")

	if not map then
		return
	end

	local destination = record:get("Anchor")
	if not destination then
		return
	end

	if not self:canTransfer(state, peep, Travel.FLAGS) then
		return
	end
	
	self:transfer(state, peep, Travel.FLAGS)

	local stage = self:getGame():getStage()
	stage:movePeep(peep, map.name, destination)

	peep:getCommandQueue():clear()
	peep:removeBehavior(TargetTileBehavior)
end

return Travel
