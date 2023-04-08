--------------------------------------------------------------------------------
-- ItsyScape/Game/LocalModel/Threads/Map.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

_LOG_SUFFIX = "server"
require "bootstrap"

local conf, inputAdminChannel, outputAdminChannel = ...
_DEBUG = conf._DEBUG
_CONF = conf._CONF

local buffer = require "string.buffer"
local GameDB = require "ItsyScape.GameDB.GameDB"
local LocalGame = require "ItsyScape.Game.LocalModel.Game"
local LocalGameManager = require "ItsyScape.Game.LocalModel.LocalGameManager"
local ChannelRPCService = require "ItsyScape.Game.RPC.ChannelRPCService"
local ServerRPCService = require "ItsyScape.Game.RPC.ServerRPCService"

local game = LocalGame(GameDB.create())

local inputChannel = love.thread.getChannel('ItsyScape.Game::input')
local outputChannel = love.thread.getChannel('ItsyScape.Game::output')

local serverRPCService, adminPlayerID
local channelRpcService = ChannelRPCService(inputChannel, outputChannel)

local gameManager = LocalGameManager(channelRpcService, game)

local isRunning = true
local isOnline = false

game.onQuit:register(function()
	if not isOnline then
		isRunning = false
	end
end)

local function getPeriodInMS(a, b)
	return math.floor(((b or love.timer.getTime()) - (a or love.timer.getTime())) * 1000)
end

local timeStart
local timeGameTick, timeGameUpdate
local timeGameManagerUpdate, timeGameManagerTick, timeGameManagerSend
local timeEnd

local function tick()
	timeStart = love.timer.getTime()
	do
		game:tick()
		timeGameTick = love.timer.getTime()
		game:update(game:getDelta())
		timeGameUpdate = love.timer.getTime()

		gameManager:update()
		timeGameManagerUpdate = love.timer.getTime()
		gameManager:pushTick()
		timeGameManagerTick = love.timer.getTime()
		gameManager:send()
		timeGameManagerSend = love.timer.getTime()

		while not gameManager:receive() do
			love.timer.sleep(0)
		end

		game:cleanup()
	end
	timeEnd = love.timer.getTime()
end

local function saveOnErrorForMultiPlayer()
	Log.warn("Encountered error, trying to save...")

	local director = game:getDirector()
	director:getItemBroker():toStorage()

	gameManager:pushTick()
	gameManager:send()

	for _, player in game:iteratePlayers() do
		Log.info(
			"Trying to save player '%s' (ID = %d, client ID = %d)...",
			(player:getActor() and player:getActor():getName()),
			player:getID(), player:getClientID())

		local peep = player:getActor()
		peep = peep and peep:getPeep()

		local storage = game:getDirector():getPlayerStorage(player:getID())

		if peep then
			local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

			local stats = peep:getBehavior(StatsBehavior)
			if stats and stats.stats then
				stats.stats:save(storage:getRoot():getSection("Peep"))
			end
		end

		if player:getID() == adminPlayerID then
			Log.info("Player is admin; saving now.")

			local filename = storage and storage:getFilename()
			if filename then
				Log.info("Saving player data to '%s'...", filename)

				local result = storage:toString()
				love.filesystem.write(filename, result)
			else
				Log.info("Player does not have filename in storage; cannot save.")
			end
		else
			Log.info("Player is client; sending save RPC.")
			if storage then
				player:onSave(storage)
				player:onLeave()
			end
		end
	end

	gameManager:pushTick()
	gameManager:send()

	serverRPCService:close()

	Log.info("Done trying to saving.")
end

local function saveOnErrorForSinglePlayer(clientID)
	Log.warn("Encountered error, trying to save...")

	local director = game:getDirector()
	director:getItemBroker():toStorage()

	for _, player in game:iteratePlayers() do
		Log.info(
			"Trying to save player '%s' (ID = %d, client ID = %d)...",
			(player:getActor() and player:getActor():getName()),
			player:getID(), player:getClientID())

		local peep = player:getActor()
		peep = peep and peep:getPeep()

		local storage = director:getPlayerStorage(player:getID())

		if peep then
			local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

			local stats = peep:getBehavior(StatsBehavior)
			if stats and stats.stats then
				stats.stats:save(storage:getRoot():getSection("Peep"))
			end
		end

		local filename = storage and storage:getRoot():get("filename")

		if filename then
			Log.info("Saving player data to '%s'...", filename)

			local data, e = love.filesystem.read(filename)
			if not data then
				Log.warn("Error reading save for back up: %s.", e)
			else
				local backupFilename = filename .. "." .. os.date("%Y%m%d_%H%M%S") .. ".bak"
				local success, e = love.filesystem.write(backupFilename, data)

				if not success then
					Log.warn("Couldn't write back up save: %s.", e)
				else
					Log.info("Backed up save file to '%s'.", backupFilename)

					local result = storage:toString()
					love.filesystem.write(filename, result)

					Log.info("Saved current player data.")
				end
			end
		else
			Log.info("Player does not have filename in storage; cannot save.")
		end
	end

	Log.info("Done trying to save.")
end

while isRunning do
	local success, result = xpcall(tick, debug.traceback)
	if not success then
		local s, r 
		if serverRPCService then
			s, r = xpcall(saveOnErrorForMultiPlayer, debug.traceback)
		else
			s, r = xpcall(saveOnErrorForSinglePlayer, debug.traceback)
		end

		if not s then
			Log.warn("Couldn't save on error: %s", r)
		end

		error(result, 0)
	end

	local duration = timeEnd - timeStart
	if duration < game:getDelta() then
		love.timer.sleep(game:getTargetDelta() - duration)
	else
		Log.info("Tick ran over by %0.2f ms.", (duration - game:getDelta()) * 1000)
		Log.info(
			"Stats: iteration = %d ms, game tick = %d ms, game update = %d ms, game manager update = %d ms, game manager tick = %d ms, game manager send = %d ms, game manager receive = %d ms",
			getPeriodInMS(timeStart, timeEnd),
			getPeriodInMS(timeStart, timeGameTick),
			getPeriodInMS(timeGameTick, timeGameUpdate),
			getPeriodInMS(timeGameUpdate, timeGameManagerUpdate),
			getPeriodInMS(timeGameManagerUpdate, timeGameManagerTick),
			getPeriodInMS(timeGameManagerTick, timeGameManagerSend),
			getPeriodInMS(timeGameManagerSend, timeEnd))
	end

	local e
	repeat
		e = inputAdminChannel:pop()
		if e then
			if e.type == 'quit' then
				isRunning = false

				local storage
				for _, player in game:iteratePlayers() do
					if player:getID() == adminPlayerID then
						player:save()
						storage = game:getDirector():getPlayerStorage(player:getID())
					end
				end

				outputAdminChannel:push({
					type = 'save',
					storage = buffer.encode(storage and storage:serialize() or {})
				})
			elseif e.type == 'admin' then
				adminPlayerID = e.admin
			elseif e.type == 'conf' then
				_DEBUG = e.environment._DEBUG or false
				_CONF = e.environment._CONF or _CONF
			elseif e.type == 'connect' then
				isOnline = true

				Log.info("Clearing players because we are connecting to an external host...")

				for _, player in game:iteratePlayers() do
					player:poof()
				end
			elseif e.type == 'play' then
				if e.playerID then
					Log.info(
						"Got player ID (%d), poofing all other players.",
						e.playerID)

					local count = 0
					for _, player in game:iteratePlayers() do
						if player:getID() ~= e.playerID then
							player:poof()
							count = count + 1
						end
					end

					Log.info("Poofed %d player(s).", count)
				else
					if game:getNumPlayers() > 0 then
						Log.warn("Game has %d players when playing offline!", game:getNumPlayers())
					end

					local newPlayer = game:spawnPlayer(0)
					Log.info("Switching to single player; spawned new player %d.", newPlayer:getID())
				end
			elseif e.type == 'host' then
				isOnline = true

				Log.info("Hosting server, swapping RPC service.")

				game:setPassword(e.password)

				if serverRPCService then
					Log.info("Closing existing connection...")
					serverRPCService:close()
					Log.info("Closed existing connection.")
				else
					for _, player in game:iteratePlayers() do
						player:poof()
					end
				end

				serverRPCService = ServerRPCService(e.address, e.port)

				gameManager:swapRPCService(serverRPCService)

				adminPlayerID = nil
			elseif e.type == 'offline' then
				isOnline = false

				for _, player in game:iteratePlayers() do
					player:poof()
				end

				gameManager:swapRPCService(channelRpcService)

				game:spawnPlayer(0)
			elseif e.type == 'disconnect' then
				isOnline = false

				if serverRPCService then
					serverRPCService:close()
					serverRPCService = nil
				end

				for _, player in game:iteratePlayers() do
					player:poof()
				end

				gameManager:swapRPCService(channelRpcService)

				game:spawnPlayer(0)
			end
		end
	until not e
end

if serverRPCService then
	serverRPCService:close()
end

Log.info("Game thread exiting...")
Log.quit()
