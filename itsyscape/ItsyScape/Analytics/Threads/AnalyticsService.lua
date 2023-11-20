--------------------------------------------------------------------------------
-- ItsyScape/Analytics/Threads/AnalyticsService.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
_LOG_SUFFIX = "analytics"
require "bootstrap"

local socket = require "socket"
local API_KEY = "1a23b24552f2cd035666642f5e29946"

local https = require "https"
local json = require "json"

local inputChannel = love.thread.getChannel("ItsyScape.Analytics::input")

local BATCH_LIMIT        = 10
local BATCH_TIME_SECONDS = 1
local BATCH_TIME_OFFSET  = love.math.random() * BATCH_TIME_SECONDS

local COOL_OFF_TIME_SECONDS = 30

local batch = {}
local eventID = 1
local batchTime = love.timer.getTime()
local targetTime = batchTime + BATCH_TIME_OFFSET + BATCH_TIME_SECONDS

local sessionID = math.floor(socket.gettime() * 1000)
local deviceID = json.null
local deviceBrand, deviceModel

local function getBatch()
	if #batch <= BATCH_LIMIT then
		return batch
	end

	local result = {}
	for i = 1, BATCH_LIMIT do
		table.insert(result, batch[i])
	end

	return result
end

local function updateBatch(events)
	for i = 1, #events do
		table.remove(batch, 1)
	end
end

local function tryFlushBatch(flush)
	local currentTime = love.timer.getTime()

	local success = true
	if (#batch >= BATCH_LIMIT and currentTime >= targetTime) or flush then
		batchTime = currentTime
		targetTime = batchTime + BATCH_TIME_OFFSET + BATCH_TIME_SECONDS

		local events = flush and batch or getBatch()
		local data = json.encode {
			api_key = API_KEY,
			events = events
		}

		local code, result = https.request("https://api2.amplitude.com/2/httpapi", {
			method = "POST",
			data = data,
			headers = {
				["Content-Type"] = "application/json",
				["Accept"] = "*/*"
			}
		})

		if code == 200 then
			Log.engine(
				"Submitted %d event(s) after %.2f seconds.",
				#batch, currentTime - batchTime)
			updateBatch(events)
		elseif code then
			if code == 400 then
				Log.engine(
					"Could not submit %d event(s) after %.2f seconds due to client error: %s",
					#batch, currentTime - batchTime,
					(json.decode(result or "{}") or {}).error or "<unknown error>")
				success = false
			elseif code == 413 then
				Log.engine("Payload too large! Sent %d byte(s) in total.", #data)
				updateBatch(events)
				success = false
			elseif code == 429 then
				Log.engine("Too many requests! Cooling down...")
				targetTime = targetTime + COOL_OFF_TIME_SECONDS
				success = false
			elseif code >= 500 then
				Log.engine("Amplitude error! Not flushing events.")
			end
		else
			Log.engine("Error sending events to Amplitude: %s.", result)
		end

		return true, success
	end

	return false, success
end

local function makeAnalyticEvent(data)
	if type(data) ~= 'table' or not data.event then
		return nil
	end

	local result = {
		device_id = deviceID,
		session_id = sessionID,
		event_type = data.event,
		os_name = love.system.getOS(),
		event_id = eventID,
		app_version = _ITSYREALM_VERSION,
		event_properties = data.properties
	}

	eventID = eventID + 1

	return result
end

local function pushAnalyticEvent(data)
	local event = makeAnalyticEvent(data)
	if event then
		table.insert(batch, event)
	end
end

Log.info("Starting analytics service...")

local isEnabled = true
local isRunning = true
do
	local serpent = require "serpent"
	local file = love.filesystem.read("Player/Common.dat") or "{}"
	local r, e = loadstring("return " .. file)
	if not r then
		Log.warn("Failed to parse 'Player/Common.dat': %s", e)
	else
		local success, config = pcall(setfenv(r, {}))
		if success and type(config) == 'table' then
			if config.enable == false then
				Log.info("Analytics disabled. Terminating...")
				isEnabled = false
				isRunning = false
			end

			if type(config.pending) == 'table' then
				batch = config.pending
				eventID = #batch + 1
			end
		else
			Log.warn("Couldn't process 'Player/Common.dat': %s", Log.stringify(config))
		end
	end
end

while isRunning do
	local event = inputChannel:demand()

	if type(event) == 'table' then
		if event.type == 'quit' then
			isRunning = false
			tryFlushBatch(true)
		elseif event.type == 'submit' then
			pushAnalyticEvent(event.data)
			tryFlushBatch(event.flush or false)
		elseif event.type == 'id' then
			deviceID = event.id or json.null
			deviceBrand = event.brand or nil
			deviceModel = event.model or nil
		end
	end
end

if isEnabled and #batch > 0 then
	local file = love.filesystem.read("Player/Common.dat") or "{}"
	local r, e = loadstring("return " .. file)
	if not r then
		Log.warn("Failed to parse 'Player/Common.dat': %s", e)
	else
		local success, config = pcall(setfenv(r, {}))
		if config then
			for i = 1, #batch do
				batch.event_id = i
			end

			config.pending = batch

			local serpent = require "serpent"
			local serializedConfig = serpent.block(config, { comment = false })

			love.filesystem.write("Player/Common.dat", serializedConfig)

			Log.info("Saved %d pending event(s).", #batch)
		else
			Log.warn("Couldn't process 'Player/Common.dat': %s", Log.stringify(config))
		end
	end
end

Log.info("Analytics service terminated.")
Log.quit()
