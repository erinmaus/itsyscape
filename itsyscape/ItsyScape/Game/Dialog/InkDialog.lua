--------------------------------------------------------------------------------
-- ItsyScape/Game/Dialog/InkDialog.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local json = require "json"
local Nomicon = require "nomicon"
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local InputPacket = require "ItsyScape.Game.Dialog.InputPacket"
local Message = require "ItsyScape.Game.Dialog.Message"
local MessagePacket = require "ItsyScape.Game.Dialog.MessagePacket"
local SelectPacket = require "ItsyScape.Game.Dialog.SelectPacket"
local SpeakerPacket = require "ItsyScape.Game.Dialog.SpeakerPacket"

local InkDialog = Class()
function InkDialog:new(filename, variables)
	local data = love.filesystem.read(filename)
	if not data then
		error(string.format("Dialog (filename = '%s') does not exist.", filename))
	end

	local dialog = json.decode(data)
	self.story = Nomicon.Story(dialog)
	self.story:listenForGlobalVariable("*", self._setVariable, false, self)
	self.choices = Nomicon.ChoiceList(self.story)
	self.speakers = {}

	self.variables = {}
	if variables then
		self:setVariables(variables)
	end

	self.pendingPackets = {}

	self.director = false

	self.onSetVariable = Callback()
end

function InkDialog:jump(knot)
	self.story:choose(knot)
end

function InkDialog:bindExternalFunction(funcName, func, ...)
	self.story:bindExternalFunction(funcName, func, true, ...)
end

function InkDialog:getVariables()
	return self.variables
end

function InkDialog:setVariables(variables)
	for k, v in pairs(variables) do
		self.variables[k] = v

		if type(v) == "table" then
			v = self.story:getListDefinitions():newListFromValueNames(unpack(v))
		end

		self.story:setGlobalVariable(k, v)
	end
end

function InkDialog:_setVariable(variableName, value)
	if value:getType() == Nomicon.Constants.TYPE_LIST then
		local list = value:getValue()
		local result = {}

		for _, listValue in list:values() do
			table.insert(result, listValue:getName())
		end

		self.variables[variableName] = result
	else
		self.variables[variableName] = value
	end

	self:onSetVariable(variableName, self.variables[variableName])
end

function InkDialog:getSpeaker(name)
	return self.speakers[name]
end

function InkDialog:setSpeaker(name, peep)
	self.speakers[name] = peep
end

function InkDialog:setTarget(target)
	self:setSpeaker("_TARGET", target)
end

function InkDialog:getTarget(target)
	return self:getSpeaker("_TARGET")
end

function InkDialog:setDirector(value)
	self.director = value or false
end

function InkDialog:getDirector()
	return self.director
end

function InkDialog:start()
	return self:next()
end

function InkDialog:processTags(tags)
	for _, tag in ipairs(tags) do
		local tagType, tagValue = tag:match("([%w_]+)%s*=%s*(.*)")
		if tagType == "speaker" then
			table.insert(self.pendingPackets, SpeakerPacket(self, tagValue))
		end
	end
end

function InkDialog:next(choiceIndex)
	if #self.pendingPackets > 0 then
		return table.remove(self.pendingPackets, 1)
	end

	if choiceIndex then
		self.choices:getChoice(choiceIndex):choose()
		table.insert(self.pendingPackets, 1, SpeakerPacket(self, "_TARGET"))
	end

	if not self.story:canContinue() then
		print("STORY OVER")
		return false
	end

	local text, tags = self.story:continue()

	if #tags > 0 then
		self:processTags(tags)
	end

	if not text:match("^%s*$") then
		local message = Message(text)
		table.insert(self.pendingPackets, MessagePacket(self, { message }))
	end

	if self.choices:hasChoices() then
		local options = {}

		for i = 1, self.choices:getChoiceCount() do
			table.insert(options, Message(self.choices:getChoice(i):getText()))
		end

		table.insert(self.pendingPackets, SelectPacket(self, options))
	end

	return self:next()
end

return InkDialog
