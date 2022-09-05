--------------------------------------------------------------------------------
-- ItsyScape/UI/CreatePartyController.lua
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

local CreatePartyController = Class(Controller)

function CreatePartyController:new(peep, director, party, anchor)
	Controller.new(self, peep, director)

	self.party = party
	self.anchor = anchor
end

function CreatePartyController:poke(actionID, actionIndex, e)
	if actionID == "kick" then
		self:kick(e)
	elseif actionID == "toggleLock" then
		self:toggleLock()
	elseif actionID == "start" then
		self:start()
	elseif actionID == "cancel" or actionID == "close" then
		self:cancel()
		self:doClose()
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function CreatePartyController:close()
	self:cancel()
end

function CreatePartyController:cancel()
	if not self.party:getIsStarted() then
		self.party:disband()
	else
		Log.info("Party %d already started, not disbanding.", self.party:getID())
	end
end

function CreatePartyController:kick(e)
	local player = self:getGame():getPlayerByID(e.id)
	if player then
		local isLeader = self.party:getLeader() == player
		if isLeader then
			Log.warn(
				"Player '%s' (%d) tried kicking themselves. What a silly little creature.",
				player:getActor():getName(), player:getID())
		else
			self.party:leave(player)
		end
	end
end

function CreatePartyController:toggleLock()
	if self.party:getIsLocked() then
		self.party:unlock()
	else
		self.party:lock()
	end
end

function CreatePartyController:start()
	if not self.party:getIsLocked() then
		self.party:lock()
	end

	self.party:start(self.anchor)
	self:doClose()
end

function CreatePartyController:doClose()
	self:getGame():getUI():closeInstance(self)
end

function CreatePartyController:pull()
	local state = {
		players = {},
		isLocked = self.party:getIsLocked()
	}

	local pendingKick = {}

	for _, player in self.party:iteratePlayers() do
		local isNotLeader = player ~= self.party:getLeader()
		local isInSameInstance = Utility.Peep.getInstance(self:getPeep()):hasPlayer(player)

		local player = {
			id = player:getID(),
			actorID = (isInSameInstance and player:getActor():getID()) or nil,
			name = player:getActor():getName(),
			pronouns = Utility.Text.getPronouns(player:getActor():getPeep())
		}

		table.insert(state.players, player)
	end

	return state
end

return CreatePartyController
