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
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local Light = Class(Action)
Light.SCOPES = { ['inventory'] = true }
Light.QUEUE = {}
Light.DURATION = 1.0

function Light:perform(state, peep, item)
	local gameDB = self:getGame():getGameDB()
	if self:canPerform(state) then
		local light = CallbackCommand(self.transfer, self, peep:getState(), peep, { ['item-inventory'] = true })
		local wait = WaitCommand(Light.DURATION, false)

		local walk
		do
			local position = peep:getBehavior(PositionBehavior)
			if position then
				local layer = position.layer or 1
				local map = peep:getDirector():getMap(layer)
				if map then
					local tile, i, j = map:getTileAt(position.position.x, position.position.z)
					if tile:hasFlag('blocking') then
						Log.info("(%d, %d) is blocking; cannot light fire.", i, j)
						return false
					end

					if map:canMove(i, j, -1, 0) then
						walk = Utility.Peep.getWalk(peep, i - 1, j, layer, 0)
					end
				end
			end
		end

		local perform = CallbackCommand(Action.perform, self, state, peep)

		local queue = peep:getCommandQueue()
		local success = queue:interrupt(light) and queue:push(wait) and queue:push(perform)
		if success and walk then
			return queue:push(walk)
		else
			return success
		end
	end

	return false
end

return Light
