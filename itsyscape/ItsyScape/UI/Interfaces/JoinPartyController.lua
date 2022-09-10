--------------------------------------------------------------------------------
-- ItsyScape/UI/JoinPartyController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"
local PartyBehavior = require "ItsyScape.Peep.Behaviors.PartyBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"

local JoinPartyController = Class(Controller)

function JoinPartyController:new(peep, director, raid)
	Controller.new(self, peep, director)

	self.raid = raid
end

function JoinPartyController:poke(actionID, actionIndex, e)
	if actionID == "join" then
		self:cancel()
		self:join(e)
	elseif actionID == "leave" then
		self:cancel()
	elseif actionID == "cancel" or actionID == "close" then
		self:cancel()
		self:doClose()
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function JoinPartyController:close()
	self:cancel()
end

function JoinPartyController:cancel()
	if self.party and not self.party:getIsStarted() then
		self.party:leave(Utility.Peep.getPlayerModel(self:getPeep()))
		self.party = nil
	end
end

function JoinPartyController:join(e)
	local player = self:getGame():getPlayerByID(e.id)
	local party = player:getActor():getPeep():getBehavior(PartyBehavior)
	party = party and party.id and self:getGame():getPartyByID(party.id)

	if party and party:getLeader() == player then
		party:join(Utility.Peep.getPlayerModel(self:getPeep()))
		self.party = party
	else
		Log.warn(
			"Player '%s' (%d) is no longer leading a party; cannot join.",
			player:getActor():getName(), player:getID())
	end
end

function JoinPartyController:doClose()
	self:getGame():getUI():closeInstance(self)
end

function JoinPartyController:pull()
	local parties = self:getGame():getPartiesForRaid(self.raid)

	local state = {
		players = {},
		partyID = self.party and self.party:getLeader():getID()
	}

	for i = 1, #parties do
		local party = parties[i]
		local player = party:getLeader()

		local isAvailable = not party:getIsLocked()
		local isJoined = party:hasPlayer(Utility.Peep.getPlayerModel(self:getPeep()))
		local isInSameInstance = Utility.Peep.getInstance(self:getPeep()):hasPlayer(player)

		if isAvailable or isJoined then
			local player = {
				id = player:getID(),
				actorID = (isInSameInstance and player:getActor():getID()) or nil,
				name = player:getActor():getName(),
				pronouns = Utility.Text.getPronouns(player:getActor():getPeep())
			}

			table.insert(state.players, player)	
		end
	end

	return state
end

return JoinPartyController
