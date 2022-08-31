--------------------------------------------------------------------------------
-- ItsyScape/Game/LocalModel/Game.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Game = require "ItsyScape.Game.Model.Game"
local LocalPlayer = require "ItsyScape.Game.LocalModel.Player"
local LocalStage = require "ItsyScape.Game.LocalModel.Stage"
local LocalUI = require "ItsyScape.Game.LocalModel.UI"
local ItsyScapeDirector = require "ItsyScape.Game.ItsyScapeDirector"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local Discord = require "ItsyScape.Discord"

local LocalGame = Class(Game)
LocalGame.TICKS_PER_SECOND = 10

function LocalGame:new(gameDB, playerSlot)
	Game.new(self)

	self.gameDB = gameDB
	self.director = ItsyScapeDirector(self, gameDB)
	self.stage = LocalStage(self)
	self.player = LocalPlayer(self, self.stage)
	self.playerSpawned = false
	self.ui = LocalUI(self)
	self.ticks = 0
	self.discord = Discord()
end

function LocalGame:getGameDB()
	return self.gameDB
end

function LocalGame:getPlayer()
	return self.player
end

function LocalGame:getPlayerByID(id)
	-- TODO
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

function LocalGame:poofPlayer()
	self.playerSpawned = false
end

function LocalGame:tick()
	if not self.playerSpawned then
		self.player:spawn()
		self.playerSpawned = true
	end

	self.ticks = self.ticks + 1
	self.stage:tick()
	self.director:update(self:getDelta())
	self.ui:update(self:getDelta())

	self.player:updateDiscord()
	self.discord:tick()
end

function LocalGame:update(delta)
	self.stage:update(delta)
end

function LocalGame:quit()
	self:leave()

	self.player:poof()
	self:tick()

	self.onQuit(self)
end

function LocalGame:leave()
	self.stage:collectAllItems()
	self.player:save()

	self.stage:quit()
	self:tick()

	self:onLeave()
end

return LocalGame
