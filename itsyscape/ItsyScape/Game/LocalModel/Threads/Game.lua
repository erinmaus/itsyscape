--------------------------------------------------------------------------------
-- ItsyScape/Game/LocalModel/Threads/Map.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
require "love"
require "love.data"
require "love.event"
require "love.filesystem"
require "love.keyboard"
require "love.math"
require "love.mouse"
require "love.physics"
require "love.system"
require "love.thread"
require "love.timer"

require "bootstrap"

local function init(t)
	_DEBUG = t._DEBUG
	_VERBOSE = t._VERBOSE
end

init(...)

local GameDB = require "ItsyScape.GameDB.GameDB"
local LocalGame = require "ItsyScape.Game.LocalModel.Game"
local LocalGameManager = require "ItsyScape.Game.LocalModel.LocalGameManager"

local game = LocalGame(GameDB.create())

inputChannel = love.thread.getChannel('ItsyScape.Game::input')
outputChannel = love.thread.getChannel('ItsyScape.Game::output')

local gameManager = LocalGameManager(inputChannel, outputChannel, game)

local isRunning = true
game.onQuit:register(function() isRunning = false end)

while isRunning do
	local t1 = love.timer.getTime()
	do
		local a0 = love.timer.getTime()
		game:tick()
		game:update(game:getDelta())

		local a1 = love.timer.getTime()
		gameManager:update()
		local a2 = love.timer.getTime()
		gameManager:pushTick()
		local a3 = love.timer.getTime()
		gameManager:send()
		local a4 = love.timer.getTime()

		while not gameManager:receive() do
			love.timer.sleep(0)
			break
		end

		local a5 = love.timer.getTime()

		if _VERBOSE then
			Log.debug("[BE] game:tick()            -> %03d ms", (a1 - a0) * 1000)
			Log.debug("[BE] gameManager:update()   -> %03d ms", (a2 - a1) * 1000)
			Log.debug("[BE] gameManager:pushTick() -> %03d ms", (a3 - a2) * 1000)
			Log.debug("[BE] gameManager:send()     -> %03d ms", (a4 - a3) * 1000)
			Log.debug("[BE] gameManager:receive()  -> %03d ms", (a5 - a4) * 1000)
		end
	end
	local t2 = love.timer.getTime()

	local duration = t2 - t1
	if duration < game:getDelta() then
		if _VERBOSE then
			Log.debug("Sleeping for %d ms.", (game:getDelta() - duration) * 1000)

			love.timer.sleep(game:getDelta() - duration)
		end
	else
		Log.debug(
			"Tick ran over by %0.2f ms (expected <= %d ms).",
			math.abs((duration - game:getDelta()) * 1000),
			game:getDelta() * 1000)
	end
end

Log.info("Game thread exiting...")
