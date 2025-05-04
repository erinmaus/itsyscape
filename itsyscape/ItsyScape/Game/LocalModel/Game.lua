--------------------------------------------------------------------------------
-- ItsyScape/Game/LocalModel/Game.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Discord = require "ItsyScape.Discord"
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local PlayerStorage = require "ItsyScape.Game.PlayerStorage"
local Utility = require "ItsyScape.Game.Utility"
local Game = require "ItsyScape.Game.Model.Game"
local LocalPlayer = require "ItsyScape.Game.LocalModel.Player"
local LocalStage = require "ItsyScape.Game.LocalModel.Stage"
local LocalUI = require "ItsyScape.Game.LocalModel.UI"
local DebugStats = require "ItsyScape.Graphics.DebugStats"
local Party = require "ItsyScape.Game.LocalModel.Party"
local ItsyScapeDirector = require "ItsyScape.Game.ItsyScapeDirector"
local PartyBehavior = require "ItsyScape.Peep.Behaviors.PartyBehavior"

local LocalGame = Class(Game)
LocalGame.TICKS_PER_SECOND = 1

function LocalGame:new(gameDB, playerSlot)
	Game.new(self)

	self.gameDB = gameDB
	self.director = ItsyScapeDirector(self, gameDB)
	self.stage = LocalStage(self)
	self.ui = LocalUI(self)
	self.ticks = 0
	self.time = 0
	self.discord = Discord()

	self.players = {}
	self.playersByID = {}
	self.playersPendingRemoval = {}
	self.currentPlayerID = 1

	self.parties = {}
	self.partiesByID = {}
	self.currentPartyID = 1

	self.ticksPerSecond = LocalGame.TICKS_PER_SECOND

	self.debugStats = DebugStats.GlobalDebugStats()
end

function LocalGame:getGameDB()
	return self.gameDB
end

function LocalGame:getPlayer()
	Log.errorOnce("LocalGame.getPlayer deprecated; use LocalGame.getPlayerByID. Returning first player...")
	return self.players[next(self.players, nil)]
end

function LocalGame:setPassword(password)
	self.password = password
end

function LocalGame:verifyPassword(password)
	return self.password == nil or self.password == "" or self.password == password
end

function LocalGame:getPlayerByID(id)
	return self.playersByID[id]
end

function LocalGame:startParty(player)
	if not player:isReady() then
		Log.error("Player %d is not ready to start a party.", player:getID())
		return nil
	end

	local peep = player:getActor():getPeep()
	local existingParty = peep:getBehavior(PartyBehavior)
	if existingParty and existingParty.partyID and self:getPartyByID(existingParty.partyID) then
		Log.errorOnce(
			"Player %s (%d) is in existing party %d.",
			player:getActor():getName(), player:getID(), existingParty.partyID)
		return self:getPartyByID(existingParty.partyID)
	end

	local party = Party(self.currentPartyID, self, player)
	self.currentPartyID = self.currentPartyID + 1

	party.onDisbanded:register(function()
		for i = 1, #self.parties do
			if self.parties[i] == party then
				table.remove(self.parties, i)
				break
			end
		end

		self.partiesByID[party:getID()] = nil

		self.stage:disbandParty(party)
	end)

	table.insert(self.parties, party)
	self.partiesByID[party:getID()] = party

	return party
end

function LocalGame:getPartyByID(id)
	return self.partiesByID[id]
end

function LocalGame:iterateParties()
	return ipairs(self.parties)
end

function LocalGame:getPartiesForRaid(raid)
	local raidName
	if type(raid) == 'string' then
		raidName = raid
	else
		raidName = raid.name
	end

	local result = {}
	for i = 1, #self.parties do
		local party = self.parties[i]

		if party:getRaid() and party:getRaid():getIsValid() and party:getRaid():getResource().name == raidName then
			table.insert(result, party)
		end
	end

	return result
end

function LocalGame:spawnPlayer(clientID)
	local player = LocalPlayer(self.currentPlayerID, self, self.stage)
	self.currentPlayerID = self.currentPlayerID + 1

	player:setClientID(clientID)

	table.insert(self.players, player)
	self.playersByID[player:getID()] = player

	local storage = PlayerStorage()
	player:spawn(storage, false)

	player.onLeave:register(self._onPlayerLeave, self)
	player.onPoof:register(self._onPlayerPoofed, self)
	self:onPlayerSpawned(player)

	return player
end

function LocalGame:removePlayer(player)
	self.playersByID[player:getID()] = nil
	for i = 1, #self.players do
		if self.players[i]:getID() == player:getID() then
			table.remove(self.players, i)
			break
		end
	end

	player.onPoof:unregister(self._onPlayerPoofed)
end

function LocalGame:_onPlayerLeave(player)
	Log.info("Player %d (client %d) is leaving.", player:getID(), player:getClientID())
	player:poof()
end

function LocalGame:_onPlayerPoofed(player)
	player.onPoof:unregister(self._onPlayerPoofed)
	self:onPlayerPoofed(player)
end

function LocalGame:acknowledgePlayerDestroyed(player)
	Log.engine(
		"Acknowledging player %d (client ID = %d) was destroyed, marking for removal.",
		player:getID(), player:getClientID())
	table.insert(self.playersPendingRemoval, player)
end

function LocalGame:getNumPlayers()
	return #self.players
end

function LocalGame:iteratePlayers()
	return ipairs(self.players)
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

function LocalGame:setTicks(value)
	self.ticksPerSecond = value or self.ticksPerSecond
end

function LocalGame:getTicks()
	return self.ticksPerSecond
end

function LocalGame:getCurrentTick()
	return self.ticks
end

function LocalGame:getCurrentTime()
	return self.time
end

function LocalGame:tick()
	self.lastTick = self.currentTick or (love.timer.getTime() - self:getTargetDelta())
	self.currentTick = love.timer.getTime()

	self.ticks = self.ticks + 1

	self.debugStats:measure(self.stage, self.stage.tick, self.stage)
	self.debugStats:measure(self.director, self.director.update, self.director, self:getDelta())
	self.debugStats:measure(self.ui, self.ui.update, self.ui, self:getDelta())

	for _, player in self:iteratePlayers() do
		self.debugStats:measure(player, player.tick, player)
	end

	self.discord:tick()

	self.time = self.time + self:getDelta()
end

function LocalGame:getDelta()
	if self.lastTick and self.currentTick then
		return self.currentTick - self.lastTick
	else
		return self:getTargetDelta()
	end
end

function LocalGame:update(delta)
	self.stage:update(delta)
	Utility.Peep.updateWalks()
end

function LocalGame:cleanup()
	self.stage:cleanup()

	for i = 1, #self.playersPendingRemoval do
		local player = self.playersPendingRemoval[i]
		Log.info(
			"Finally removing player %d (client ID = %d).",
			player:getID(), player:getClientID())
		self:removePlayer(player)
	end
	table.clear(self.playersPendingRemoval)
end

function LocalGame:quit()
	Log.info("Quitting game...")

	self:leave()
	self:tick()

	for i = 1, #self.players do
		local player = self.players[i]
		Log.info(
			"Poofing player '%s (%d).",
			player:getActor() and player:getActor():getName(),
			player:getID())
		player:poof()
	end
	self:tick()

	self.director:quit()
	self.ui:quit()

	self.onQuit(self)

	if _DEBUG then
		self.debugStats:dumpStatsToCSV("LocalGame")
	end

	Log.info("Quit game.")
end

function LocalGame:leave()
	self.stage:collectAllItems()

	for i = 1, #self.players do
		self.players[i]:save()
	end

	self.stage:quit()
	self:tick()

	self:onLeave()
end

return LocalGame
