--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/Threads/NetworkClient.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local inputChannel, outputChannel, logSuffix = ...

_LOG_SUFFIX = logSuffix
require "bootstrap"

local enet = require "enet"

Log.info("Network client with scope '%s' started.", logSuffix)

local MAX_DISCONNECT_TIME_IN_SECONDS = 5

local function getClientAddress(e)
	return tostring(e.peer)
end

local host
local clients = {}
local clientsByID = {}
local clientIDs = {}
local isRunning = true
local isDisconnecting = false
while isRunning do
	local e

	repeat
		e = inputChannel:pop()
		if e then
			if e.type == "send" then
				local client = clientsByID[e.client]
				if client then
					client:send(love.data.compress('string', 'lz4', e.data, -1))
				else
					Log.warnOnce("Client %d does not exist; cannot send.", e.client)
				end
			elseif e.type == "listen" then
				Log.engine("Listening @ '%s'.", e.address)
				host = enet.host_create(e.address)
			elseif e.type == "connect" then
				Log.engine("Connecting @ '%s'.", e.address)
				host = enet.host_create()
				host:connect(e.address)
			elseif e.type == "quit" then
				Log.engine("Received quit event; terminating...")

				if next(clients, nil) == nil then
					Log.engine("No clients; terminating immediately.")
					isRunning = false
				else
					for _, client in pairs(clients) do
						Log.engine("Disconnecting client %d...", client:connect_id())
						client:disconnect()
					end

					Log.engine("Waiting on acknowledgement from clients...")
					isDisconnecting = true
				end
			end
		end
	until e == nil

	repeat
		if host then
			e = host:service(0)
		end

		if e then
			if e.type == "receive" then
				outputChannel:push({
					type = "receive",
					client = e.peer:connect_id(),
					data = love.data.decompress('string', 'lz4', e.data)
				})
			elseif e.type == "connect" then
				local address = getClientAddress(e)
				local clientID = e.peer:connect_id()

				if clients[address] or clientIDs[address] then
					Log.warn(
						"Client (%d, address = %s) already connected as (%d, address = %s); not connecting again and disconnecting new peer.",
						clientID, address, clientIDs[address] or -1, tostring(clients[address]))
					e.peer:disconnect()
				else
					clients[address] = e.peer
					clientsByID[clientID] = e.peer
					clientIDs[address] = clientID

					Log.engine("Client (%d, address = %s) connected.", e.peer:connect_id(), address)

					outputChannel:push({
						type = "connect",
						client = e.peer:connect_id()
					})

					if isDisconnecting then
						Log.engine("Whoops, server is shutting down. Disconnecting client %d (address = %s).", e.peer:channel_id(), address)
						e.peer:disconnect()
					end
				end
			elseif e.type == "disconnect" then
				local address = getClientAddress(e)
				local clientID = clientIDs[address]

				if not clientID then
					Log.warn("Client (address = %s) is not connected; cannot disconnect.", address)
				else
					Log.engine("Client (%d, address = %s) disconnected.", clientID, address)

					outputChannel:push({
						type = "disconnect",
						client = clientID
					})

					clients[address] = nil
					clientIDs[address] = nil
					clientsByID[clientID] = nil

					if isDisconnecting and next(clients, nil) == nil then
						Log.engine("All clients disconnected; shutting down.")
						isRunning = false
					end
				end
			end
		end
	until e == nil
end

if host then
	host:destroy()
end

Log.quit()
