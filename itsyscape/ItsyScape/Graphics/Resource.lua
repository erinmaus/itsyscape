--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Resource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"

-- Constructs a Resource type.
--
-- This object functions semantically like ItsyScape.Common.Class.
--
-- Since Resource is abstract, it cannot (and should not) be instantiated.
-- Instead, derived types should be instantiated.
--
-- A Resource has a few static fields and methods:
--  * CURRENT_ID: The ID of the next resource. In this sense, CURRENT_ID
--                represents the *pending* current ID.
--  * allocateID: Returns and post-increments CURRENT_ID. CURRENT_ID should be
--                one more than the return value. For example, if allocateID()
--                returns 1, CURRENT_ID will now be 2.
local Resource = Class()

-- Constructor. Allocates a new ID for the Resource, bumping CURRENT_ID.
function Resource:new()
	self.id = self:getType().allocateID()
end

-- Gets the underyling Resource.
function Resource:getResource()
	return Class.ABSTRACT()
end

-- Releases the underlying Resource.
function Resource:release()
	return Class.ABSTRACT()
end

-- Loads the underyling resource from 'filename'.
function Resource:loadFromFile(filename)
	return Class.ABSTRACT()
end

-- Returns a boolean value indicating if the resource is ready (e.g., loaded).
function Resource:getIsReady()
	return Class.ABSTRACT()
end

-- Returns the ID of the resource.
--
-- The resource ID is an incrementing value, never re-used, that represents
-- a loaded resource.
function Resource:getID()
	return self.id
end

-- Override the constructor to create a new type, not a new instance.
local function __call(self, ...)
	local DerivedResource = Class(Resource, ...)
	DerivedResource.CURRENT_ID = 1
	function DerivedResource.allocateID()
		local result = DerivedResource.CURRENT_ID
		DerivedResource.CURRENT_ID = DerivedResource.CURRENT_ID + 1

		return result
	end

	return DerivedResource
end

getmetatable(Resource).__call = __call

return Resource
