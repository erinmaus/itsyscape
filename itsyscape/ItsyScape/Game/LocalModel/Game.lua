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
local Party = require "ItsyScape.Game.LocalModel.Party"
local ItsyScapeDirector = require "ItsyScape.Game.ItsyScapeDirector"
local PartyBehavior = require "ItsyScape.Peep.Behaviors.PartyBehavior"

local LocalGame = Class(Game)
LocalGame.TICKS_PER_SECOND = 10

function LocalGame:new(gameDB, playerSlot)
	Game.new(self)

	self.gameDB = gameDB
	self.director = ItsyScapeDirector(self, gameDB)
	self.stage = LocalStage(self)
	self.ui = LocalUI(self)
	self.ticks = 0
	self.discord = Discord()

	self.players = {}
	self.playersByID = {}
	self.currentPlayerID = 1

	self.parties = {}
	self.partiesByID = {}
	self.currentPartyID = 1
end

function LocalGame:getGameDB()
	return self.gameDB
end

function LocalGame:getPlayer()
	Log.errorOnce("LocalGame.getPlayer deprecated; use LocalGame.getPlayerByID. Returning first player...")
	return self.players[next(self.players, nil)]
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
	if existingParty and existingParty.id then
		Log.errorOnce(
			"Player %s (%d) is in existing party %d.",
			player:getActor():getName(), player:getID(), existingParty.id)
		return self:getPartyByID(existingParty.id)
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
	end)

	table.insert(self.parties, party)
	self.partiesByID[party:getID()] = party

	return party
end

function LocalGame:getPartyByID(id)
	return self.partiesByID[id]
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
	storage:getRoot():set({
		Location = {
			x = 1,
			y = 0,
			z = 1,
			name = "@TitleScreen_EmptyRuins",
			isTitleScreen = true
		}
	})
	player:spawn(storage, false)

	player.onPoof:register(self._onPlayerPoofed, self)
	self:onPlayerSpawned(player)

	return player
end

function LocalGame:_onPlayerPoofed(player)
	self.playersByID[player:getID()] = nil
	for i = 1, #self.players do
		if self.players[i]:getID() == player:getID() then
			table.remove(self.players, i)
			break
		end
	end

	player.onPoof:unregister(self._onPlayerPoofed)
	self:onPlayerPoofed(player)
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

function LocalGame:getTicks()
	return LocalGame.TICKS_PER_SECOND
end

function LocalGame:getCurrentTick()
	return self.ticks
end

function LocalGame:tick()
	self.ticks = self.ticks + 1
	self.stage:tick()
	self.director:update(self:getDelta())
	self.ui:update(self:getDelta())

	--self.player:updateDiscord()
	self.discord:tick()
end

function LocalGame:update(delta)
	self.stage:update(delta)
end

function LocalGame:quit()
	self:leave()

	while #self.players > 0 do
		self.players[1]:poof()
	end

	self:tick()

	self.onQuit(self)
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
