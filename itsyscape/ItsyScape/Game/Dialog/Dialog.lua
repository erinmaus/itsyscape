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
local MessagePacket = require "ItsyScape.Game.Dialog.MessagePacket"
local SelectPacket = require "ItsyScape.Game.Dialog.SelectPacket"

local Dialog = Class()
function Dialog:new(filename)
	do
		local c, m = loadstring(love.filesystem.read(filename) or "", filename)
		if not c then
			error(m)
		end

		self.executor = Executor:new(c)
	end
end

function Dialog:start()
	return self:next()
end

function Dialog:next(...)
	local t, messages = self.executor:step()

	if t == 'message' then
		return MessagePacket(self, messages)
	elseif t == 'select' then
		return SelectPacket(self, messages)
	else
		Log.error("Expected message or select packet, got %s.", tostring(t))
	end

	return false
end

return Dialog
