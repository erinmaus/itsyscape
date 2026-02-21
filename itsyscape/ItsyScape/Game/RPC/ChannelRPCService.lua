--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/ChannelRPCService.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local EventQueue = require "ItsyScape.Game.RPC.EventQueue"
local RPCService = require "ItsyScape.Game.RPC.RPCService"
local NPooledBuffer = require "nbunny.pooledbuffer"

local ChannelRPCService = Class(RPCService)
ChannelRPCService.CLIENT_ID = 0

function ChannelRPCService:new(inputChannel, outputChannel, isBlocking)
	RPCService.new(self)

	self.inputChannel = inputChannel
	self.outputChannel = outputChannel
	self.isBlocking = isBlocking or false
end

function ChannelRPCService:connect(gameManager)
	RPCService.connect(self, gameManager)

	self.queue, self.queueConfig = EventQueue.newBuffer(gameManager)
end

function ChannelRPCService:sendBatch(channel, e)
	local message = NPooledBuffer.new(table.clear)
	NPooledBuffer.copy(e, message)

	self.outputChannel:push(message)
end

function ChannelRPCService:_pop()
	if NPooledBuffer.pending(self.queue) then
		local event = NPooledBuffer.perform(NPooledBuffer.decode, self.queue, self.queueConfig)
		event.clientID = ChannelRPCService.CLIENT_ID

		return event
	end

	return nil
end

function ChannelRPCService:receive(c)
	local result = self:_pop()
	if not result then
		local e
		if self.isBlocking then
			e = self.inputChannel:demand()
		else
			e = self.inputChannel:pop()
		end

		if e then
			if type(e) == "userdata" then
				NPooledBuffer.reset(self.queue)
				NPooledBuffer.copy(e, self.queue)
				NPooledBuffer.restart(self.queue)
				NPooledBuffer.free(e)

				self.queueConfig.inputTablePool, self.queueConfig.outputTablePool = self.queueConfig.outputTablePool, self.queueConfig.inputTablePool
			end

			result = self:_pop()
		end
	end

	return result
end

return ChannelRPCService
