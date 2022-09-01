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

ServerRPCService.Client = Class()
function ServerRPCService.Client:new(client, serverRPCService)
	self.client = client
	self.serverRPCService = serverRPCService

	self.isPendingConnect = true
	self.isDisconnected = false
end

function ServerRPCService.Client:getID()
	return self.client:connect_id()
end

function ServerRPCService.Client:getIsPendingConnect()
	return self.isPendingConnect
end

function ServerRPCService.Client:getIsConnected()
	return not self.isPendingConnect and not self.isDisconnected
end

function ServerRPCService.Client:getIsDisconnected()
	return self.isDisconnected and not self.isPendingConnect
end

function ServerRPCService.Client:connect()
	if not self:getIsPendingConnect() then
		Log.warn("Client %d is already connected.", self.client:connect_id())
		return
	end

	local gameManager = self.serverRPCService:getGameManager()
	local gameInstance = gameManager and gameManager:getInstance("ItsyScape.Game.Model.Game", 0)
	local game = gameInstance and gameInstance:getInstance()

	if game then
		self.player = game:spawnPlayer(self.client:connect_id())
		self.isPendingConnect = false

		Log.info("Associated player ID %d with client %d.", self.player:getID(), self.client:connect_id())
	else
		Log.warn("Could not get game to connect client %d.", self.client:connect_id())
	end
end

function ServerRPCService.Client:disconnect()
	if not self:getIsConnected() then
		Log.warn("Client %d is not yet connected.", self.client:connect_id())
		return
	end

	if self.player then
		self.player:poof()
		Log.info("Client %d disconnected.", self.client:connect_id())
	else
		Log.warn("Client %d does not have a player.")
	end
end

function ServerRPCService.Client:send(packet)
	self.client:send(packet)
end

function ServerRPCService:new(listenAddress, port)
	RPCService.new(self)

	self.host = enet.host_create(string.format("%s:%s", listenAddress, port))
	self.clients = {}
	self.clientsByID = {}

	self.pending = {}
end

function ServerRPCService:send(channel, e)
	local packet = love.data.compress('string', 'lz4', buffer.encode(e), -1)
	local client = self.clientsByID[channel]
	if client then
		client:send(packet)
	end
end

function ServerRPCService:_doConnect(client)
	local rpcClient = ServerRPCService.Client(client, self)
	rpcClient:connect()

	table.insert(self.clients, rpcClient)
	self.clientsByID[rpcClient:getID()] = rpcClient
end

function ServerRPCService:_doDisconnect(client)
	self.clientsByID[client:getID()] = nil

	for i = 1, #self.clients do
		local c = self.clients[i]
		if c:getID() == client:connect_id() then
			c:disconnect()
			table.remove(self.clients, i)
			break
		end
	end

	if #self.clients == 0 then
		local gameManager = self:getGameManager()
		local gameInstance = gameManager and gameManager:getInstance("ItsyScape.Game.Model.Game", 0)
		local game = gameInstance and gameInstance:getInstance()

		if game then
			game:quit()
		end
	end
end

function ServerRPCService:receive()
	local e
	repeat
		e = self.host:service(0)
		if e then
			if e.type == "receive" then
				local event = buffer.decode(love.data.decompress('string', 'lz4', e.data))
				event.clientID = e.peer:connect_id()

				return event
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
