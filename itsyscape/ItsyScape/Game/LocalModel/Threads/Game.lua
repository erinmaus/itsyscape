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

while isRunning do
	local t1 = love.timer.getTime()
	do
		game:tick()
		game:update(game:getDelta())

		gameManager:update()
		gameManager:pushTick()
		gameManager:send()

		while not gameManager:receive() do
			love.timer.sleep(0)
		end
	end
	local t2 = love.timer.getTime()

	local duration = t2 - t1
	if duration < game:getDelta() then
		love.timer.sleep(game:getDelta() - duration)
	else
		Log.debug("Tick ran over by %0.2f second(s).", math.abs(duration))
	end
end

rpcService:close()

Log.info("Game thread exiting...")
Log.quit()
