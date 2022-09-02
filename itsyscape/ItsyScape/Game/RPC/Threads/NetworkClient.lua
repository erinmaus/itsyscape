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

local host
local clients = {}
local isRunning = true
while isRunning do
	local e

	repeat
		e = inputChannel:pop()
		if e then
			if e.type == "send" then
				local client = clients[e.client]
				if client then
					client:send(e.data)
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

				if host then
					host:flush()
					Log.engine("Disconnected all clients.")
				end

				isRunning = false
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
					data = e.data
				})
			elseif e.type == "connect" then
				clients[e.peer:connect_id()] = e.peer
				Log.engine("Client (%d) connected.", e.peer:connect_id())

				outputChannel:push({
					type = "connect",
					client = e.peer:connect_id()
				})
			elseif e.type == "disconnect" then
				clients[e.data or e.peer:connect_id()] = nil
				Log.engine("Client (%d) disconnected.", e.data or e.peer:connect_id())

				outputChannel:push({
					type = "disconnect",
					client = e.data or e.peer:connect_id()
				})
			end
		end
	until e == nil
end

if host then
	host:destroy()
end

Log.quit()
