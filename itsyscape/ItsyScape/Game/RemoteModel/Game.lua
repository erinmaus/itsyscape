--------------------------------------------------------------------------------
-- ItsyScape/Game/RemoteModel/Game.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Game = require "ItsyScape.Game.Model.Game"

local RemoteGame = Class(Game)

function RemoteGame:new(gameManager, gameDB)
	Game.new(self)

	self.gameManager = gameManager
	self.gameDB = gameDB

	self.onPlayerSpawned:register(self._onPlayerSpawned, self)
	self.onPlayerPoofed:register(self._onPlayerPoofed, self)
end

function RemoteGame:getGameManager()
	return self.gameManager
end

function RemoteGame:_onPlayerSpawned(_, player, actor)
	if not player then
		Log.warn("Spawned player is nil.")
		return
	end

	if self.player then
		Log.warn(
			"New player '%s' (%d) spawned, but player '%s' (%d) already exists; replacing, but there might be problems.",
			(player:getActor() and player:getActor():getName()) or "Player",
			player:getID(),
			(self.player:getActor() and self.player:getActor():getName()) or "Player",
			self.player:getID())
	end

	Log.info(
		"New player '%s' (%d) spawned.",
		(player:getActor() and player:getActor():getName()) or "Player", player:getID())

	self.player = player
	self:onReady(player)
end

function RemoteGame:_onPlayerPoofed(_, player)
	if not player then
		Log.warn("Poofed player is nil.")
		return
	end

	Log.info(
		"Poofing player '%s' (%d)...",
		(player:getActor() and player:getActor():getName()) or "Player", player:getID())

	if self.player and self.player:getID() ~= player:getID() then
		Log.warn("Existing player (id = %d) is different.", player:getID())
	elseif not self.player then
		Log.warn("Player not yet created.")
	else
		self.player = nil
		Log.info("Player poofed! Quitting game.")

		self:onQuit()
	end
end

function RemoteGame:getGameDB()
	return self.gameDB
end

function RemoteGame:getPlayer()
	return self.player
end

function RemoteGame:getStage()
	if not self.stage then
		self.stage = self.gameManager:getInstance("ItsyScape.Game.Model.Stage", 0):getInstance()
	end

	return self.stage
end

function RemoteGame:getUI()
	if not self.ui then
		self.ui = self.gameManager:getInstance("ItsyScape.Game.Model.UI", 0):getInstance()
	end

	return self.ui
end

return RemoteGame
