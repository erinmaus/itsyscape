--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/Property.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Property = Class()

function Property:new(...)
	self.defaultValue = { n = select('#', ...), ... }
end

function Property:getDefaultValue()
	return unpack(self.defaultValue, 1, self.defaultValue.n)
end

function Property:filter(...)
	return ...
end

Property.Actions = Class(Property)
function Property.Actions:filter(actions)
	local result = {}
	for i = 1, #actions do
		local action = actions[i]
		if action.instance.SCOPES['world'] then
			table.insert(result, {
				id = action.id,
				type = action.type,
				verb = action.verb
			})
		end
	end

	return result
end

return Property
