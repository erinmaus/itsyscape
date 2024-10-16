--------------------------------------------------------------------------------
-- ItsyScape/Game/Dialog/Dialog.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Message = require "ItsyScape.Game.Dialog.Message"
local Executor = require "ItsyScape.Game.Dialog.Executor"
local InputPacket = require "ItsyScape.Game.Dialog.InputPacket"
local MessagePacket = require "ItsyScape.Game.Dialog.MessagePacket"
local SelectPacket = require "ItsyScape.Game.Dialog.SelectPacket"
local SpeakerPacket = require "ItsyScape.Game.Dialog.SpeakerPacket"

local Dialog = Class()
function Dialog:new(filename)
	do
		local c, m = loadstring(love.filesystem.read(filename) or "", filename)
		if not c then
			error(m)
		end

		self.executor = Executor(c)
	end
end

function Dialog:getSpeaker(name)
	local speakers = self.executor:getG()._SPEAKERS or {}
	return speakers[name]
end

function Dialog:setSpeaker(name, peep)
	local speakers = self.executor:getG()._SPEAKERS or {}
	speakers[name] = peep

	self.executor:getG()._SPEAKERS = speakers
end

function Dialog:setTarget(target)
	self.executor:getG()._TARGET = target
	self:setSpeaker("_TARGET", target)
end

function Dialog:getTarget(target)
	return self.executor:getG()._TARGET or false
end

function Dialog:setDirector(target)
	self.executor:getG()._DIRECTOR = target
end

function Dialog:getDirector(target)
	return self.executor:getG()._DIRECTOR or false
end

function Dialog:start()
	return self:next()
end

function Dialog:next(...)
	local s, t, arg = self.executor:step(...)

	if not s then
		Log.warn(t)
		return false
	end

	if t == 'input' then
		return InputPacket(self, arg)
	elseif t == 'message' then
		return MessagePacket(self, arg)
	elseif t == 'select' then
		return SelectPacket(self, arg)
	elseif t == 'speaker' then
		return SpeakerPacket(self, arg)
	end

	return false
end

return Dialog
