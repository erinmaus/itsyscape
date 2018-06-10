--------------------------------------------------------------------------------
-- ItsyScape/Game/LocalModel/Game.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Game = require "ItsyScape.Game.Model.Game"
local LocalPlayer = require "ItsyScape.Game.LocalModel.Player"
local LocalStage = require "ItsyScape.Game.LocalModel.Stage"
local LocalUI = require "ItsyScape.Game.LocalModel.UI"
local ItsyScapeDirector = require "ItsyScape.Game.ItsyScapeDirector"

local LocalGame = Class(Game)
LocalGame.TICKS_PER_SECOND = 10

function LocalGame:new(gameDB)
	Game.new(self)

	self.gameDB = gameDB
	self.director = ItsyScapeDirector(self, gameDB)
	self.player = LocalPlayer(self)
	self.playerSpawned = false
	self.stage = LocalStage(self)
	self.ui = LocalUI(self)
	self.ticks = 0
end

function LocalGame:getGameDB()
	return self.gameDB
end

function LocalGame:getPlayer()
	return self.player
end

function LocalGame:getStage()
	return self.stage
end

function LocalGame:getUI()
	return self.ui
end

function LocalGame:getDirector()
	return self.director
end

function LocalGame:getTicks()
	return LocalGame.TICKS_PER_SECOND
end

function LocalGame:getCurrentTick()
	return self.ticks
end

function LocalGame:tick()
	if not self.playerSpawned then
		self.player:spawn()
		self.playerSpawned = true
	end

	self.ticks = self.ticks + 1
	self.director:update(self:getDelta())
	self.ui:update(self:getDelta())
end

return LocalGame
