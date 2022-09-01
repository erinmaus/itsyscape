--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/ClientRPCService.lua
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

local ClientRPCService = Class(RPCService)

function ClientRPCService:new(listenAddress, port)
	RPCService.new(self)

	self.host = enet.host_create()
	self.host:connect(string.format("%s:%s", listenAddress, port))

	self.pending = {}
end

function ClientRPCService:send(channel, e)
	local packet = love.data.compress('string', 'lz4', buffer.encode(e), -1)
	if not self.client then
		table.insert(self.pending, packet)
	else
		self.client:send(packet)
	end
end

function ClientRPCService:_doConnect(client)
	self.client = client
	Log.info("Client connected.")

	if #self.pending > 0 then
		Log.info("Sending %d pending packets...", #self.pending)
		for i = 1, #self.pending do
			self.client:send(self.pending[i])
		end
		Log.info("Sent #d pending packets.", #self.pending)
		table.clear(self.pending)
	end
end

function ClientRPCService:_doDisconnect(client)
	if self.client:connect_id() == client:connect_id() then
		Log.info("Client disconnected.")
		self.client = nil
	else
		Log.warn("Unknown client disconnected.")
	end
end

function ClientRPCService:receive()
	local e
	repeat
		e = self.host:service(0)
		if e then
			if e.type == "receive" then
				return buffer.decode(love.data.decompress('string', 'lz4', e.data))
			elseif e.type == "connect" then
				self:_doConnect(e.peer)
			elseif e.type == "disconnect" then
				self._doDisconnect(e.peer)
			end
		end
	until e == nil

	return nil
end

return ClientRPCService
