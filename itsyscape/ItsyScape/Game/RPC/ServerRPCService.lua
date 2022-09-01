--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/ServerRPCService.lua
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

local ServerRPCService = Class(RPCService)

function ServerRPCService:new(listenAddress, port)
	RPCService.new(self)

	self.host = enet.host_create(string.format("%s:%s", listenAddress, port))
	self.clients = {}

	self.pending = {}
end

function ServerRPCService:send(channel, e)
	local packet = love.data.compress('string', 'lz4', buffer.encode(e), -1)

	if #self.clients == 0 then
		table.insert(self.pending, packet)
	else
		for i = 1, #self.clients do
			local client = self.clients[i]
			client:send(packet)
		end
	end
end

function ServerRPCService:_doConnect(client)
	if #self.clients == 0 then
		for i = 1, #self.pending do
			print("send", i)
			client:send(self.pending[i])
		end

		table.clear(self.pending)
	end

	Log.info("Client connected.")
	table.insert(self.clients, client)
end

function ServerRPCService:_doDisconnect(client)
	for i = 1, #self.clients do
		local c = self.clients[i]
		if c:connect_id() == client:connect_id() then
			table.remove(self.clients, i)
			Log.info("Client disconnected.")
			break
		end
	end
end

function ServerRPCService:receive()
	local e
	repeat
		e = self.host:service(0)
		if e then
			if e.type == "receive" then
				return buffer.decode(love.data.decompress('string', 'lz4', e.data))
			elseif e.type == "connect" then
				self:_doConnect(e.peer)
			elseif e.type == "disconnect" then
				self:_doDisconnect(e.peer)
			end
		end
	until e == nil

	return nil
end

return ServerRPCService
