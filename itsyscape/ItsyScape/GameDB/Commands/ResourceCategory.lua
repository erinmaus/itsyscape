--------------------------------------------------------------------------------
-- ItsyScape/GameDB/Commands/ResourceCategory.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Resource = require "ItsyScape.GameDB.Commands.Resource"

-- Category for Resources.
--
-- This is the backing logic for Game.Resource
--
-- Resources are created or updated via the ResourceCategory. When a new
-- ResourceType is created, it creates a new field with the ResourceType's name.
-- Then, when a Resource of the corresponding type is needed, the corresponding
-- field is called.
--
-- For example, say you have the ResourceType 'Item'. This would create a new
-- field, Game.Resource.Item. Now you want to create an Item called
-- "BrokenPlate". You'd call Game.Resource.Item "BrokenPlate" which would return
-- a Resource with the ResourceType Item that can be modified.
--
-- Resources are lazily constructed. This means they can be partially
-- defined across the GameDB construction script. Then when the GameDB is
-- instantiated, the Resource will be created in the GameDB at that time as well.
--
-- It also means a Resource can be referenced before it's defined. For example,
-- say you have ores and bars. The order the relationships are created won't
-- matter (e.g., smelt an iron ore to create an iron bar); you can define the
-- bar first or the ore first. The relationships will be properly generated upon
-- instantiation.
local ResourceCategory = Class()

function ResourceCategory:new(game)
	self._game = game
	self._resources = {}
end

-- Internal method. Adds a new field 'name' that constructs Resources of type
-- 'name'.
--
-- It is an error to create a field with an existing name.
function ResourceCategory:add(name)
	local resources = {}

	assert(self[name] == nil, string.format("'%s' already exists", name))

	local _C = {}
	_C.__call = function(_, resourceName)
		if not resources[resourceName] then
			local resourceType = self._game:getResourceType(name)

			local resource = Resource(resourceType, resourceName)

			table.insert(resources, resource)
			resources[resourceName] = resource
		end

		return resources[resourceName]
	end

	local C = {}
	C.Unique = function()
		local resourceType = self._game:getResourceType(name)
		local resourceName = string.format("*Unique %s #%d", name, #resources + 1)
		local resource = Resource(resourceType, resourceName)
		table.insert(resources, resource)

		return resource
	end

	self[name] = setmetatable(C, _C)
	table.insert(self._resources, resources)
	self._resources[name] = resources
end

-- Iterates over the fields, return (name, resources).

-- 'resources' is a map of a resource name to a Resource.
function ResourceCategory:iterate()
	local i = 1
	return function()
		local resource = self._resources[i]
		if resource then
			local name
			for key, value in pairs(self._resources) do
				if type(key) == 'string' and value == resource then
					name = key
					break
				end
			end

			i = i + 1
			print(name, resource)
			return name, resource
		end
	end
end

return ResourceCategory
