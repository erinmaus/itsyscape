--------------------------------------------------------------------------------
-- ItsyScape/Game/LocalModel/Party.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local PartyBehavior = require "ItsyScape.Peep.Behaviors.PartyBehavior"

local Party = Class()

Party.Raid = Class()

function Party.Raid:new(party, resource)
	self.party = party

	if type(resource) == 'string' then
		local gameDB = party:getGameDB()
		local r = gameDB:getResource("Raid", resource)

		if not r then
			Log.error("Invalid raid '%s' for party %d.", resource, party:getID())
		end
	end

	if not resource then
		Log.error("Expected valid raid resource for party %d.", party:getID())
	else
		self.resource = resource
	end

	self.instances = {}
end

function Party.Raid:getParty()
	return self.party
end

function Party.Raid:getIsValid()
	return self.resource ~= nil
end

function Party.Raid:addInstance(instance)
	if instance:getIsGlobal() then
		Log.error(
			"Instance %s (%d) is global; cannot add to raid for party %d.",
			instance:getFilename(), instance:getID(), self:getParty():getID())
		return false
	end

	if instance:getRaid() ~= nil then
		Log.error(
			"Instance %s (%d) already part of raid (for party %d); cannot join raid for party %d.",
			instance:getFilename(), instance:getID(), instance:getRaid():getParty():getID(), self:getParty():getID())
		return false
	end

	for i = 1, #self.instances do
		if self.instances[i] == instance then
			Log.error(
				"Instance %s (%d) is already in raid for party %d.",
				instance:getFilename(), instance:getID(), self:getParty():getID())
			return false
		end
	end

	table.insert(self.instances, instance)

	instance:setRaid(self)

	Log.info(
		"Add instance %s (%d) to raid for party %d.",
		instance:getFilename(), instance:getID(), self:getParty():getID())

	return true
end

function Party.Raid:iterateInstances()
	return ipairs(self.instances)
end

function Party.Raid:getInstances(filename)
	local result = {}

	for i = 1, #self.instances[i] do
		local instance = self.instances[i]
		if instance:getFilename() == filename then
			table.insert(result, instance)
		end
	end

	return result
end

function Party:new(id, game, leader)
	self.id = id
	self.game = game
	self.leader = leader

	self.players = {
		leader
	}

	self.playersByID = {
		[leader:getID()] = leader
	}

	self.onDisbanded = Callback()
	self.onPlayerJoined = Callback()
	self.onPlayerLeft = Callback()
end

function Party:getGame()
	return self.game
end

function Party:getID()
	return self.id
end

function Party:getLeader()
	return self.leader
end

function Party:iteratePlayers()
	return ipirs(self.players)
end

function Party:hasPlayer(player)
	return self.playersByID[player:getID()] ~= nil
end

function Party:getNumPlayers()
	return #self.players
end

function Party:getIsDisbanded()
	return self:getNumPlayers() == 0
end

function Party:join(player)
	if self:getIsDisbanded() then
		Log.info(
			"Cannot add player '%s' (%d) to party %d; party is disbanded.",
			player:getActor():getName(), player:getID(), self:getID())
	elseif self:hasPlayer(player) then
		Log.info(
			"Player '%s' (%d) already in party %d.",
			player:getActor():getName(), player:getID(), self:getID())
	elseif player:getActor():getPeep():hasBehavior(PartyBehavior) then
		local party = player:getActor():getPeep():getBehavior(PartyBehavior)
		Log.info(
			"Player '%s' (%d) is already in party %d.",
			player:getActor():getName(), player:getID(), party.id or -1)
	else
		table.insert(self.players, player)
		self.playersByID[player:getID()] = player

		local _, party = player:addBehavior(PartyBehavior)
		party.id = self:getID()

		Log.info(
			"Added player '%s' (%d) to party %d.",
			player:getActor():getName(), player:getID(), self:getID())

		self:onPlayerJoined(player)
	end
end

function Party:leave(player)
	if not self:hasPlayer(player) then
		Log.warn(
			"Player '%s' (%d) cannot leave in party %d because they aren't in it.",
			player:getActor():getName(), player:getID(), self:getID())
		return
	end

	if self.leader:getID() == player:getID() and self:getNumPlayers() > 1 then
		Log.warn(
			"Player '%s' (%d) is party leader of party %d with %d members; they cannot leave it, party must be disbanded.",
			player:getActor():getName(), player:getID(), self:getNumPlayers())
		return
	end

	local party = player:getActor():getPeep():getBehavior(PartyBehavior)
	if party and party.id ~= self:getID() and party.id then
		Log.warn(
			"Player '%s' (%d) has switched parties incorrectly; they are in party %d, but are trying to leave party %d.",
			player:getActor():getName(), player:getID(), party.id, self:getID())
		return
	end


	player:getActor():getPeep():removeBehavior(PartyBehavior)

	self.playersByID[player:getID()] = nil
	for i = 1, #self.players do
		if self.players[i]:getID() == player:getID() then
			table.remove(self.players, i)
		end
	end

	Log.info(
		"Removed player '%s' (%d) to party %d.",
		player:getActor():getName(), player:getID(), self:getID())

	self:onPlayerLeft(player)
	if self:getNumPlayers() == 0 then
		Log.info(
			"Party %d disbanded after player '%s' (%d) left.",
			self:getID(), player:getActor():getName(), player:getID())

		self:onDisbanded()
	end
end

-- Gets the first non-leader member of the party.
function Party:_getFirstMember()
	-- Player at index 1 is the party leader; players after that are just members.
	return self.players[2]
end

function Party:disband()
	while self:getNumPlayers() > 1 do
		local player = self:_getFirstMember()
		if player then
			self:leave(player)
		end
	end

	self:leave(self:getPartyLeader())
end

function Party:setRaid(raid)
	if self.raid then
		Log.error(
			"Cannot set raid for party %d; already has raid (%s).",
			self:getID(), (self.raid:getIsValid() and self.raid:getResource().name) or "invalid resource")
		return
	end

	self.raid = Party.Raid(self, raid)
end

function Party:getRaid()
	return self.raid
end

function Party:isInRaid()
	return self.raid ~= nil
end

return Party
