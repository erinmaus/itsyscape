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

	Log.info("Raid '%s' created for party %d.", self.resource.name, party:getID())

	self.instances = {}
end

function Party.Raid:getParty()
	return self.party
end

function Party.Raid:getIsValid()
	return self.resource ~= nil
end

function Party.Raid:getResource()
	return self.resource
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

	for i = 1, #self.instances do
		local instance = self.instances[i]
		if instance:getFilename() == filename then
			table.insert(result, instance)
		end
	end

	return result
end

function Party.Raid:getStartMapAndAnchor()
	local gameDB = self:getParty():getGame():getGameDB()
	local destination = gameDB:getRecord("RaidDestination", {
		Raid = self.resource
	})

	if not destination then
		Log.warn("Raid '%s' does not have a destination. Whoops.", self.resource.name)
		return nil, nil
	end

	return "@" .. destination:get("Map").name, destination:get("Anchor")
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

	self.isLocked = false

	self.onDisbanded = Callback()
	self.onPlayerJoined = Callback()
	self.onPlayerLeft = Callback()

	do
		local _, party = leader:getActor():getPeep():addBehavior(PartyBehavior)
		party.id = self:getID()
	end
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
	return ipairs(self.players)
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

function Party:lock()
	if self.isLocked then
		Log.warn("Party %d is already locked.", self:getID())
	else
		Log.info("Party %d was locked.", self:getID())
		self.isLocked = true
	end
end

function Party:unlock()
	if not self.isLocked then
		Log.warn("Party %d is already unlocked.", self:getID())
	else
		Log.info("Party %d was unlocked.", self:getID())
		self.isLocked = false
	end
end

function Party:getIsLocked()
	return self.isLocked
end

function Party:join(player)
	if self:getIsDisbanded() then
		Log.info(
			"Cannot add player '%s' (%d) to party %d; party is disbanded.",
			player:getActor():getName(), player:getID(), self:getID())
	elseif self:getIsLocked() then
		Log.info(
			"Cannot add player '%s' (%d) to party %d; party is locked.",
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

		local _, party = player:getActor():getPeep():addBehavior(PartyBehavior)
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
			break
		end
	end

	Log.info(
		"Removed player '%s' (%d) from party %d.",
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

	self:leave(self:getLeader())
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

function Party:getIsStarted()
	return self.isStarted
end

function Party:start(otherAnchor)
	Log.info("Party %d is trying to start raid...")

	self.isStarted = true

	if not self:getRaid() then
		Log.warn("Cannot start raid for party %d: no raid set.", self:getID())
		return false
	end

	if self.isStarted then
		Log.info("Heads up, party %d already started raid.", self:getID())
	end

	local filename, anchor = self.raid:getStartMapAndAnchor()
	if not filename or not anchor then
		Log.warn("Cannot start raid for party %d because destination is bonked up.", self:getID())
		return false
	end

	if otherAnchor and otherAnchor ~= "" then
		Log.info("Using other anchor '%s' instead of default anchor '%s'.")
		anchor = otherAnchor
	end

	local leader = self:getLeader()
	local originalInstance = leader:getInstance()
	local instance = self:getGame():getStage():movePeep(leader:getActor():getPeep(), filename, anchor)

	if not instance then
		Log.warn("Couldn't start raid for party %d because leader move failed.", self:getID())
		return false
	end

	self:getRaid():addInstance(instance)

	for _, player in self:iteratePlayers() do
		local isInSameInstance = originalInstance and originalInstance:hasPlayer(player)
		if player ~= leader and isInSameInstance then
			self:getGame():getStage():movePeep(player:getActor():getPeep(), instance, anchor)
		else
			if player ~= leader and not isInSameInstance and originalInstance then
				Log.info(
					"Player '%s' (%d) is in a different instance %s (%d); cannot automatically join raid from instance %s %d. Shucks!",
					player:getActor():getName(), player:getID(),
					player:getInstance():getFilename(), player:getInstance():getID(),
					originalInstance:getFilename(), originalInstance:getID())
			end
		end
	end

	Log.info(
		"And so the party %d began the raid at instance %s (%d), lead by the brave and/or foolish player '%s' (%d)! Good luck!",
		self:getID(), instance:getFilename(), instance:getID(), leader:getActor():getName(), leader:getID())

	return true
end

function Party:rejoin(player, otherAnchor)
	if not self:getIsStarted() then
		Log.info(
			"Party %d's raid hasn't started, player %s (%d) can't rejoin.",
			self:getID(), player:getActor():getName(), player:getID())
		return
	end

	Log.info(
		"Trying to have player %s (%d) rejoin raid for party %d...",
		player:getActor():getName(), player:getID())

	local filename, anchor = self.raid:getStartMapAndAnchor()
	if not filename or not anchor then
		Log.warn("Cannot start raid for party %d because destination is bonked up.", self:getID())
		return false
	end

	if otherAnchor and otherAnchor ~= "" then
		Log.info("Using anchor '%s' instead of anchor '%s'.")
		anchor = otherAnchor
	end

	local instances = self:getRaid():getInstances(filename)
	if #instances > 1 then
		Log.warn("%d instances found for map '%s'; choosing first one.", #instances, filename)
	elseif #instances == 1 then
		local instance = instances[1]

		Log.info("Going to existing instance %s (%d).", instance:getFilename(), instance:getID())
		self:getGame():getStage():movePeep(
			player:getActor():getPeep(),
			instance,
			anchor)
	else
		Log.warn(
			"Kinda wonky, party %d doesn't have a raid instance for map %s. That's weird.",
			self:getID(), filename)

		local instance = self:getGame():getStage():movePeep(
			player:getActor():getPeep(),
			filename,
			anchor)
		self:getRaid():addInstance(instance)
	end

	Log.info(
		"Player %s (%d) successfully rejoined party %d.",
		player:getActor():getName(), player:getID(), self:getID())
end

return Party
