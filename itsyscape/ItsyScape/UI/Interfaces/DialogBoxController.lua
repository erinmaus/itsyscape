--------------------------------------------------------------------------------
-- ItsyScape/UI/DialogBoxController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Dialog = require "ItsyScape.Game.Dialog.Dialog"
local MessagePacket = require "ItsyScape.Game.Dialog.MessagePacket"
local SelectPacket = require "ItsyScape.Game.Dialog.SelectPacket"
local SpeakerPacket = require "ItsyScape.Game.Dialog.SpeakerPacket"
local Controller = require "ItsyScape.UI.Controller"

local DialogBoxController = Class(Controller)

function DialogBoxController:new(peep, director, action)
	Controller.new(self, peep, director)

	self.action = action

	self.state = {}
	do
		-- TODO: respect language
		local gameDB = director:getGameDB()
		local dialogRecord = gameDB:getRecord("TalkDialog", { Action = action, Language = "en-US" })
		if dialogRecord then
			local filename = dialogRecord:get("Script")
			if filename then
				self.dialog = Dialog(filename)

				self.dialog:setTarget(peep)
				self.dialog:getDirector(director)

				self:pump()
			end
		end
	end

	self.needsPump = true
end

function DialogBoxController:poke(actionID, actionIndex, e)
	if actionID == "select" then
		self:select(e)
	elseif actionID == "next" then
		self:next(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function DialogBoxController:select(e)
	assert(self.currentPacket:isType(SelectPacket), "current packet not select packet")
	assert(type(e.index) == "number", "index must be number")
	assert(e.index > 0 and e.index <= self.currentPacket:getNumOptions(), "option out-of-bounds")

	self:pump(self.currentPacket, e.index)
end

function DialogBoxController:next(e)
	assert(self.currentPacket:isType(MessagePacket), "current packet not message packet")

	self:pump(self.currentPacket)
end

function DialogBoxController:pump(e, ...)
	if e then
		self.currentPacket = e:step(...)
	else
		self.currentPacket = self.dialog:start()
	end

	if self.currentPacket then
		if self.currentPacket:isType(MessagePacket) then
			self.state = {
				speaker = self.state.speaker or "",
				content = { self.currentPacket:getMessage()[1]:inflate() }
			}
		elseif self.currentPacket:isType(SelectPacket) then
			local options = {}
			for i = 1, self.currentPacket:getNumOptions() do
				options[i] = self.currentPacket:getOptionAtIndex(i):inflate()
			end

			self.state = {
				speaker = self.state.speaker or "",
				options = options
			}
		elseif self.currentPacket:isType(SpeakerPacket) then
			local gameDB = self:getDirector():getGameDB()
			local speaker = gameDB:getRecord("TalkSpeaker", { Action = self.action, Name = self.currentPacket:getSpeaker() })
			if speaker then
				local name = Utility.getName(speaker:get("Resource"), gameDB) or ""
				self.state.speaker = name
			end

			-- Pump again. We want a Packet that requires us to wait.
			self:pump()
		end
	else
		self.state = { done = true }
	end

	if not self.currentPacket or
	   self.currentPacket:isType(SelectPacket) or
	   self.currentPacket:isType(MessagePacket)
	then
		self.needsPump = true

		if not self.currentPacket then
			self:getDirector():getGameInstance():getUI():closeInstance(self)
		end
	end
end

function DialogBoxController:pull()
	return self.state
end

function DialogBoxController:update(...)
	Controller.update(self, ...)

	if self.needsPump then
		self:getDirector():getGameInstance():getUI():sendPoke(
			self,
			"next",
			nil,
			{})
		self.needsPump = false
	end
end

return DialogBoxController
