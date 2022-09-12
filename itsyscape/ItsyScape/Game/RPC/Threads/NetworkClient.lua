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
local buffer = require "string.buffer"
local cerror = require "nbunny.cerror"

Log.info("Network client with scope '%s' started.", logSuffix)

local function getClientAddress(e)
	return tostring(e.peer)
end

local host
local clients = {}
local clientsByID = {}
local clientIDs = {}
local isRunning = true
local isDisconnecting = false

local function disconnectAllClients()
	for _, client in pairs(clients) do
		Log.engine("Disconnecting client %d...", client:connect_id())
		client:disconnect_later()
	end
end

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
			elseif e.type == "batch" then
				local batch = buffer.decode(e.batch)
				local client = clientsByID[e.client]
				if client then
					for i = 1, #batch do
						local b = batch[i]

						local flag
						if b.__reliable then
							flag = 'reliable'
						else
							flag = 'unsequenced'
						end

						local channel = b.__channel

						client:send(love.data.compress('string', 'lz4', buffer.encode(b), -1), channel, flag)
					end
				else
					Log.warnOnce("Client %d does not exist; cannot batch send.", e.client)
				end
			elseif e.type == "disconnect" then
				local client = clientsByID[e.client]
				if client then
					Log.info("Disconnecting client %d...")
					client:disconnect_later(client:connect_id())
				else
					Log.warnOnce("Client %d does not exist; cannot disconnect.", e.client)
				end
			elseif e.type == "listen" then
				disconnectAllClients()
				Log.engine("Listening @ '%s'.", e.address)
				local s, e = pcall(enet.host_create, e.address)
				if not s then
					Log.warn("Error listening: %s.", e)
					outputChannel:push({
						type = "error",
						message = e
					})
				else
					host = e
				end
			elseif e.type == "connect" then
				disconnectAllClients()

				Log.engine("Connecting @ '%s'.", e.address)

				host = enet.host_create()
				local s, e = pcall(host.connect, host, e.address)
				if not s then
					Log.warn("Error connecting: %s.", e)
					outputChannel:push({
						type = "error",
						message = e
					})

					host = nil
				end
			elseif e.type == "quit" then
				Log.engine("Received quit event; terminating...")

				if next(clients, nil) == nil then
					Log.engine("No clients; terminating immediately.")
					isRunning = false
				else
					disconnectAllClients()

					Log.engine("Waiting on acknowledgement from clients...")
					isDisconnecting = true
				end
			end
		end
	until e == nil

	repeat
		if host then
			local s, r = pcall(host.service, host, 0)
			if not s then
				Log.warnOnce("Error running service: %s (errno = %d, error = %s)", r, cerror())
				e = nil
			else
				e = r
			end
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
						Log.engine("Whoops, server is shutting down. Disconnecting client %d (address = %s).", e.peer:connect_id(), address)
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
