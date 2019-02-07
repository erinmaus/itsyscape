--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Renderer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Resource = require "ItsyScape.Graphics.Resource"

local ResourceManager = Class()

function ResourceManager:new()
	self.resources = {}
	self.pending = {}
	self.frameDuration = 1 / 60
	self.onPending = Callback()
	self.onUpdate = Callback()
	self.onFinish = Callback()
	self.wasPending = false
end

-- Sets the frame duration, in seconds.
function ResourceManager:setFrameDuration(value)
	self.frameDuration = value or self.frameDuration
end

-- Returns true if pending resources are in the queue, false otherwise.
function ResourceManager:getIsPending()
	return #self.pending > 0, #self.pending
end

-- Loads async resources.
function ResourceManager:update()
	local breakTime = love.timer.getTime() + self.frameDuration
	local currentTime

	if self:getIsPending() and not self.wasPending then
		self.onPending(self, #self.pending)
		self.wasPending = true
	end

	local count = 0
	repeat
		local top = self.pending[1]
		if not top then
			break
		end

		local s, r = xpcall(top.callback, debug.traceback)
		if not s then
			if top.filename then
				Log.warn("failed to load resource '%s': %s", top.filename, r)
			else
				Log.warn("failed to run event: %s", r)
			end
		end

		table.remove(self.pending, 1)
		count = count + 1

		currentTime = love.timer.getTime()
	until currentTime > breakTime

	if count > 0 then
		self.onUpdate(count, #self.pending)
	end

	if #self.pending == 0 and self.wasPending then
		self.onFinish(self)
		self.wasPending = false
	end
end

-- This actually performs the load.
function ResourceManager:_load(resourceType, filename, ...)
	local resourcesOfType = self.resources[resourceType] or setmetatable({}, { __mode = 'v' })
	if not resourcesOfType[filename] then
		local resource = resourceType()
		resource:loadFromFile(filename, self, ...)
		resourcesOfType[filename] = resource
		self.resources[resourceType] = resourcesOfType
	end

	return resourcesOfType[filename]
end

function ResourceManager:_blockingLoad(resourceType, filename, ...)
	-- We delegate to _blockingLoad so this warning is consistent.
	do
		local info = debug.getinfo(2, "Sl")
		Log.warn(
			"blocking resource load in function '%s' @ %s:%d (%s)",
			info.name or "anonymous function",
			info.short_src,
			info.currentline,
			info.what)
	end

	return self:_load(resourceType, filename, ...)
end

-- Loads a Resource of the provided type from the file pointed at filename.
--
-- resourceType must be derived from Resource.
--
-- Immediately loads the resource. Returns the resource.
function ResourceManager:load(resourceType, filename, ...)
	if not Class.isDerived(resourceType, Resource) then
		error("expected Resource-derived type")
	end

	return self:_blockingLoad(resourceType, filename, ...)
end

-- Like ResourceManager.load, but gets the resourceType and filename from the
-- CacheRef.
function ResourceManager:loadCacheRef(ref, ...)
	return self:_blockingLoad(ref:getResourceType(), ref:getFilename(), ...)
end

-- Queues a resource. Not yet implemented.
function ResourceManager:queue(resourceType, filename, callback, ...)
	if not Class.isDerived(resourceType, Resource) then
		error("expected Resource-derived type")
	end

	local load = Callback.bind(self._load, self, resourceType, filename, ...)
	local c = function()
		local resource = load()
		if callback then
			callback(resource)
		end
	end

	table.insert(self.pending, { filename = filename, callback = c })
end

-- Queues a CacheRef. Not yet implemented.
function ResourceManager:queueCacheRef(ref, callback, ...)
	self:queue(ref:getResourceType(), ref:getFilename(), callback, ...)
end

-- Queues a callback. No resource loading is performed.
function ResourceManager:queueEvent(callback, ...)
	callback = Callback.bind(callback, ...)

	table.insert(self.pending, { callback = callback })
end

return ResourceManager
