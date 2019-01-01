--------------------------------------------------------------------------------
-- Resources/Game/Actions/Make.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Action = require "ItsyScape.Peep.Action"

local Make = Class(Action)
Make.SCOPES = { ['craft'] = true }
Make.FLAGS = { ['item-inventory'] = true }

function Make:canPerform(state, flags)
	return Action.canPerform(self, state, flags) and Action.canTransfer(self, state, flags)
end

function Make:count(state, flags)
	flags = flags or self.FLAGS

	local count
	local brochure = self:getGameDB():getBrochure()
	for input in brochure:getInputs(self.action) do
		local resource = brochure:getConstraintResource(input)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		if not state:has(resourceType.name, resource.name, input.count, flags) then
			return 0
		else
			if resourceType.name == "Item" then
				local resourceCount = state:count(resourceType.name, resource.name, flags)
				count = math.min(math.floor(resourceCount / input.count), count or math.huge)
			end
		end
	end

	return count or 0
end

function Make:make(state, player, prop)
	local flags = self.FLAGS

	self:transfer(state, player, flags)
	Action.perform(self, state, player)

	player:poke('resourceObtained', {})
end

return Make
