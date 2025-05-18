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

local bit = require "bit"
local ffi = require "ffi"

local function uuidv7()
	local values = {}
	for i = 1, 16 do
		values[i] = ffi.new("uint64_t", love.math.random(0, 0xFF))
	end

	local timestamp = ffi.new("uint64_t", os.time() * 1000)
	local timestampHigh = bit.band(bit.rshift(timestamp, 16), 0xFFFFFFFF)
	local timestampLow = bit.band(timestamp, 0xFFFF)

	values[1] = bit.band(bit.rshift(timestampHigh, 24), 0xFF)
	values[2] = bit.band(bit.rshift(timestampHigh, 16), 0xFF)
	values[3] = bit.band(bit.rshift(timestampHigh, 8), 0xFF)
	values[4] = bit.band(timestampHigh, 0xFF)
	values[5] = bit.band(bit.rshift(timestampLow, 8), 0xFF)
	values[6] = bit.band(timestampLow, 0xFF)

	values[7] = bit.bor(bit.rshift(values[7], 8), 0x70)
	values[9] = bit.bor(bit.rshift(values[9], 8), 0x80)

	local result = {}
	for i = 1, 16 do
		table.insert(result, string.format("%02x", values[i]))
		if i == 4 or i == 6 or i == 8 or i == 10 then
			table.insert(result, "-")
		end
	end

	return table.concat(result)
end

local socket = require "socket"
local POSTHOG_API_KEY = "phc_LdsYQWylO249JvLVvSQwgjn5Gs1n5VyP6UbEnIn83U0"

local https = require "https"
local json = require "json"

local inputChannel = love.thread.getChannel("ItsyScape.Analytics::input")

local eventID = 1

local sessionID = uuidv7()
local deviceID = json.null
local deviceBrand, deviceModel

local function getTimeStamp()
	local utcDate = os.date("!*t")
	local localDate = os.date("%c")
	utcDate.isdst = localDate.isdst

	local seconds = os.time(utcDate)
	local ms = math.floor((socket.gettime() % 1) * 1000)

	return string.format("%s.%dZ", os.date("%Y-%m-%dT%T", seconds), ms)
end

local function makeAnalyticEvent(data)
	if type(data) ~= 'table' or not data.event then
		return nil
	end

	local properties = data.properties
	do
		properties["$set"] = {
			["GPU Brand"] = deviceBrand,
			["Processor and GPU"] = deviceModel,
			["OS Name"] = love.system.getOS(),
			["Latest App Version"] = _ITSYREALM_VERSION,
			["Latest Player Name"] = properties["Player Name"]
		}

		properties["$set_once"] = {
			["Initial App Version"] = _ITSYREALM_VERSION
		}

		properties["Event ID"] = eventID
		properties["$session_id"] = sessionID
	end

	local event = {
		api_key = POSTHOG_API_KEY,
		event = data.event,
		distinct_id = deviceID,
		timestamp = getTimeStamp(),
		properties = properties
	}

	eventID = eventID + 1

	return event
end

local function sendAnalyticEvent(event)
	local s, data = pcall(json.encode, event)

	if not s then
		Log.warn("Couldn't encode event: %s (event = '%s')", data, Log.stringify(event))
		return false, false
	end

	local code, result = https.request("https://app.posthog.com/capture/", {
		method = "POST",
		data = data,
		headers = {
			["Content-Type"] = "application/json",
			["Accept"] = "*/*"
		}
	})

	if code == 200 then
		Log.engine("Submitted event %s.", event.event)
		return true
	else
		Log.warn("Could not submit analytic (status code = %d): %s", code, result)
		return false
	end
end

local function pushAnalyticEvent(data)
	local event = makeAnalyticEvent(data)
	sendAnalyticEvent(event)
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
		else
			Log.warn("Couldn't process 'Player/Common.dat': %s", Log.stringify(config))
		end
	end
end

if isEnabled then
	Log.info("Starting analytics service with session ID '%s'.", sessionID)
end

while isRunning do
	local event = inputChannel:demand()

	if type(event) == 'table' then
		if event.type == 'quit' then
			isRunning = false
		elseif event.type == 'submit' then
			if isEnabled then
				pushAnalyticEvent(event.data)
			end
		elseif event.type == 'session' then
			sessionID = math.floor(socket.gettime() * 1000)
		elseif event.type == 'id' then
			deviceID = event.id or json.null
			deviceBrand = event.brand or nil
			deviceModel = event.model or nil
		end
	end
end

Log.info("Analytics service terminated.")
Log.quit()
