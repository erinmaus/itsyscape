--------------------------------------------------------------------------------
-- Resources/Game/Actions/QuestStart.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Action = require "ItsyScape.Peep.Action"

local QuestStart = Class(Action)
QuestStart.SCOPES = { ['quest'] = true }
QuestStart.FLAGS = { ['x-ignore-quest'] = true }

function QuestStart:perform(state, peep)
	if self:canPerform(state, peep) and self:canTransfer(state, peep) then
		return self:transfer(state, peep)
	end

	return false
end

function QuestStart:didStart(state, peep)
	local gameDB = self:getGameDB()
	local brochure = gameDB:getBrochure()

	for output in brochure:getOutputs(self:getAction()) do
		local resource = brochure:getConstraintResource(output)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		if resourceType.name == "KeyItem" and not state:has("KeyItem", resource.name) then
			return false
		end
	end

	return true
end

return QuestStart
