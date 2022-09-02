--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/NetworkRPCService.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local enet = require "enet"
local buffer = require "string.buffer"
local Class = require "ItsyScape.Common.Class"
local RPCService = require "ItsyScape.Game.RPC.RPCService"

local NetworkRPCService = Class(RPCService)
NetworkRPCService.THREAD = "ItsyScape/Game/RPC/Threads/NetworkClient.lua"

function NetworkRPCService:new(scope)
	RPCService.new(self)

	self.scope = scope

	self.inputChannel = love.thread.newChannel()
	self.outputChannel = love.thread.newChannel()

	self.thread = love.thread.newThread(NetworkRPCService.THREAD)
	self.thread:start(self.outputChannel, self.inputChannel, scope)
end

function NetworkRPCService:close()
	self.outputChannel:push({
		type = "quit"
	})

	self.thread:wait()
	local e = self.thread:getError()
	if e then
		Log.warn("Error quitting '%s' thread: %s", e)
	end
end

function NetworkRPCService:sendConnectEvent(address)
	self.outputChannel:push({
		type = "connect",
		address = address
	})
end

function NetworkRPCService:sendListenEvent(address)
	self.outputChannel:push({
		type = "listen",
		address = address
	})
end

function NetworkRPCService:handleNetworkEvent(e)
	return nil
end

function NetworkRPCService:sendNetworkEvent(clientID, packet)
	self.outputChannel:push({
		type = "send",
		client = clientID,
		data = packet
	})
end

function NetworkRPCService:receive()
	local e
	repeat
		e = self.inputChannel:pop()
		if e then
			local response = self:handleNetworkEvent(e)
			if response then
				return response
			end
		end
	until e == nil
end

return NetworkRPCService
