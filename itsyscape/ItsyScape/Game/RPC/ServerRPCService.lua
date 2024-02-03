--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/ServerRPCService.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local NetworkRPCService = require "ItsyScape.Game.RPC.NetworkRPCService"
local NEventQueue = require "nbunny.gamemanager.eventqueue"
local NVariant = require "nbunny.gamemanager.variant"
local NBuffer = require "nbunny.gamemanager.buffer"

local ServerRPCService = Class(NetworkRPCService)

ServerRPCService.Client = Class()
function ServerRPCService.Client:new(clientID, serverRPCService)
	self.clientID = clientID
	self.serverRPCService = serverRPCService

	self.isPendingConnect = true
	self.isDisconnected = false
end

function ServerRPCService.Client:getID()
	return self.clientID
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
		Log.warn("Client %d is already connected.", self:getID())
		return
	end

	local gameManager = self.serverRPCService:getGameManager()
	local gameInstance = gameManager and gameManager:getInstance("ItsyScape.Game.Model.Game", 0)
	local game = gameInstance and gameInstance:getInstance()

	if game then
		self.player = game:spawnPlayer(self:getID())
		self.player.onForceDisconnect:register(function()
			Log.info("Forcefully disconnecting player %d (client %d).", self.player:getID(), self.player:getClientID())
			self:disconnect()
		end)
		self.isPendingConnect = false

		Log.info("Associated player ID %d with client %d.", self.player:getID(), self:getID())
	else
		Log.warn("Could not get game to connect client %d.", self:getID())
	end
end

function ServerRPCService.Client:disconnect()
	if not self:getIsConnected() then
		Log.warn("Client %d is not yet connected.", self:getID())
		return
	end

	if self.player then
		self.player:poof()
		self.serverRPCService:sendDisconnectEvent(self:getID())
		Log.info("Client %d disconnected.", self:getID())
	else
		Log.warn("Client %d does not have a player.")
	end
end

function ServerRPCService.Client:send(packet)
	self.serverRPCService:sendNetworkEvent(self:getID(), packet)
end

function ServerRPCService.Client:sendBatch(batch)
	self.serverRPCService:sendBatchNetworkEvent(self:getID(), batch)
end

function ServerRPCService:new(listenAddress, port)
	NetworkRPCService.new(self, "server_rpc_service")
	self:host(listenAddress, port)

	self.clients = {}
	self.clientsByID = {}

	self._queue = NEventQueue()
	self._event = NVariant()
end

function ServerRPCService:host(listenAddress, port)
	self:sendListenEvent(string.format("%s:%s", listenAddress, port))
end

function ServerRPCService:disconnect(channel)
	local client = self.clientsByID[channel]
	if client then
		client:disconnect()
	end
end

function ServerRPCService:send(channel, e)
	local client = self.clientsByID[channel]
	if client then
		client:send(e)
	end
end

function ServerRPCService:sendBatch(channel, batch)
	local client = self.clientsByID[channel]
	if client then
		client:sendBatch(batch)
	end
end

function ServerRPCService:_doConnect(clientID)
	local rpcClient = ServerRPCService.Client(clientID, self)
	rpcClient:connect()

	table.insert(self.clients, rpcClient)
	self.clientsByID[rpcClient:getID()] = rpcClient
end

function ServerRPCService:_doDisconnect(clientID)
	self.clientsByID[clientID] = nil

	for i = 1, #self.clients do
		local c = self.clients[i]
		if c:getID() == clientID then
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

function ServerRPCService:handleNetworkEvent(e)
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

return ServerRPCService
