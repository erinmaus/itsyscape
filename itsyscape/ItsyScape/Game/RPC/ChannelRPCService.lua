--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/ChannelRPCService.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local buffer = require "string.buffer"
local Class = require "ItsyScape.Common.Class"
local RPCService = require "ItsyScape.Game.RPC.RPCService"

local ChannelRPCService = Class(RPCService)

function ChannelRPCService:new(inputChannel, outputChannel, isBlocking)
	RPCService.new(self)

	self.inputChannel = inputChannel
	self.outputChannel = outputChannel
	self.isBlocking = isBlocking or false
end

function ChannelRPCService:send(channel, e)
	self.outputChannel:push(buffer.encode(e))
end

function ChannelRPCService:receive()
	local e
	if self.isBlocking then
		e = self.inputChannel:demand()
	else
		e = self.inputChannel:pop()
	end

	if e then
		return buffer.decode(e)
	end

	return nil
end

return ChannelRPCService
