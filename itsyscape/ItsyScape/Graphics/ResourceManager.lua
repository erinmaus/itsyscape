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
ResourceManager.DESKTOP_FRAME_DURATION     = _DEBUG == "plus" and 1 or 1 / 120
ResourceManager.LOADING_FRAME_DURATION     = _DEBUG == "plus" and 1 or 1 / 20
ResourceManager.MOBILE_FRAME_DURATION      = 1 / 10

ResourceManager.MAX_TIME_FOR_SYNC_RESOURCE_RUNTIME = _DEBUG == "plus" and 1 or 2 / 1000
ResourceManager.MAX_TIME_FOR_SYNC_RESOURCE_LOADING = _DEBUG == "plus" and 1 or 10 / 1000

ResourceManager.FILE_IO_THREADS = 4

ResourceManager.View = Class()

function ResourceManager.View:new(resourceManager)
	self.resourceManager = resourceManager

	self.pending = {}
	self.pendingIndex = 0
	self.cancelled = {}

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
			if not self.cancelled[pending] then
				if pending.resource then
					pending.callback(pending.resource)
				else
					pending.callback()
				end
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
	self.pending[index].handle = self.resourceManager:queueAsync(
		resourceType,
		filename,
		Function(self._done, self, index),
		...)

	return self.pending[index].handle
end

function ResourceManager.View:queueAsync(...)
	return self.resourceManager:queueAsync(...)
end

function ResourceManager.View:queueCacheRef(ref, callback, ...)
	return self:queue(ref:getResourceType(), ref:getFilename(), callback, ...)
end

function ResourceManager.View:queueAsyncCacheRef(...)
	return self.resourceManager:queueAsyncCacheRef(...)
end

function ResourceManager.View:queueEvent(callback, ...)
	self.pendingIndex = self.pendingIndex + 1
	local index = self.pendingIndex

	self.pending[index] = { callback = Function(callback, ...), ready = true }
	return self.pending[index]
end

function ResourceManager.View:queueAsyncEvent(...)
	return self.resourceManager:queueAsyncEvent(...)
end

function ResourceManager.View:cancel(handle)
	for _, pending in pairs(self.pending) do
		if pending == handle then
			self.cancelled[pending] = true
			return
		end
	end

	self.resourceManager:cancel(handle)
end

function ResourceManager:new()
	self.resources = {}
	self.cache = {}

	self.loadStats = {}
	self.pendingSyncEvents = {}
	self.pendingAsyncEvents = {}
	self.pendingResources = {}

	self.maxTimeForSyncResource = ResourceManager.MAX_TIME_FOR_SYNC_RESOURCE_RUNTIME
	self:setFrameDuration()

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

function ResourceManager:getMaxTimeForSyncResource()
	return self.maxTimeForSyncResource
end

function ResourceManager:setMaxTimeForSyncResource(value)
	self.maxTimeForSyncResource = value or ResourceManager.MAX_TIME_FOR_SYNC_RESOURCE_RUNTIME
end

function ResourceManager:getFrameDuration()
	return self.frameDuration
end

function ResourceManager:setFrameDuration(value)
	if not value or value == 0 then
		if _MOBILE then
			self.frameDuration = ResourceManager.MOBILE_FRAME_DURATION
		else
			self.frameDuration = ResourceManager.DESKTOP_FRAME_DURATION
		end

		return
	end

	self.frameDuration = value
end

function ResourceManager:cancel(handle)
	for i = #self.pendingSyncEvents, 1, -1 do
		if self.pendingSyncEvents[i] == handle then
			table.remove(self.pendingSyncEvents, i)
		end
	end

	for i = #self.pendingAsyncEvents, 1, -1 do
		if self.pendingAsyncEvents[i] == handle then
			table.remove(self.pendingAsyncEvents, i)
		end
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

-- Returns true if pending resources are in the queue, false otherwise.
function ResourceManager:getIsPending()
	return #self.pendingResources > 0 and (#self.pendingSyncEvents > 0 or #self.pendingAsyncEvents > 0), #self.pendingSyncEvents + #self.pendingAsyncEvents
end

-- Loads async resources.
function ResourceManager:update()
	local updateStartTime = love.timer.getTime()

	if self:getIsPending() and not self.wasPending then
		self.onPending(self, #self.pendingSyncEvents + #self.pendingAsyncEvents)
		self.wasPending = true
	end

	local isEditor = _LOG_WRITE_ALL
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

				if _LOG_WRITE_ALL then
					Log.debug("Tried loading resource '%s'.", pending.filename)
				end
			end
		end

		if _LOG_WRITE_ALL then
			Log.debug("Tried to loaded %d resource(s).", index)
		end
	end

	local step = self.frameDuration / 2
	local currentTime = love.timer.getTime()
	local pendingAsyncEventBreakTime = currentTime + step

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

			if _LOG_WRITE_ALL and _DEBUG then
				Log.debug("Ran async event '%s'.", pending.callback)
				Log.debug("Current async event stack: %s", debug.traceback(callback))
			end
		end

		if _LOG_WRITE_ALL then
			Log.debug("Ran %d async event(s).", index)
		end
	end


	currentTime = love.timer.getTime()
	local pendingSyncEventBreakTime = currentTime + step

	local count = 0
	local elapsedTimeForSingleResource = 0
	local c = 0
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

			elapsedTimeForSingleResource = elapsedTimeForSingleResource + (after - before)

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

		if _LOG_WRITE_ALL and _DEBUG then
			Log.debug("Ran sync event '%s'.", top.traceback)
		end

		currentTime = love.timer.getTime()

		c = c + 1
	until currentTime > pendingSyncEventBreakTime or elapsedTimeForSingleResource > self.maxTimeForSyncResource

	if _LOG_WRITE_ALL and c > 0 then
		Log.debug("Ran async event(s), %d pending; %d iterations.", c, #self.pendingSyncEvents, c)
	end

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

	local resourcesOfType = self.resources[resourceType]
	if not resourcesOfType then
		resourcesOfType = setmetatable({}, { __mode = 'v' })
		self.resources[resourceType] = resourcesOfType
	end

	if resourcesOfType[filename] and (coroutine.running() or resourcesOfType[filename] ~= true) then
		while resourcesOfType[filename] == true do
			Log.debug("Resource '%s' (%s) still loading elsewhere...", filename, resourceType._DEBUG.shortName)
			coroutine.yield()
		end
		
		Log.debug("Resource '%s' (%s) cached.", filename, resourceType._DEBUG.shortName)
	else
		resourcesOfType[filename] = true

		if coroutine.running() then
			coroutine.yield()
		end

		local before = love.timer.getTime()
		do
			local resource = resourceType()
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

	local success, result = coroutine.resume(pending.callback)
	if success and result then
		Log.info("No need to queue resource '%s'; already loaded.", filename)
		pending.resource = result
		pending.done = true
	else
		Log.info("Queuing resource '%s'...", filename)
		table.insert(self.pendingResources, pending)
	end

	local e = { filename = filename, callback = c, traceback = _DEBUG and debug.traceback() }
	if async then
		table.insert(self.pendingAsyncEvents, e)
	else
		table.insert(self.pendingSyncEvents, e)
	end

	return e
end

function ResourceManager:queueAsync(resourceType, filename, callback, ...)
	return self:_queue(resourceType, filename, true, callback, ...)
end

function ResourceManager:queue(resourceType, filename, callback, ...)
	return self:_queue(resourceType, filename, false, callback, ...)
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
	local traceback = _DEBUG and debug.traceback()
	local c = Function(_wrappedEvent, callback, traceback, ...):coroutine()

	local e = { callback = c, traceback = traceback }
	if async then
		table.insert(self.pendingAsyncEvents, e)
	else
		table.insert(self.pendingSyncEvents, e)
	end

	return e
end

function ResourceManager:queueEvent(...)
	return self:_queueEvent(false, ...)
end

function ResourceManager:queueAsyncEvent(...)
	return self:_queueEvent(true, ...)
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
