--------------------------------------------------------------------------------
-- ItsyScape/UI/PartyQuestionController.lua
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

local PartyQuestionController = Class(Controller)

function PartyQuestionController:new(peep, director, raid, anchor)
	Controller.new(self, peep, director)

	if not raid then
		self:doClose()
		self.state = { actions = {} }
		return
	else
		self.raid = raid
		self.anchor = anchor
	end

	local actions = {}

	local party
	do
		local partyBehavior = peep:getBehavior(PartyBehavior)
		if partyBehavior and partyBehavior.id then
			party = director:getGameInstance():getPartyByID(partyBehavior.id)
		end
	end

	local player
	do
		local playerBehavior = peep:getBehavior(PlayerBehavior)
		if playerBehavior and playerBehavior.id then
			player = director:getGameInstance():getPlayerByID(playerBehavior.id)
		end
	end

	local isLeaderOfParty = party and player and party:getLeader() == player
	local isSoleMemberOfParty = isLeaderOfParty and party:getNumPlayers() == 1
	local isMemberOfParty = party and not isLeaderOfParty
	local isNotInParty = party == nil

	if isSoleMemberOfParty or isMemberOfParty then
		table.insert(actions, "leave")
	end

	if isNotInParty then
		table.insert(actions, "create")
		table.insert(actions, "join")
	end

	if isMemberOfParty or isLeaderOfParty then
		table.insert(actions, "rejoin")
	end

	table.insert(actions, "close")

	local difficulty
	do
		
	end

	self.state = {
		actions = actions,
		id = self.raid.name,
		name = Utility.getName(self.raid, director:getGameDB()) or "*" .. self.raid.name,
		description = Utility.getDescription(self.raid, director:getGameDB()) or "no description"
	}
end

function PartyQuestionController:poke(actionID, actionIndex, e)
	if actionID == "join" then
		self:join(e)
	elseif actionID == "rejoin" then
		self:rejoin(e)
	elseif actionID == "create" then
		self:create(e)
	elseif actionID == "leave" then
		self:leave(e)
	elseif actionID == "close" then
		self:doClose()
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function PartyQuestionController:join()
	Utility.UI.openInterface(self:getPeep(), "JoinParty", true, self.raid)
	self:doClose()
end

function PartyQuestionController:rejoin()
	local party = self:getPeep():getBehavior(PartyBehavior)
	party = party and party.id and self:getDirector():getGameInstance():getPartyByID(party.id)
	if party and party:getIsStarted() then
		party:rejoin(Utility.Peep.getPlayerModel(self:getPeep()), self.anchor)
	end
end

function PartyQuestionController:create()
	local game = self:getGame()
	local party = game:startParty(Utility.Peep.getPlayerModel(self:getPeep()))
	if party then
		party:setRaid(self.raid)
		Utility.UI.openInterface(self:getPeep(), "CreateParty", true, party, self.anchor)
	else
		self:doClose()
	end
end

function PartyQuestionController:leave()
	local party = self:getPeep():getBehavior(PartyBehavior)
	party = party and party.id and self:getDirector():getGameInstance():getPartyByID(party.id)

	if party then
		party:leave(Utility.Peep.getPlayerModel(self:getPeep()))
	end

	self:doClose()
end

function PartyQuestionController:doClose()
	self:getGame():getUI():closeInstance(self)
end

function PartyQuestionController:pull()
	return self.state
end

return PartyQuestionController
