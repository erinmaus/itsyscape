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
local AnalyticsClient = require "ItsyScape.Analytics.AnalyticsClient"
local LocalGame = require "ItsyScape.Game.LocalModel.Game"
local Utility = require "ItsyScape.Game.Utility"
local LocalGameManager = require "ItsyScape.Game.LocalModel.LocalGameManager"
local ChannelRPCService = require "ItsyScape.Game.RPC.ChannelRPCService"
local ServerRPCService = require "ItsyScape.Game.RPC.ServerRPCService"

local game = LocalGame(GameDB.create())
Analytics = AnalyticsClient(game, conf)

local inputChannel = love.thread.getChannel('ItsyScape.Game::input')
local outputChannel = love.thread.getChannel('ItsyScape.Game::output')

outputAdminChannel:push({
	type = 'analytics',
	enable = Analytics:getIsEnabled()
})

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

local times = {}
local startTime = love.timer.getTime()

local function getPeriodInMS(a, b)
	return ((times[b] and times[b].time or 0) - (times[a] and times[a].time or 0)) * 1000
end

local function getMemoryInKB(a, b)
	return (times[b] and times[b].memory or 0) - (times[a] and times[a].memory or 0)
end

local function measure(name)
	times[name] = {
		time = love.timer.getTime() - startTime,
		memory = _DEBUG == "plus" and collectgarbage("count") or 0
	}
end

local function tick()
	measure("Start")
	do
		game:tick()
		measure("GameTick")
		game:update(game:getDelta())
		measure("GameUpdate")

		gameManager:update()
		measure("GameManagerUpdate")
		gameManager:pushTick()
		measure("GameManagerTick")
		gameManager:send()
		measure("GameManagerSend")

		while not gameManager:receive() do
			love.timer.sleep(0)
		end
		measure("GameManagerReceive")

		game:cleanup()

		if _DEBUG ~= "plus" then
			local step = (_CONF.serverGCStepMS or 10) / 1000

			local startTime = love.timer.getTime()
			while love.timer.getTime() < startTime + step do
				collectgarbage("step", 1)
			end
		end

		measure("GameCleanup")

		Analytics:update()
	end
	measure("End")
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

			local filename = storage and storage:getRoot():get("filename")
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
	local success, result = xpcall(tick, function(message)
		local s, r = xpcall(Log.sendError, debug.traceback, message, 3)
		if not s then
			Log.warn("Could not send error: %s", r)
		end

		return debug.traceback(message)
	end)

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

	local duration = getPeriodInMS("Start", "End") / 1000
	if duration < game:getTargetDelta() then
		local sleepDuration = game:getTargetDelta() - duration

		local beforeSleep = love.timer.getTime()
		love.timer.sleep(sleepDuration)
		local afterSleep = love.timer.getTime()

		if _DEBUG then
			Log.engine("Slept for %0.2f ms, target was %0.2f.", sleepDuration * 1000, (afterSleep - beforeSleep) * 1000)
		end
	end

	if duration > game:getTargetDelta() or _DEBUG then
		Log.engine("Tick was %0.2f ms (expected %0.2f or less).", duration * 1000, game:getTargetDelta() * 1000)
		Log.engine(
			"Timing stats @ %.2f ms: iteration = %.2f ms, game tick = %.2f ms, game update = %.2f ms, game manager update = %.2f ms, game manager tick = %.2f ms, game manager send = %.2f ms, game manager receive = %.2f ms, cleanup = %.2f ms",
			getPeriodInMS(nil, "Start"),
			getPeriodInMS("Start", "End"),
			getPeriodInMS("Start", "GameTick"),
			getPeriodInMS("GameTick", "GameUpdate"),
			getPeriodInMS("GameUpdate", "GameManagerUpdate"),
			getPeriodInMS("GameManagerUpdate", "GameManagerTick"),
			getPeriodInMS("GameManagerTick", "GameManagerSend"),
			getPeriodInMS("GameManagerSend", "GameManagerReceive"),
			getPeriodInMS("GameManagerReceive", "End"))

		if _DEBUG == "plus" then
			Log.engine(
				"Memory stats @ %.2f ms: iteration = %.2f kb, game tick = %.2f kb, game update = %.2f kb, game manager update = %.2f kb, game manager tick = %.2f kb, game manager send = %.2f kb, game manager receive = %.2f kb, cleanup = %.2f kb",
				getPeriodInMS(nil, "Start"),
				getMemoryInKB("Start", "End"),
				getMemoryInKB("Start", "GameTick"),
				getMemoryInKB("GameTick", "GameUpdate"),
				getMemoryInKB("GameUpdate", "GameManagerUpdate"),
				getMemoryInKB("GameManagerUpdate", "GameManagerTick"),
				getMemoryInKB("GameManagerTick", "GameManagerSend"),
				getMemoryInKB("GameManagerSend", "GameManagerReceive"),
				getMemoryInKB("GameManagerReceive", "End"))
		end
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

				game:quit()

				outputAdminChannel:push({
					type = 'save',
					storage = buffer.encode(storage and storage:serialize() or {})
				})
			elseif e.type == 'tryQuit' then
				for _, player in game:iteratePlayers() do
					if player:getID() == adminPlayerID then
						if Utility.UI.isOpen(player:getActor():getPeep(), "ConfigWindow") then
							outputAdminChannel:push({
								type = 'quit'
							})
						else
							Utility.UI.openInterface(
								player:getActor():getPeep(),
								"ConfigWindow",
								false)
						end

						break
					end
				end
			elseif e.type == 'background' then
				local storage
				for _, player in game:iteratePlayers() do
					if player:getID() == adminPlayerID then
						player:save()
						storage = game:getDirector():getPlayerStorage(player:getID())
					end
				end

				if storage then
					outputAdminChannel:push({
						type = 'save',
						storage = buffer.encode(storage and storage:serialize() or {})
					})
				end
			elseif e.type == 'admin' then
				adminPlayerID = e.admin
				gameManager:setAdmin(adminPlayerID)
			elseif e.type == 'conf' then
				if e.environment ~= nil then
					_DEBUG = e.environment._DEBUG or false
					_CONF = e.environment._CONF or _CONF
				end

				if e.ticks ~= nil then
					Log.info("Set game tick speed to %d ticks per second.", e.ticks)

					game:setTicks(e.ticks)
				end
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
			elseif e.type == 'analytics' then
				if e.enable then
					Analytics:enable(conf)
				else
					Analytics:disable()
				end

				outputAdminChannel:push({
					type = 'analytics',
					enable = e.enable
				})
			elseif e.type == 'save' then
				for _, player in game:iteratePlayers() do
					if player:getActor() and player:getActor():getPeep() and player:getActor():getPeep():getIsReady() then
						player:save()
					end
				end
			end
		end
	until not e
end

if serverRPCService then
	serverRPCService:close()
end

if _DEBUG then
	gameManager:getDebugStats():dumpStatsToCSV("LocalGameManager")
end

Analytics:quit()

Log.info("Game thread exiting...")
Log.quit()
