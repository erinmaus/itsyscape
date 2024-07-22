--------------------------------------------------------------------------------
-- ItsyScape/UI/Threads/Gyro.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

_LOG_SUFFIX = "gyro"
require "bootstrap"

local NGyro = require "nbunny.gyro"
local GyroButtons = require "ItsyScape.UI.GyroButtons"

local inputChannel, outputChannel = ...

local gyroCount = 0
local deviceIDs = {}
local isRunning = true
while isRunning do
	local event = inputChannel:pop()

	if event and type(event) == "table" then
		if event.type == "calibrate" then
			Log.info("Connecting gyros...")

			local before = love.timer.getTime()
			outputChannel:push({
				type = "beginConnect",
				time = before
			})

			gyroCount = NGyro.connect()
			if gyroCount > 0 then
				deviceIDs = { NGyro.getDeviceIDs(gyroCount) }
			else
				table.clear(deviceIDs)
			end

			local after = love.timer.getTime()
			outputChannel:push({
				type = "endConnect",
				time = love.timer.getTime(),
				duration = after - before,
				count = gyroCount,
				deviceIDs = deviceIDs
			})

			Log.info("Connected %d gyros in %.2f ms.", gyroCount, (after - before) * 1000)

			for _, deviceID in ipairs(deviceIDs) do
				Log.info("Initializing gyro '%s'...", deviceID)
				NGyro.initialize(deviceID)
			end
		elseif event.type == "quit" then
			NGyro.disconnect()
			isRunning = false
		end
	end

	for _, deviceID in ipairs(deviceIDs) do
		local deviceState = {
			buttons = {},
			left = { NGyro.getLeftAxis(deviceID) },
			right = { NGyro.getRightAxis(deviceID) },
			gyro = { NGyro.getAverageGyro(deviceID) },
			acceleration = { NGyro.getAcceleration(deviceID) }
		}

		for index, button in ipairs(GyroButtons) do
			deviceState.buttons[button] = NGyro.isDown(deviceID, index - 1)
		end

		outputChannel:push({
			type = "update",
			deviceID = deviceID,
			state = deviceState
		})
	end

	love.timer.sleep(1 / 60)
end

Log.info("Gyro thread exiting...")
Log.quit()
