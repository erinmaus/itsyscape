--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/ClientRPCService.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local buffer = require "string.buffer"
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local NetworkRPCService = require "ItsyScape.Game.RPC.NetworkRPCService"
local NEventQueue = require "nbunny.gamemanager.eventqueue"
local NVariant = require "nbunny.gamemanager.variant"
local NBuffer = require "nbunny.gamemanager.buffer"

local ClientRPCService = Class(NetworkRPCService)

function ClientRPCService:new(listenAddress, port)
	NetworkRPCService.new(self, "client_rpc_service")
	self:connectToServer(listenAddress, port)

	self.pending = {}

	self.onDisconnect = Callback()

	self._queue = NEventQueue()
	self._event = NVariant()
end

function ClientRPCService:connectToServer(listenAddress, port)
	self:sendConnectEvent(string.format("%s:%s", listenAddress, port))
end

function ClientRPCService:sendBatch(channel, e)
	self:sendBatchNetworkEvent(self.clientID, e)
end

function ClientRPCService:send(channel, e)
	local packet = buffer.encode(e)
	if not self.clientID then
		table.insert(self.pending, packet)
	else
		self:sendNetworkEvent(self.clientID, packet)
	end
end

function ClientRPCService:_doConnect(clientID)
	self.clientID = clientID
	Log.info("Client connected.")

	if #self.pending > 0 then
		Log.info("Sending %d pending packets...", #self.pending)
		for i = 1, #self.pending do
			self:sendNetworkEvent(self.clientID, self.pending[i])
		end
		Log.info("Sent %d pending packets.", #self.pending)
		table.clear(self.pending)
	end
end

function ClientRPCService:_doDisconnect(clientID)
	if self.clientID == clientID then
		Log.info("Client disconnected.")
		self:onDisconnect(self.clientID)
		self.clientID = nil
	else
		Log.warn("Unknown client (%d) disconnected; current client is %d.", clientID, self.clientID)
	end
end

function ClientRPCService:getIsConnected()
	return self.clientID ~= nil
end

function ClientRPCService:handleNetworkEvent(e)
	if e.type == "receive" then
		self._queue:fromBuffer(e.data)
		NBuffer.free(e.data)

		self._queue:pop(self._event)
		self._event.clientID = e.client

		return self._event
	elseif e.type == "connect" then
		self:_doConnect(e.client)
	elseif e.type == "disconnect" then
		self:_doDisconnect(e.client)
	end

	return nil
end

return ClientRPCService
