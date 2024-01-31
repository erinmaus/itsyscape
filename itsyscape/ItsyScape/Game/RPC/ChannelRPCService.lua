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
local NBuffer = require "nbunny.gamemanager.buffer"
local NEventQueue = require "nbunny.gamemanager.eventqueue"
local NVariant = require "nbunny.gamemanager.variant"

local ChannelRPCService = Class(RPCService)
ChannelRPCService.CLIENT_ID = 0

function ChannelRPCService:new(inputChannel, outputChannel, isBlocking)
	RPCService.new(self)

	self.inputChannel = inputChannel
	self.outputChannel = outputChannel
	self.isBlocking = isBlocking or false

	self.queue = NEventQueue()
	self.event = NVariant()
end

function ChannelRPCService:sendBatch(channel, e)
	self.outputChannel:push(e)
end

function ChannelRPCService:send(channel, e)
	self.outputChannel:push(NBuffer.create(e))
end

function ChannelRPCService:wrap()
	self.event.clientID = ChannelRPCService.CLIENT_ID
	return self.event
end

function ChannelRPCService:_pop()
	if self.queue:length() > 0 then
		self.queue:pop(self.event)
		self.event.clientID = ChannelRPCService.CLIENT_ID

		return self.event
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
			if type(e) == "userdata" then
				self.queue:fromBuffer(e)
				NBuffer.free(e)
			end

			result = self:_pop()
		end
	end

	return result
end

return ChannelRPCService
