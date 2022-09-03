--------------------------------------------------------------------------------
-- ItsyScape/Game/LocalModel/Threads/Map.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

_LOG_SUFFIX = "server"
require "bootstrap"

local function init(t)
	_DEBUG = t._DEBUG
end

init(...)

local GameDB = require "ItsyScape.GameDB.GameDB"
local LocalGame = require "ItsyScape.Game.LocalModel.Game"
local LocalGameManager = require "ItsyScape.Game.LocalModel.LocalGameManager"
local ChannelRPCService = require "ItsyScape.Game.RPC.ChannelRPCService"
local ServerRPCService = require "ItsyScape.Game.RPC.ServerRPCService"

local game = LocalGame(GameDB.create())

local inputChannel = love.thread.getChannel('ItsyScape.Game::input')
local outputChannel = love.thread.getChannel('ItsyScape.Game::output')
local rpcService = ServerRPCService("localhost", "180323")

local gameManager = LocalGameManager(rpcService, game)

local isRunning = true
game.onQuit:register(function() isRunning = false end)

local function getPeriodInMS(a, b)
	return math.floor((b - a) * 1000)
end

while isRunning do
	local timeStart
	local timeGameTick, timeGameUpdate
	local timeGameManagerUpdate, timeGameManagerTick, timeGameManagerSend
	local timeEnd

	timeStart = love.timer.getTime()
	do
		game:tick()
		timeGameTick = love.timer.getTime()
		game:update(game:getDelta())
		timeGameUpdate = love.timer.getTime()

		gameManager:update()
		timeGameManagerUpdate = love.timer.getTime()
		gameManager:pushTick()
		timeGameManagerTick = love.timer.getTime()
		gameManager:send()
		timeGameManagerSend = love.timer.getTime()

		while not gameManager:receive() do
			love.timer.sleep(0)
		end
	end
	timeEnd = love.timer.getTime()

	local duration = timeEnd - timeStart
	if duration < game:getDelta() then
		love.timer.sleep(game:getDelta() - duration)
	else
		Log.info("Tick ran over by %0.2f second(s).", math.abs(duration))
		Log.info(
			"Stats: iteration = %d ms, game tick = %d ms, game update = %d ms, game manager update = %d ms, game manager tick = %d ms, game manager send = %d ms, game manager receive = %d ms",
			getPeriodInMS(timeStart, timeEnd),
			getPeriodInMS(timeStart, timeGameTick),
			getPeriodInMS(timeGameTick, timeGameUpdate),
			getPeriodInMS(timeGameUpdate, timeGameManagerUpdate),
			getPeriodInMS(timeGameManagerUpdate, timeGameManagerTick),
			getPeriodInMS(timeGameTick, timeGameManagerSend),
			getPeriodInMS(timeGameManagerSend, timeEnd))
	end
end

rpcService:close()

Log.info("Game thread exiting...")
Log.quit()
