--------------------------------------------------------------------------------
-- Resources/Game/Actions/Light.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Action = require "ItsyScape.Peep.Action"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local Light = Class(Action)
Light.SCOPES = { ["inventory"] = true }
Light.QUEUE = {}
Light.DURATION = 1.0

Light.DIRECTIONS = {
	{ -1, 0 },
	{ 1, 0 },
	{ 0, -1 },
	{ 0, 1 }
}

function Light:perform(state, peep, item)
	local gameDB = self:getGame():getGameDB()
	if self:canPerform(state) and self:canTransfer(state) then
		local light = CallbackCommand(self.transfer, self, peep:getState(), peep, { ["item-inventory"] = true, ["item-instances"] = { item } })
		local wait = WaitCommand(Light.DURATION, false)

		local walkCommand
		do
			local selfI, selfJ = Utility.Peep.getTile(peep)
			local map = Utility.Peep.getMap(peep)

			for _, direction in pairs(Light.DIRECTIONS) do
				local di, dj = unpack(direction)

				if map:canMove(selfI, selfJ, di, dj) then
					local targetI, targetJ = selfI + di, selfJ + dj

					walkCommand = CallbackCommand(function()
						local walk = Utility.Peep.queueWalk(peep, targetI, targetJ, Utility.Peep.getLayer(peep))

						local done = false
						walk:register(function(s)
							done = true
						end)

						peep:getCommandQueue():push(
							CompositeCommand(
								function()
									return not done
								end,
								WaitCommand(math.huge))
							)
					end)

					break
				end
			end
		end

		local perform = CallbackCommand(Action.perform, self, state, peep)

		local queue = peep:getCommandQueue()
		local success = queue:interrupt(light) and queue:push(perform) and queue:push(wait)
		if success and walkCommand then
			success = queue:push(walkCommand)
		end

		if success then
			return success
		end
	end

	return false
end

return Light
