--------------------------------------------------------------------------------
-- ItsyScape/Game/CacheRef.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local CacheRef, Metatable = Class()

-- Creates a new CacheRef of the provided resourceTypeID.
--
-- resourceTypeID should be the full type name. E.g., for an animation, it
-- should be "ItsyScape.Game.Animation.Animation".
--
-- The underlying resource type should implement what's called the Resource
-- contract; there should be a method, 'loadFromFile', that takes a
-- filename as a single argument. 'loadFromFile' should load the resource from
-- a file, even if the resource could not be found. However, if there is
-- an error loading the resource (other than file-not-found), the error should
-- be propagated.
--
-- filename is the full path to the resource.
function CacheRef:new(resourceTypeID, filename)
	self.resourceType = require(resourceTypeID)
	self.resourceTypeID = resourceTypeID
	self.filename = filename or ""
end

-- Gets the underlying type.
function CacheRef:getResourceType()
	return self.resourceType
end

-- Gets the resourceTypeID. See CacheRef.new.
function CacheRef:getResourceTypeID()
	return self.resourceTypeID
end

-- Gets the filename of the underlying resource.
function CacheRef:getFilename()
	return self.filename
end

-- Loads the resource. See CacheRef.new.
function CacheRef:load(...)
	local resource = self.resourceType()
	resource:loadFromFile(self.filename, ...)
	
	return resource
end

function Metatable.__eq(a, b)
	return a.resourceTypeID == b.resourceTypeID and a.filename == b.filename
end

return CacheRef

