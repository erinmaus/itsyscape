--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Renderer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local debug = require "debug"
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Resource = require "ItsyScape.Graphics.Resource"

local ResourceManager = Class()
ResourceManager.DESKTOP_FRAME_DURATION = 1 / 30
ResourceManager.MOBILE_FRAME_DURATION  = 1 / 10

function ResourceManager:new()
	self.resources = {}
	self.pending = {}

	if _MOBILE then
		self.frameDuration = ResourceManager.MOBILE_FRAME_DURATION
	else
		self.frameDuration = ResourceManager.DESKTOP_FRAME_DURATION
	end

	self.onPending = Callback()
	self.onUpdate = Callback()
	self.onFinish = Callback()
	self.wasPending = false

	self.fileIOThread = love.thread.newThread("ItsyScape/Graphics/Threads/Resource.lua")
	self.fileIOThread:start()
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

		local callback = top.callback
		local status = coroutine.status(callback)
		if status == 'suspended' then
			local success, error = coroutine.resume(callback)
			if not success then
				Log.warn("Error running coroutine: %s", error)
				if _DEBUG then
					Log.warn(debug.traceback(callback))
				end
			end
		elseif status == 'dead' then
			table.remove(self.pending, 1)
			count = count + 1
		end

		currentTime = love.timer.getTime()
	until currentTime > breakTime

	if currentTime and currentTime > breakTime then
		Log.debug('Resource loading spilled %d ms.', math.floor((currentTime - breakTime) * 1000))
	end

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

-- Queues a resource.
function ResourceManager:queue(resourceType, filename, callback, ...)
	if not Class.isDerived(resourceType, Resource) then
		error("expected Resource-derived type")
	end

	local load = Callback.bind(self._load, self, resourceType, filename, ...)
	local c = function()
		function wrappedCallback()
			local resource = load()
			if callback then
				callback(resource)
			end
		end

		local s, r = xpcall(wrappedCallback, debug.traceback)
		if not s then
			Log.warn("failed to load resource '%s': %s", filename, r)
		end
	end

	table.insert(self.pending, { filename = filename, callback = coroutine.create(c), traceback = _DEBUG and debug.traceback() })
end

-- Queues a CacheRef.
function ResourceManager:queueCacheRef(ref, callback, ...)
	self:queue(ref:getResourceType(), ref:getFilename(), callback, ...)
end

-- Queues a callback. No resource loading is performed.
function ResourceManager:queueEvent(callback, ...)
	callback = Callback.bind(callback, ...)
	local traceback = _DEBUG and debug.traceback()
	local c = function()
		local s, r = xpcall(callback, debug.traceback)
		if not s then
			Log.warn("Failed to run callback: %s", r)
			if traceback then
				Log.info(traceback)
			end
		end
	end

	table.insert(self.pending, { callback = coroutine.create(c), traceback = _DEBUG and debug.traceback() })
end

return ResourceManager
