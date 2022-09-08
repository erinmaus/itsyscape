--------------------------------------------------------------------------------
-- ItsyScape/UI/ChatController.lua
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

local ChatController = Class(Controller)

function ChatController:new(peep, director)
	Controller.new(self, peep, director)
end

function ChatController:poke(actionID, actionIndex, e)
	if actionID == "chat" then
		self:chat(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function ChatController:chat(e)
	local playerModel = Utility.Peep.getPlayerModel(self:getPeep())
	playerModel:talk(e.message)
end

function ChatController:pull()
	local playerModel = Utility.Peep.getPlayerModel(self:getPeep())
	local messages = playerModel:getMessages()

	local result = {}
	for i = 1, #messages do
		local m = messages[i]

		local name
		do
			local peep = m.player:getActor()
			peep = peep and peep:getPeep()

			if not peep then
				name = m.lastKnownName
			else
				name = peep:getName()
			end

			m.lastKnownName = name
		end

		result[i] = {
			{ 0, 1, 1, 1 },
			m.lastKnownName,
			{ 1, 1, 1, 1 },
			": " .. m.message
		}
	end

	return {
		messages = result,
		received = messages.received
	}
end

return ChatController
