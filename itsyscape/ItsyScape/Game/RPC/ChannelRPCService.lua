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
local EventQueue = require "ItsyScape.Game.RPC.EventQueue"
local RPCService = require "ItsyScape.Game.RPC.RPCService"

local ChannelRPCService = Class(RPCService)
ChannelRPCService.CLIENT_ID = 0

function ChannelRPCService:new(inputChannel, outputChannel, isBlocking)
	RPCService.new(self)

	self.inputChannel = inputChannel
	self.outputChannel = outputChannel
	self.isBlocking = isBlocking or false
	self.queue = EventQueue.newBuffer()
end

function ChannelRPCService:sendBatch(channel, e)
	self.outputChannel:push(e)
end

function ChannelRPCService:send(channel, e)
	self.outputChannel:push(buffer.encode({ e }))
end

function ChannelRPCService:_pop()
	if #self.queue > 0 then
		local event = self.queue:decode()
		event.clientID = ChannelRPCService.CLIENT_ID

		if event.value then
			for i = 1, event.value.n do
				local v = event.value.arguments[i]
				if type(v) == "table" and v.__interface and v.__id then
					local instance = self:getGameManager():getInstance(v.__interface, v.__id)
					event.value.arguments[i] = instance and instance:getInstance() or nil
				end
			end
		end

		return event
	end

	return nil
end

function ChannelRPCService:receive()
	local result = self:_pop()
	if not result then
		local e
		if self.isBlocking then
			e = self.inputChannel:demand()
		else
			e = self.inputChannel:pop()
		end

		if e then
			if type(e) == "string" then
				self.queue:set(e)
			end

			result = self:_pop()
		end
	end

	return result
end

return ChannelRPCService
