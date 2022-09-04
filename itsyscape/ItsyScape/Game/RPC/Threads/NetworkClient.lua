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

local host
local clients = {}
local isRunning = true
local isDisconnecting = false
while isRunning do
	local e

	repeat
		e = inputChannel:pop()
		if e then
			if e.type == "send" then
				local client = clients[e.client]
				if client then
					client:send(love.data.compress('string', 'lz4', e.data, -1))
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

				for _, client in pairs(clients) do
					Log.engine("Disconnecting client %d...", client:connect_id())
					client:disconnect(client:connect_id())
				end

				isDisconnecting = true
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
				clients[e.peer:connect_id()] = e.peer
				Log.engine("Client (%d) connected.", e.peer:connect_id())

				outputChannel:push({
					type = "connect",
					client = e.peer:connect_id()
				})

				if isDisconnecting then
					Log.engine("Whoops, server is shutting down. Disconnecting client %d.", e.peer:channel_id())
					e.peer:disconnect(e.peer:connect_id())
				end
			elseif e.type == "disconnect" then
				if not e.data then
					Log.warn("Disconnect received but no connect ID provided (peer %d).", e.peer:connect_id())
				elseif not clients[e.data] then
					Log.warn("Disconnect received but no client with ID %d.", e.data)
				else
					clients[e.data] = nil
					Log.engine("Client (%d) disconnected.", e.data)

					outputChannel:push({
						type = "disconnect",
						client = e.data
					})
				end

				if isDisconnecting and next(clients, nil) == nil then
					Log.engine("All clients disconnected; shutting down.")
					isRunning = false
				end
			end
		end
	until e == nil
end

if host then
	host:destroy()
end

Log.quit()
