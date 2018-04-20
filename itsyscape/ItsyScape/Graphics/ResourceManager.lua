--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Renderer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Resource = require "ItsyScape.Graphics.Resource"

local ResourceManager = Class()

function ResourceManager:new()
	self.resources = {}
end

-- Loads a Resource of the provided type from the file pointed at filename.
--
-- resourceType must be derived from Resource.
--
-- Immediately loads the resource. Returns the resource.
function ResourceManager:load(respourceType, filename, ...)
	if not Class.isCompatibleType(respourceType, Resource) then
		error("expected Resource-derived type")
	end

	local resourcesOfType = self.respourceType[resourceType] or {}
	if not resourcesOfType[filename] then
		local resource = resourceType()
		resource:loadFromFile(filename, self, ...)
		resourcesOfType[filename] = resource
		self.resources[resourceType] = resourcesOfType
	end

	return resourcesOfType[filename]
end

-- Like ResourceManager.load, but gets the resourceType and filename from the
-- CacheRef.
function ResourceManager:loadCacheRef(ref, ...)
	self:load(ref:getResourceType(), ref:getFilename(), ...)
end

-- Queues a resource. Not yet implemented.
function ResourceManager:queue(resourceType, filename, callback, ...)
	error("NYI")
end

-- Queues a CacheRef. Not yet implemented.
function ResourceManager:queueCacheRef(ref, callback, ...)
	self:queue(ref:getResourceType(), ref:getFilename(), callback, ...)
end

return ResourceManager
