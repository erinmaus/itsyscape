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
	end
end
