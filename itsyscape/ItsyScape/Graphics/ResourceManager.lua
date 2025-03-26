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
local Function = require "ItsyScape.Common.Function"
local Class = require "ItsyScape.Common.Class"
local Resource = require "ItsyScape.Graphics.Resource"

local ResourceManager = Class()
ResourceManager.DESKTOP_FRAME_DURATION     = _DEBUG == "plus" and 1 or 1 / 30
ResourceManager.MOBILE_FRAME_DURATION      = 1 / 10
ResourceManager.MAX_TIME_FOR_SYNC_RESOURCE = _DEBUG == "plus" and 1 or 1 / 1000

ResourceManager.FILE_IO_THREADS = 4

ResourceManager.View = Class()

function ResourceManager.View:new(resourceManager)
	self.resourceManager = resourceManager

	self.pending = {}
	self.pendingIndex = 0

	self.resourceManager:queueAsyncEvent(self._poll, self)

	self.isDone = false
end

function ResourceManager.View:getIsPending()
	return not self.isDone, #self.pending
end

function ResourceManager.View:_poll()
	local currentIndex = 1

	while currentIndex <= #self.pending do
		local pending = self.pending[currentIndex]

		if pending.ready then
			if pending.resource then
				pending.callback(pending.resource)
			else
				pending.callback()
			end

			currentIndex = currentIndex + 1
		end

		coroutine.yield()
	end

	self.isDone = true
end

function ResourceManager.View:_done(index, resource)
	self.pending[index].ready = true
	self.pending[index].resource = resource
end

function ResourceManager.View:queue(resourceType, filename, callback, ...)
	self.pendingIndex = self.pendingIndex + 1
	local index = self.pendingIndex

	self.pending[index] = { callback = callback, filename = filename }

	self.resourceManager:queueAsync(
		resourceType,
		filename,
		Function(self._done, self, index),
		...)
end

function ResourceManager.View:queueAsync(...)
	self.resourceManager:queueAsync(...)
end

function ResourceManager.View:queueCacheRef(ref, callback, ...)
	self:queue(ref:getResourceType(), ref:getFilename(), callback, ...)
end

function ResourceManager.View:queueAsyncCacheRef(...)
	self.resourceManager:queueAsyncCacheRef(...)
end

function ResourceManager.View:queueEvent(callback, ...)
	self.pendingIndex = self.pendingIndex + 1
	local index = self.pendingIndex

	self.pending[index] = { callback = Function(callback, ...), ready = true }
end

function ResourceManager.View:queueAsyncEvent(...)
	self.resourceManager:queueAsyncEvent(...)
end

function ResourceManager:new()
	self.resources = {}
	self.cache = {}

	self.loadStats = {}
	self.pendingSyncEvents = {}
	self.pendingAsyncEvents = {}
	self.pendingResources = {}

	if _MOBILE then
		self.frameDuration = ResourceManager.MOBILE_FRAME_DURATION
	else
		self.frameDuration = ResourceManager.DESKTOP_FRAME_DURATION
	end

	self.onPending = Callback(false)
	self.onUpdate = Callback(false)
	self.onFinish = Callback(false)
	self.wasPending = false

	self.fileIOThreads = {}
	for i = 1, self.FILE_IO_THREADS do
		local fileIOThread = love.thread.newThread("ItsyScape/Graphics/Threads/Resource.lua")
		fileIOThread:start(i)

		table.insert(self.fileIOThreads, fileIOThread)
	end
end

function ResourceManager:quit()
	for i = 1, self.FILE_IO_THREADS do
		Resource.quit()
	end
end

function ResourceManager:clear()
	table.clear(self.cache)
end

-- Sets the frame duration, in seconds.
function ResourceManager:setFrameDuration(value)
	self.frameDuration = value or self.frameDuration
end

-- Returns true if pending resources are in the queue, false otherwise.
function ResourceManager:getIsPending()
	return #self.pendingSyncEvents > 0 or #self.pendingAsyncEvents > 0, #self.pendingSyncEvents + #self.pendingAsyncEvents
end

-- Loads async resources.
function ResourceManager:update()
	local updateStartTime = love.timer.getTime()

	if self:getIsPending() and not self.wasPending then
		self.onPending(self, #self.pendingSyncEvents + #self.pendingAsyncEvents)
		self.wasPending = true
	end

	do
		local index = 1
		while index <= #self.pendingResources do
			local pending = self.pendingResources[index]
			local callback = pending.callback
			local status = coroutine.status(callback)

			if status == "suspended" then
				local before = love.timer.getTime()
				local memoryBefore = collectgarbage("count")
				local success, result = coroutine.resume(callback)
				local memoryAfter = collectgarbage("count")
				local after = love.timer.getTime()

				pending.totalTime = (pending.totalTime or 0) + (after - before) * 1000
				pending.memory = (pending.memory or 0) + (memoryAfter - memoryBefore)

				if not success then
					Log.warn("Error running coroutine: %s", result)
					if _DEBUG then
						Log.warn(debug.traceback(callback))
					end
				end

				if coroutine.status(callback) == "dead" then
					if pending.filename or pending.traceback then
						Log.debug("Preloaded resource (%f ms, %f kb) %s.", pending.totalTime, pending.memory, pending.filename or pending.traceback)
					end

					pending.resource = result
					pending.done = true

					table.remove(self.pendingResources, index)
				else
					index = index + 1
				end
			end
		end
	end

	local currentTime = love.timer.getTime()
	local pendingAsyncEventBreakTime = currentTime + self.frameDuration

	do
		local index = 1
		while index <= #self.pendingAsyncEvents and currentTime < pendingAsyncEventBreakTime do
			local pending = self.pendingAsyncEvents[index]
			local callback = pending.callback
			local status = coroutine.status(callback)

			if status == "suspended" then
				local before = love.timer.getTime()
				local memoryBefore = collectgarbage("count")
				local success, result = coroutine.resume(callback)
				local memoryAfter = collectgarbage("count")
				local after = love.timer.getTime()

				pending.totalTime = (pending.totalTime or 0) + (after - before) * 1000
				pending.memory = (pending.memory or 0) + (memoryAfter - memoryBefore)

				if not success then
					Log.warn("Error running coroutine: %s", result)
					if _DEBUG then
						Log.warn(debug.traceback(callback))
					end
				end

				if coroutine.status(callback) == "dead" then
					if pending.filename or pending.traceback then
						Log.debug("Loaded async resource/event (%f ms, %f kb):  %s.", pending.totalTime or 0, pending.memory or 0, pending.filename or pending.traceback)
					end

					table.remove(self.pendingAsyncEvents, index)
				else
					index = index + 1
				end
			end

			currentTime = love.timer.getTime()
		end
	end


	currentTime = love.timer.getTime()
	local pendingSyncEventBreakTime = currentTime + self.frameDuration

	local count = 0
	local elapsedTimeForSingleResource = 0
	repeat
		local top = self.pendingSyncEvents[1]
		if not top then
			break
		end

		local callback = top.callback
		local status = coroutine.status(callback)
		if status == 'suspended' then
			local before = love.timer.getTime()
			local memoryBefore = collectgarbage("count")
			local success, result = coroutine.resume(callback)
			local memoryAfter = collectgarbage("count")
			local after = love.timer.getTime()

			top.totalTime = (top.totalTime or 0) + (after - before) * 1000
			top.memory = (top.memory or 0) + (memoryAfter - memoryBefore)

			elapsedTimeForSingleResource = after - before

			if not success then
				Log.warn("Error running coroutine: %s", error)
				if _DEBUG then
					Log.warn(debug.traceback(callback))
				end
			end
		end

		status = coroutine.status(callback)
		if status == 'dead' then
			if top.filename or top.traceback then
				Log.debug("Loaded sync resource/event (%f ms, %f kb) %s.", top.totalTime or 0, top.memory, top.filename or top.traceback)
			end

			table.remove(self.pendingSyncEvents, 1)
			count = count + 1
			elapsedTimeForSingleResource = 0
		end

		currentTime = love.timer.getTime()
	until currentTime > pendingSyncEventBreakTime and elapsedTimeForSingleResource < ResourceManager.MAX_TIME_FOR_SYNC_RESOURCE

	if currentTime and currentTime > pendingSyncEventBreakTime + self.frameDuration then
		Log.info('Resource loading spilled %d ms.', math.floor((currentTime - pendingSyncEventBreakTime) * 1000))
	end

	if count > 0 then
		self.onUpdate(count, #self.pendingSyncEvents + #self.pendingAsyncEvents)
	end

	if #self.pendingSyncEvents == 0 and #self.pendingAsyncEvents == 0 and self.wasPending then
		self.onFinish(self)
		self.wasPending = false
	end
end

-- This actually performs the load.
function ResourceManager:_load(resourceType, filename, ...)
	do
		local oldFilename
		local newFilename = filename

		repeat
			oldFilename = newFilename

			local i, j = oldFilename:find("..", 1, true)
			if i and j then
				local prefix = oldFilename:sub(1, i - 1):gsub("^(.*)/.+$", "%1/")
				local suffix = oldFilename:sub(j + 2)

				newFilename = prefix .. suffix
			else
				newFilename = oldFilename
			end
		until oldFilename == newFilename

		filename = newFilename
	end

	if coroutine.running() then
		coroutine.yield()
	end

	local resourcesOfType = self.resources[resourceType] or setmetatable({}, { __mode = 'v' })
	if resourcesOfType[filename] and (coroutine.running() or resourcesOfType[filename] ~= true) then
		while resourcesOfType[filename] == true do
			Log.debug("Resource '%s' (%s) still loading elsewhere...", filename, resourceType._DEBUG.shortName)
			coroutine.yield()
		end

		Log.debug("Resource '%s' (%s) cached.", filename, resourceType._DEBUG.shortName)
	else
		local before = love.timer.getTime()
		do
			local resource = resourceType()
			resourcesOfType[filename] = true
			self.resources[resourceType] = resourcesOfType

			resource:loadFromFile(filename, self, ...)
			resourcesOfType[filename] = resource
		end
		local after = love.timer.getTime()

		local duration = after - before
		local stats = self.loadStats[resourceType] or {}
		stats.totalTime = (stats.totalTime or 0) + duration
		stats.numSamples = (stats.numSamples or 0) + 1
		self.loadStats[resourceType] = stats
	end

	self.cache[resourcesOfType[filename]] = true
	return resourcesOfType[filename]
end

function ResourceManager:_blockingLoad(resourceType, filename, ...)
	-- We delegate to _blockingLoad so this warning is consistent.
	if not coroutine.running() then
		local info = debug.getinfo(2, "Sl")
		Log.engine(
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

function ResourceManager._wrappedCallback(pending)
	while not pending.done do
		coroutine.yield()
	end

	if pending.callback then
		pending.callback(pending.resource)
	end
end

local function _wrappedCallback(pending, callback)
	while not pending.done do
		coroutine.yield()
	end

	if callback then
		local s, r = xpcall(callback, debug.traceback, pending.resource)
		if not s then
			Log.warn("Failed to load resource '%s': %s", pending.filename, r)
		end
	end
end

function ResourceManager:_queue(resourceType, filename, async, callback, ...)
	if not Class.isDerived(resourceType, Resource) then
		error("expected Resource-derived type")
	end

	local load = Function(self._load, self, resourceType, filename, ...)

	local pending = { callback = load:coroutine(), filename = filename }
	local c = Function(_wrappedCallback, pending, callback):coroutine()

	table.insert(self.pendingResources, pending)

	local e = { filename = filename, callback = c, traceback = _DEBUG and debug.traceback(nil, 2) }
	if async then
		table.insert(self.pendingAsyncEvents, e)
	else
		table.insert(self.pendingSyncEvents, e)
	end
end

function ResourceManager:queueAsync(resourceType, filename, callback, ...)
	self:_queue(resourceType, filename, true, callback, ...)
end

function ResourceManager:queue(resourceType, filename, callback, ...)
	self:_queue(resourceType, filename, false, callback, ...)
end

function ResourceManager:queueCacheRef(ref, callback, ...)
	self:queue(ref:getResourceType(), ref:getFilename(), callback, ...)
end

function ResourceManager:queueAsyncCacheRef(ref, callback, ...)
	self:queueAsync(ref:getResourceType(), ref:getFilename(), callback, ...)
end

local function _wrappedEvent(callback, traceback, ...)
	local s, r = xpcall(callback, debug.traceback, ...)
	if not s then
		Log.warn("Failed to run callback: %s", r)
		if traceback then
			Log.info(traceback)
		end
	end
end

-- Queues a callback. No resource loading is performed.
function ResourceManager:_queueEvent(async, callback, ...)
	local traceback = _DEBUG and debug.traceback(nil, 2)
	local c = Function(_wrappedEvent, callback, traceback, ...):coroutine()

	local e = { callback = c, traceback = _DEBUG and debug.traceback(nil, 2) }
	if async then
		table.insert(self.pendingAsyncEvents, e)
	else
		table.insert(self.pendingSyncEvents, e)
	end
end

function ResourceManager:queueEvent(...)
	self:_queueEvent(false, ...)
end

function ResourceManager:queueAsyncEvent(...)
	self:_queueEvent(true, ...)
end

local function _sortStats(a, b)
	return a.name < b.name
end

function ResourceManager:getStats()
	local result = {}

	for resourceType, resourceStats in pairs(self.loadStats) do
		local debugInfo = resourceType._DEBUG
		local shortName = debugInfo and debugInfo.shortName
		if shortName then
			table.insert(result, {
				name = shortName,
				mean = resourceStats.totalTime / resourceStats.numSamples,
				total = resourceStats.totalTime,
				count = resourceStats.numSamples
			})
		end
	end

	table.sort(result, _sortStats)

	return result
end

function ResourceManager:newView()
	return ResourceManager.View(self)
end

return ResourceManager
