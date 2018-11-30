--------------------------------------------------------------------------------
-- Resources/Game/Actions/Runecraft.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local Action = require "ItsyScape.Peep.Action"

local Runecraft = Class(Action)
Runecraft.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Runecraft.FLAGS = {
	['item-inventory'] = true,
	['item-equipment'] = true
}

function Runecraft:perform(state, player, target)
	if not self:canPerform(state) or not self:canTransfer(state) then
		return false
	end

	if target then
		local i, j, k = Utility.Peep.getTile(target)
		local walk = Utility.Peep.getWalk(player, i, j, k, 1, { asCloseAsPossible = false })

		if walk then
			local count = self:count(state, player)

			local flags = {
				['item-inventory'] = true,
				['action-count'] = count
			}

			local make = CallbackCommand(self.transfer, self, state, player, flags)
			local command = CompositeCommand(true, walk, make)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end

	return false
end

function Runecraft:count(state, player)
	local max
	
	local gameDB = self:getGameDB()
	local brochure = gameDB:getBrochure()
	for input in brochure:getInputs(self.action) do
		local resource = brochure:getConstraintResource(input)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		local count = state:count(resourceType.name, resource.name, self.FLAGS)
		local actionCount = math.floor(count / input.count)
		max = math.min(max or math.huge, actionCount)
	end

	return max or 0
end

return Runecraft
