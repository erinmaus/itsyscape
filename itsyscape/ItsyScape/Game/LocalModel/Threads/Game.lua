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

Log = require "ItsyScape.Common.Log"

do
	if love.system.getOS() == "Android" then
		local sourceDirectory = love.filesystem.getSourceBaseDirectory()

		local cpath = package.cpath
		package.cpath = string.format(
			"%s/lib/lib?.so;%s/lib?.so;%s",
			sourceDirectory,
			sourceDirectory,
			cpath)

		_DEBUG = true
		_MOBILE = true
		_ANALYTICS_DISABLED = true
	else
		local sourceDirectory = love.filesystem.getSourceBaseDirectory()

		local cpath = package.cpath
		package.cpath = string.format(
			"%s/ext/?.dll;%s/ext/?.so;%s/../Frameworks/?.dylib;%s",
			sourceDirectory,
			sourceDirectory,
			sourceDirectory,
			cpath)

		local path = package.path
		package.path = string.format(
			"%s/ext/?.lua;%s/ext/?/init.lua;%s",
			sourceDirectory,
			sourceDirectory,
			cpath)
		
		if love.system.getOS() == "OS X" then
			_ANALYTICS_DISABLED = true
		end
	end
end

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
	game:tick()
	game:update(game:getDelta())

	gameManager:update()
	gameManager:pushTick()

	while not gameManager:receive() do
		love.timer.sleep(0)
	end

	local t2 = love.timer.getTime()

	local duration = t2 - t1
	if duration < game:getDelta() then
		love.timer.sleep(game:getDelta() - duration)
	end
end

