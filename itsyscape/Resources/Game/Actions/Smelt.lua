--------------------------------------------------------------------------------
-- Resources/Game/Actions/Smelt.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Action = require "ItsyScape.Peep.Action"

local Smelt = Class(Action)
Smelt.SCOPES = { ['craft'] = true }

function Smelt:canPerform(state, flags)
	if Action.canPerform(self, state, flags) then
		local brochure = self:getGameDB():getBrochure()
		for input in brochure:getInputs(self.action) do
			local resource = brochure:getConstraintResource(input)
			local resourceType = brochure:getResourceTypeFromResource(resource)

			if not state:has(resourceType.name, resource.name, input.count, flags) then
				Log.info(
					"Input not met; need %d of %s %s",
					input.count,
					resourceType.name,
					resource.name)
				return false
			end
		end

		return true
	end

	return false
end

function Smelt:perform(state, player, prop)
	if not self:canPerform(state) then
		return false
	end

	-- Nothing.
end

return Smelt
