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
ChannelRPCService.CLIENT_ID = 0

function ChannelRPCService:new(inputChannel, outputChannel, isBlocking)
	RPCService.new(self)

	self.inputChannel = inputChannel
	self.outputChannel = outputChannel
	self.isBlocking = isBlocking or false

	self.pending = {}
	self.pendingIndex = 1
end

function ChannelRPCService:sendBatch(channel, batch)
	self.outputChannel:push(buffer.encode(batch))
end

function ChannelRPCService:send(channel, e)
	self.outputChannel:push(buffer.encode(e))
end

function ChannelRPCService:wrap(e)
	e.clientID = ChannelRPCService.CLIENT_ID
	return e
end

function ChannelRPCService:receive()
	if self.pendingIndex < #self.pending then
		self.pendingIndex = self.pendingIndex + 1
		return self.pending[self.pendingIndex]
	end

	local e
	if self.isBlocking then
		e = self.inputChannel:demand()
	else
		e = self.inputChannel:pop()
	end

	if e then
		e = buffer.decode(e)

		if #e > 0 then
			self.pending = e
			self.pendingIndex = 1

			return self:wrap(self.pending[1])
		else
			return self:wrap(e)
		end
	end

	return nil
end

return ChannelRPCService
