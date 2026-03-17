--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Peep/Mashina.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Utility = require "ItsyScape.Game.Utility"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"

local Mashina = {}

function Mashina:onReady(director)
	local function setMashinaStates(records)
		if #records > 0 then
			local m = self:getBehavior(MashinaBehavior)
			if m then
				for i = 1, #records do
					local record = records[i]
					local state = record:get("State")
					local tree = record:get("Tree")
					local code = love.filesystem.load(tree)
					if code then
						m.states[state] = code()

						local default = record:get("IsDefault")
						if default and default ~= 0 and not m.currentState then
							m.currentState = state
						end
					else
						m.states[state] = nil
					end
				end
			end
		end
	end

	local gameDB = director:getGameDB()
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)

	if resource then
		setMashinaStates(gameDB:getRecords("PeepMashinaState", { Resource = resource }))
	end

	if mapObject then
		setMashinaStates(gameDB:getRecords("PeepMashinaState", { Resource = mapObject }))
	end
end

return Mashina
