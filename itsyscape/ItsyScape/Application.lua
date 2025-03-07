--------------------------------------------------------------------------------
-- ItsyScape/Application.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local buffer = require "string.buffer"
local Class = require "ItsyScape.Common.Class"
local Function = require "ItsyScape.Common.Function"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local Ray = require "ItsyScape.Common.Math.Ray"
local AlertWindow = require "ItsyScape.Editor.Common.AlertWindow"
local PlayerStorage = require "ItsyScape.Game.PlayerStorage"
local Probe = require "ItsyScape.Game.Probe"
local GameDB = require "ItsyScape.GameDB.GameDB"
local LocalGame = require "ItsyScape.Game.LocalModel.Game"
local ClientRPCService = require "ItsyScape.Game.RPC.ClientRPCService"
local ChannelRPCService = require "ItsyScape.Game.RPC.ChannelRPCService"
local LocalGameManager = require "ItsyScape.Game.LocalModel.LocalGameManager"
local RemoteGameManager = require "ItsyScape.Game.RemoteModel.RemoteGameManager"
local Color = require "ItsyScape.Graphics.Color"
local DebugStats = require "ItsyScape.Graphics.DebugStats"
local Renderer = require "ItsyScape.Graphics.Renderer"
local Resource = require "ItsyScape.Graphics.Resource"
local ToolTip = require "ItsyScape.UI.ToolTip"
local NLuaRuntime = require "nbunny.luaruntime"

local function inspectGameDB(gameDB)
	local VISIBLE_RESOURCES = {
		"Item",
		"Peep",
		"Prop",
		"Map",
		"Spell"
	}

	for i = 1, #VISIBLE_RESOURCES do
		local resourceType = VISIBLE_RESOURCES[i]

		local count = 0
		for resource in gameDB:getResources(resourceType) do
			local name = gameDB:getRecord("ResourceName", {
				Resource = resource
			})

			if not name then
				Log.warn("Resource '%s' (%s) doesn't have name.", resource.name, resourceType)
			end

			local description = gameDB:getRecord("ResourceDescription", {
				Resource = resource
			})

			if not description then
				Log.warn("Resource '%s' (%s) doesn't have description.", resource.name, resourceType)
			end

			if resourceType == "Item" and not love.filesystem.getInfo(string.format("Resources/Game/Items/%s/Icon.png", resource.name)) then
				Log.warn("Resource '%s' (%s) doesn't have item icon.", resource.name, resourceType)
			end

			count = count + 1
		end

		Log.info("There are %d '%s' resources.", count, resourceType)
	end

	for resource in gameDB:getResources("Peep") do
		local dummy = gameDB:getRecord("Dummy", {
			Resource = resource
		})

		if dummy ~= nil then
			Log.warn("Peep '%s' is a dummy! Fix before release.", resource.name)
		end
	end
end

local Application = Class()
Application.CLICK_NONE = 0
Application.CLICK_ACTION = 1
Application.CLICK_WALK = 2
Application.CLICK_DURATION = 0.25
Application.CLICK_RADIUS = 32
Application.DEBUG_DRAW_THRESHOLD = 160
Application.DEBUG_MEMORY_POLLS_SECONDS = 5
Application.MAX_TICKS = 100
Application.MAX_DRAW_CALLS = 120

Application.SINGLE_PLAYER_TICKS_PER_SECOND = 30
Application.MULTIPLAYER_PLAYER_TICKS_PER_SECOND = 10

Application.PLAY_MODE_SINGLE_PLAYER      = 0
Application.PLAY_MODE_MULTIPLAYER_HOST   = 1
Application.PLAY_MODE_MULTIPLAYER_CLIENT = 2

function Application:new(multiThreaded)
	self.previousTickTime = love.timer.getTime()
	self.startDrawTime = false
	self.time = 0

	self.frames = 0
	self.frameTime = 0

	do
		local e
		self.gameDB, e = GameDB.create()

		if #e >= 1 then
			for i = 1, #e do
				Log.warn(e[i])
			end

			error("Encountered errors creating GameDB!")

			love.event.quit()
		end
	end

	self.multiThreaded = multiThreaded or false

	self.inputAdminChannel = love.thread.newChannel()
	self.outputAdminChannel = love.thread.newChannel()
	self.inputChannel = love.thread.getChannel('ItsyScape.Game::input')
	self.outputChannel = love.thread.getChannel('ItsyScape.Game::output')

	if not self.multiThreaded then
		self.localGame = LocalGame(self.gameDB)
	else
		self.rpcService = ChannelRPCService(self.outputChannel, self.inputChannel)
		self.remoteGameManager = RemoteGameManager(self.rpcService, self.gameDB)

		local vendor, device
		if love.graphics then
			vendor, device = select(3, love.graphics.getRendererInfo())
		end

		self.gameThread = love.thread.newThread("ItsyScape/Game/LocalModel/Threads/Game.lua")
		self.gameThread:start({
			_DEBUG = _DEBUG,
			_CONF = _CONF,
			brand = vendor or "???",
			model = string.format("%s / %s", jit and jit.arch or "???", device or "???")
		}, self.inputAdminChannel, self.outputAdminChannel)

		self.remoteGameManager.onTick:register((_CONF.server and self.tickServer) or self.preTickMultiThread, self)
		self.remoteGameManager.onFlush:register((_CONF.server and self.tickServer) or self.postTickMultiThread, self)
		self.game = self.remoteGameManager:getInstance("ItsyScape.Game.Model.Game", 0):getInstance()
	end

	self:getGame().onLeave:register(self.quitGame, self)

	self.times = {}
	self.ticks = {}
	self.drawCalls = {}
	self.nbunnyCalls = {}

	if _CONF.server then
		Log.info("Server only.")
		self:host(_CONF.lastInputPort or '18323', _CONF.lastPassword or "")
	else
		local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
		local GameView = require "ItsyScape.Graphics.GameView"
		local UIView = require "ItsyScape.UI.UIView"

		self.camera = ThirdPersonCamera()
		do
			self.camera:setDistance(30)
			self.camera:setUp(Vector(0, -1, 0))
			self.camera:setHorizontalRotation(-math.pi / 8)
			self.camera:setVerticalRotation(-math.pi / 2)
		end

		self.gameView = GameView(self:getGame(), self.camera)
		self.gameView:attach()
		self.uiView = UIView(self.gameView)

		self.gameView:getRenderer():setCamera(self.camera)

		self.defaultFont = love.graphics.getFont()
	end

	self.showDebug = false
	self.showUI = true
	self.show2D = true
	self.show3D = true

	self.clickActionTime = 0
	self.clickActionType = Application.CLICK_NONE

	if _DEBUG then
		inspectGameDB(self.gameDB)
	end

	self.paused = false

	self.playMode = Application.PLAY_MODE_SINGLE_PLAYER
	self.isQuitting = flase

	self.pendingProbes = {}

	self.showDebug = _CONF.showDebug
end

local memoryLabel
function Application:updateMemoryLabel(label)
	if memoryLabel ~= label then
		memoryLabel = label

		self:dumpMemoryStats()
	end
end

function Application:dumpMemoryStats()
	local currentTime = love.timer.getTime()
	local stats = self:getMemoryStats()

	if not stats then
		return
	end

	local data = string.format(
		"%f, %.02f, %.02f, %.02f, %0.2f, %0.2f, %0.2f, %0.2f, %0.2f, %d, %s\n",
		currentTime - self.previousMemoryUsage.start,
		stats.min, stats.max, stats.average, stats.median,
		stats.minDifference, stats.maxDifference, stats.averageDifference, stats.medianDifference,
		love.timer.getFPS(),
		stats.label)
	love.filesystem.append("memory.csv", data)

	Log.info(
		"After %.2f seconds (label = '%s'), min memory = %.2f MB, max memory = %.2f MB, average memory = %.2f MB, median memory = %.2f MB, " ..
		"min diff = %.2f MB, max diff = %.2f MB, average diff = %.2f MB, median diff = %.2f MB, FPS = %d",
		currentTime - self.previousMemoryUsage.start,
		stats.label,
		stats.min, stats.max, stats.average, stats.median,
		stats.minDifference, stats.maxDifference, stats.averageDifference, stats.medianDifference,
		love.timer.getFPS())

	self.previousMemoryUsage.time = currentTime
end

function Application:updateMemoryUsage()
	if not self.previousMemoryUsage then
		love.filesystem.write("memory.csv", "Time, Min, Max, Avg, Mdn, Dif Min, Dif Max, Dif Avg, Dif Mdn, FPS, Label\n")
	end

	local currentTime = love.timer.getTime()
	local previousMemoryUsage = self.previousMemoryUsage or { time = currentTime, start = currentTime }

	while previousMemoryUsage[1] and
	      previousMemoryUsage[1].time + Application.DEBUG_MEMORY_POLLS_SECONDS < currentTime
	do
		table.remove(previousMemoryUsage, 1)
	end

	local currentMemoryUsage = collectgarbage("count") / 1024
	table.insert(previousMemoryUsage, {
		time = currentTime,
		memory = currentMemoryUsage
	})

	if _DEBUG and previousMemoryUsage.time + Application.DEBUG_MEMORY_POLLS_SECONDS < currentTime then
		self:dumpMemoryStats()

		for _, func in ipairs(self.times) do
			func.max = 0
		end
	end

	self.previousMemoryUsage = previousMemoryUsage
end

function Application:getMemoryStats()
	if not self.previousMemoryUsage or #self.previousMemoryUsage == 0 then
		return nil
	end

	local min, max = math.huge, -math.huge
	local average = 0
	local median = {}
	for _, usage in ipairs(self.previousMemoryUsage) do
		min = math.min(min, usage.memory)
		max = math.max(max, usage.memory)
		average = average + usage.memory
		table.insert(median, usage.memory)
	end

	table.sort(median)
	do
		if #median % 2 == 0 then
			median = median[#median / 2]
		else
			local a = median[math.floor(#median / 2)]
			local b = median[math.floor(#median / 2) + 1]
			median = a and b and (a + b) / 2
		end

		median = median or 0
	end

	average = average / #self.previousMemoryUsage

	local stats = { min = min, max = max, average = average, median = median, label = memoryLabel }
	local previousStats = self.previousStats or stats
	self.previousStats = stats

	stats.minDifference = stats.min - previousStats.min
	stats.maxDifference = stats.max - previousStats.max
	stats.averageDifference = stats.average - previousStats.average
	stats.medianDifference = stats.median - previousStats.median

	return stats
end

function Application:measure(name, func, ...)
	if not _DEBUG then
		func(...)
		return
	end

	local beforeMemory = 0
	if _DEBUG == 'plus' then
		collectgarbage("stop")
		beforeMemory = collectgarbage("count")
	end

	local before = love.timer.getTime()
	DebugStats.GLOBAL:measure(name, func, ...)
	local after = love.timer.getTime()

	local afterMemory = 0
	if _DEBUG == 'plus' then
		afterMemory = collectgarbage("count")
		collectgarbage("restart")
	end

	local memory = afterMemory - beforeMemory

	local index
	if not self.times[name] then
		index = #self.times + 1
		self.times[name] = index
	else
		index = self.times[name]
		memory = memory < 1 and math.max(self.times[index].memory, memory) or memory
	end

	if self.times[index] then
		self.times[index].max = math.max(self.times[index].max, after - before)
		self.times[index].value = after - before
		self.times[index].memory = memory
		self.times[index].name = name
		table.insert(self.times[index].samples, { value = after - before, time = after })
	else
		self.times[index] = { value = after - before, memory = memory, name = name, max = 0, average = 0, samples = { { value = after - before, time = after } } }
	end

	while #self.times[index].samples >= 1 and love.timer.getTime() > self.times[index].samples[1].time + 1 do
		table.remove(self.times[index].samples, 1)
	end

	local sum = 0
	for _, sample in ipairs(self.times[index].samples) do
		sum = sum + sample.value
	end

	self.times[index].average = sum / math.max(#self.times[index].samples, 1)
end

function Application:initialize()
	-- Nothing.
end

function Application:getCamera()
	return self.camera
end

function Application:getGameDB()
	return self.gameDB
end

function Application:getGame()
	return self.localGame or self.game
end

function Application:getGameManager()
	return self.remoteGameManager
end

function Application:getGameView()
	return self.gameView
end

function Application:getUIView()
	return self.uiView
end


function Application:getIsPaused()
	return self.paused
end

function Application:setIsPaused(value)
	self.paused = value or false
end

function Application:getIsMultiThreaded()
	return self.multiThreaded
end

function Application:_probe(probe, performDefault, callback)
	if performDefault then
		local numPrimaryActions = 0
		local hasWalk = false

		for _, action in probe:iterate() do
			if action.id ~= "Examine" and not action.suppress then
				if action.id ~= "Walk" then
					numPrimaryActions = numPrimaryActions + 1
				else
					hasWalk = true
				end
			end
		end

		if numPrimaryActions <= 1 or _CONF.probe == false then
			for _, action in probe:iterate() do
				if action.id ~= "Examine" and not action.suppress then
					if action.id == "Walk" then
						self.clickActionType = Application.CLICK_WALK
					else
						self.clickActionType = Application.CLICK_ACTION
					end

					self.clickActionTime = Application.CLICK_DURATION
					self.clickX, self.clickY = itsyrealm.mouse.getPosition()

					local s, r = pcall(action.callback)
					if not s then
						Log.warn("couldn't perform action: %s", r)
					end

					return
				end
			end
		end

		if numPrimaryActions <= 1 and not hasWalk then
			return
		end
	end

	if callback then
		callback(probe)
	end

	table.insert(self.pendingProbes, probe)
end

function Application:probe(x, y, performDefault, callback, tests, radius, layer)
	if self.paused then
		return
	end

	local ray = self:shoot(x, y)
	local probe = table.remove(self.pendingProbes) or Probe(self:getGame(), self.gameView, self.gameDB)
	probe:init(ray, tests, radius, layer)
	probe:all(Function(self._probe, self, probe, performDefault, callback))
end

function Application:shoot(x, y)
	love.graphics.push('all')

	local width, height = love.window.getMode()
	y = height - y

	love.graphics.origin()
	self.camera:apply()

	local a = Vector(love.graphics.unproject(x, y, 0.0))
	local b = Vector(love.graphics.unproject(x, y, 0.1))
	local r = Ray(a, b - a)

	love.graphics.pop()

	return r
end

function Application:processAdminEvents()
	local event
	repeat 
		event = self.outputAdminChannel:pop()

		if type(event) == "table" and event.type == "analytics" then
			_ANALYTICS_ENABLED = event.enable
		elseif type(event) == "table" and event.type == "quit" then
			self:quit(false)
			love.event.quit()
		elseif type(event) == "table" and event.type == "memory" then
			self.serverMemory = event.memory or 0
		end
	until not event
end

function Application:update(delta)
	Resource.update()

	-- Accumulator. Stores time until next tick.
	self.time = self.time + delta

	-- Only update at the specified intervals.
	if not self.multiThreaded then
		while self.time > self.localGame:getTargetDelta() do
			self:tickSingleThread()

			-- Handle cases where 'delta' exceeds TICK_RATE
			self.time = self.time - self.localGame:getTargetDelta()

			-- Store the previous frame time.
			self.previousTickTime = love.timer.getTime()
		end

		self:measure('game:update()', function() self.localGame:update(delta) end)
	else
		self:processAdminEvents()

		self:measure('remoteGameManager:receive()', function() self.remoteGameManager:receive() end)
	end

	if not _CONF.server then
		if self.show3D then
			self:measure('gameView:update()', function() self.gameView:update(delta) end)
		end

		if self.showUI then
			self:measure('uiView:update()', function() self.uiView:update(delta) end)
		end
	end

	self.clickActionTime = self.clickActionTime - delta

	self:updateMemoryUsage()

	if _DEBUG ~= "plus" then
		local step = (_CONF.clientGCStepMS or 1) / 1000

		local startTime = love.timer.getTime()
		while love.timer.getTime() < startTime + step do
			collectgarbage("step", 50)
		end
	end
end

function Application:doCommonTick()
	table.insert(self.ticks, 1, {
		client = love.timer.getTime() - self.previousTickTime,
		server = self:getGame():getDelta(),
	})
	while #self.ticks > self.MAX_TICKS do
		table.remove(self.ticks)
	end

	local average
	self.maxClientTick = 0
	self.maxServerTick = 0
	do
		local sum = 0
		for i = 1, #self.ticks do
			self.maxClientTick = math.max(self.maxClientTick, self.ticks[i].client)
			self.maxServerTick = math.max(self.maxServerTick, self.ticks[i].server)
			sum = sum + self.ticks[i].client
		end
		average = sum / math.max(#self.ticks, 1)

	end

	self.averageTick = average
end

function Application:getTargetTickDelta()
	return 1 / 10
end

function Application:getAverageTickDelta()
	return self.averageTick or self:getGame():getDelta() or 0
end

function Application:getMaxClientTickDelta()
	return self.maxClientTick or self:getGame():getDelta() or 0
end

function Application:getMaxServerTickDelta()
	return self.maxServerTick or self:getGame():getDelta() or 0
end

function Application:tickSingleThread()
	self:doCommonTick()

	self:measure('gameView:preTick()', function() self.gameView:preTick(self:getPreviousFrameDelta()) end)
	self:measure('uiView:tick()', function() self.uiView:tick() end)
	self:measure('game:tick()', function() self.localGame:tick() end)
	self:measure('gameView:postTick()', function() self.gameView:postTick(self:getPreviousFrameDelta()) end)
end

function Application:preTickMultiThread()
	self:doCommonTick()

	if self.show3D then
		self:measure('gameView:preTick()', function() self.gameView:preTick(self:getPreviousFrameDelta()) end)
	end

	self:measure('uiView:tick()', function() self.uiView:tick() end)

	self.remoteGameManager:pushTick()
	self.previousTickTime = love.timer.getTime()

	self.inputAdminChannel:push({
		type = 'tick'
	})
end

function Application:postTickMultiThread()
	self:measure('gameView:postTick()', function() self.gameView:postTick(self:getPreviousFrameDelta()) end)
end

function Application:tickServer()
	self:doCommonTick()
end

function Application:swapRPCService(RPCServiceType, ...)
	if self.rpcService then
		Log.info("Existing RPC service (%s), shutting down...", self.rpcService:getDebugInfo().shortName)

		self.rpcService:close()

		Log.info("Shut down existing RPC service.")
	end

	self.rpcService = RPCServiceType(...)
	self.remoteGameManager:swapRPCService(self.rpcService)

	if Class.isCompatibleType(self.rpcService, ClientRPCService) then
		self.rpcService.onDisconnect:register(function()
			Log.info("Disconnected from server! Oh no!")

			self.gameView:reset()
			self.uiView:reset()

			self:disconnect()
		end)
	end
end

function Application:host(port, password)
	Log.info("Hosting on port %d.", port)

	if self:getPlayMode() == Application.PLAY_MODE_MULTIPLAYER_CLIENT then
		self:disconnect()
	end

	self.inputAdminChannel:push({
		type = 'host',
		address = "*",
		port = tostring(port),
		password = password
	})

	self.inputAdminChannel:push({
		type = 'conf',
		ticks = self.MULTIPLAYER_PLAYER_TICKS_PER_SECOND
	})

	self:setPassword(password)
	self:swapRPCService(ClientRPCService, "localhost", tostring(port))

	self.playMode = Application.PLAY_MODE_MULTIPLAYER_HOST
end

function Application:play(player)
	if not player then
		Log.info("No player; cannot assign player as primary.")
		return
	end

	if self:getPlayMode() == Application.PLAY_MODE_SINGLE_PLAYER then
		Log.info("Playing as player %d; assigning as primary", player:getID())
		self.inputAdminChannel:push({
			type = 'play',
			playerID = player:getID()
		})
	else
		Log.warn("Is a multiplayer session, cannot make player %d primary.", player:getID())
	end
end

function Application:disconnect()
	Log.info("Switching to single player.")

	local oldPlayMode = self:getPlayMode()
	self.playMode = Application.PLAY_MODE_SINGLE_PLAYER

	if oldPlayMode == Application.PLAY_MODE_MULTIPLAYER_HOST then
		self:swapRPCService(ChannelRPCService, self.outputChannel, self.inputChannel)

		Log.info("Switching from multiplayer (host).")
		self.inputAdminChannel:push({
			type = 'disconnect'
		})
	elseif oldPlayMode == Application.PLAY_MODE_MULTIPLAYER_CLIENT then
		self:swapRPCService(ChannelRPCService, self.outputChannel, self.inputChannel)

		Log.info("Switching from multiplayer (client).")
		self.inputAdminChannel:push({
			type = 'offline'
		})
	elseif oldPlayMode == Application.PLAY_MODE_SINGLE_PLAYER then
		Log.info("Staying on single player.")

		self.inputAdminChannel:push({
			type = 'play'
		})

		self.inputAdminChannel:push({
			type = 'conf',
			ticks = self.SINGLE_PLAYER_TICKS_PER_SECOND
		})
	end
end

function Application:setAdmin(playerID)
	Log.info("Setting admin to player %d.", playerID)

	self.inputAdminChannel:push({
		type = 'admin',
		admin = playerID
	})
end

function Application:setConf(t)
	Log.info("Updating conf: %s", Log.stringify(t))

	self.inputAdminChannel:push({
		type = 'conf',
		environment = t
	})
end

function Application:connect(address, port, password)
	Log.info("Connecting to %s:%d.", address, port)

	self:setPassword(password)
	self:swapRPCService(ClientRPCService, address, tostring(port))

	self.rpcService.onError:register(self.onNetworkError, self)

	_CONF.lastInputAddress = address
	_CONF.lastInputPort = tostring(port)
	_CONF.lastPassword = password

	self.tickTripTime = 0
	self.tickTripTotal = 0

	self.playMode = Application.PLAY_MODE_MULTIPLAYER_CLIENT

	self.inputAdminChannel:push({
		type = 'connect'
	})
end

function Application:getPlayMode()
	return self.playMode
end

function Application:setPassword(password)
	self.password = value
end

function Application:getPassword()
	return self.password
end

function Application:onNetworkError(_, message)
	Log.info("Could not connect (%s); switching to single player.", message)
	self:disconnect()
end

function Application:isGameThread(thread)
	return self.gameThread and thread and self.gameThread == thread
end

function Application:requestSave()
	self.inputAdminChannel:push({ type = 'save' })
end

function Application:savePlayer(player, storage, isError)
	-- Nothing.
end

function Application:background()
	if self.multiThreaded and self.gameThread then
		self.inputAdminChannel:push({
			type = 'background'
		})

		local event = self.outputAdminChannel:demand(1)
		if event and event.type == 'save' then
			local serializedStorage = buffer.decode(event.storage)
			if next(serializedStorage) then
				local storage = PlayerStorage()
				storage:deserialize(serializedStorage)

				self:savePlayer(self:getGame():getPlayer(), storage, false)
			end
		end
	end
end

function Application:dismissQuit()
	self.isQuitting = false
end

function Application:getIsQuitting()
	return self.isQuitting
end

function Application:tryQuit()
	if self.isQuitting then
		return false
	end

	self.isQuitting = true
	self.inputAdminChannel:push({
		type = "tryQuit"
	})

	return true
end

function Application:quit(isError)
	if self.multiThreaded then
		Resource.quit()

		self:getGame():quit()
		self.remoteGameManager:pushTick()
		self.gameView:quit()

		if self.rpcService then
			self.rpcService:close()
		end

		if self.gameThread then
			self.inputAdminChannel:push({
				type = 'quit'
			})
			self.gameThread:wait()

			local e = self.gameThread:getError()
			if e then
				Log.warn("Error quitting logic thread: %s", e)
			else
				Log.info("Trying to save player...")

				local event
				repeat
					event = self.outputAdminChannel:demand(1)
				until not event or (type(event) == "table" and event.type == 'save')

				if event and event.type == "save" then
					local serializedStorage = buffer.decode(event.storage)
					if next(serializedStorage) then
						local storage = PlayerStorage()
						storage:deserialize(serializedStorage)

						self:savePlayer(self:getGame():getPlayer(), storage, isError)
					end
				else
					Log.warn("Didn't receive save command from logic thread before timeout.")
				end
			end
		end

		if _DEBUG then
			self.remoteGameManager:getDebugStats():dumpStatsToCSV("RemoteGameManager")
		end
	end

	return false
end

function Application:quitGame(game)
	-- Nothing.
end

function Application:mousePress(x, y, button)
	local isBlocking, widget = self.uiView:getInputProvider():isBlocking(x, y)
	if isBlocking then
		self.uiView:getInputProvider():mousePress(x, y, button)

		if not self.uiView:isPokeMenu(widget) then
			self.uiView:closePokeMenu()
		end

		return true
	end

	self.uiView:closePokeMenu()

	return false
end

function Application:mouseRelease(x, y, button)
	local isBlocking = self.uiView:getInputProvider():isBlocking(x, y)
	self.uiView:getInputProvider():mouseRelease(x, y, button)

	return isBlocking
end

function Application:mouseScroll(x, y)
	if self.uiView:getInputProvider():isBlocking(itsyrealm.mouse.getPosition()) then
		self.uiView:getInputProvider():mouseScroll(x, y)
		return true
	end

	return false
end

function Application:mouseMove(x, y, dx, dy)
	self.uiView:getInputProvider():mouseMove(x, y, dx, dy)

	return false
end

function Application:getMousePosition()
	return love.mouse.getPosition()
end

function Application:joystickAdd(...)
	self.uiView:getInputProvider():joystickAdd(...)
end

function Application:joystickRemove(...)
	self.uiView:getInputProvider():joystickRemove(...)
end

function Application:gamepadRelease(...)
	self.uiView:getInputProvider():gamepadRelease(...)
end

function Application:gamepadPress(...)
	self.uiView:getInputProvider():gamepadPress(...)
end

function Application:gamepadAxis(...)
	self.uiView:getInputProvider():gamepadAxis(...)
end

function Application:touchPress(...)
	-- Nothing.
end

function Application:touchRelease(...)
	-- Nothing.
end

function Application:touchMove(...)
	-- Nothing.
end

function Application:keyDown(key, ...)
	self.uiView:getInputProvider():keyDown(key, ...)

	if key == "f1" then
		if not (love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift')) then
			self.showDebug = not self.showDebug
			_CONF.showDebug = self.showDebug
		end
	end

	return false
end

function Application:keyUp(...)
	self.uiView:getInputProvider():keyUp(...)
	return false
end

function Application:type(...)
	self.uiView:getInputProvider():type(...)
	return false
end

function Application:getFrameDelta()
	local currentTime = love.timer.getTime()
	local previousTime = self.previousTickTime

	-- Generate a delta (0 .. 1 inclusive) between the current and previous
	-- frames
	return math.min(math.max((currentTime - previousTime) / self:getTargetTickDelta(), 0), 1)
end

function Application:getPreviousFrameDelta()
	return self.previousFrameDelta or self:getFrameDelta()
end

function Application:drawFPS()
	if not self.showDebug then
		return
	end

	love.graphics.setFont(self.defaultFont)

	local drawCalls = love.graphics.getStats().drawcalls
	local textureMemory = love.graphics.getStats().texturememory

	local r = _ITSYREALM_VERSION and string.format("ItsyRealm %s\n", _ITSYREALM_VERSION)
	r = (r or "") .. string.format("FPS: %03d/%.02f ms] (%04d draws, >%04d MB)\n",
		love.timer.getFPS(),
		1 / love.timer.getFPS() * 1000,
		drawCalls,
		collectgarbage("count") / 1024 + textureMemory / 1024 / 1024 + (self.serverMemory or 0) / 1024)
	r = r .. string.format(
		"average tick = %.04f ms\nmax (client) tick = %0.4f ms\nmax (server) tick = %0.4f ms\ntarget tick = %.04f ms\nlast tick = %.04f ms\n",
		self:getAverageTickDelta() * 1000,
		self:getMaxClientTickDelta() * 1000,
		self:getMaxServerTickDelta() * 1000,
		self:getGame():getTargetDelta() * 1000,
		self:getGame():getDelta() * 1000)

	local width = love.window.getMode()
	local w, lines = love.graphics.getFont():getWrap(r, width)

	love.graphics.setColor(0, 0, 0, 0.25)
	love.graphics.rectangle(
		"fill",
		width - w,
		0,
		w,
		#lines * love.graphics.getFont():getHeight())

	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.printf(
		r,
		2,
		2,
		width,
		'right')

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(
		r,
		0,
		0,
		width,
		'right')
end

local MEASURE_ROOT_FUNCS = {
	"gameView:update()",
	"uiView:update()",
	"remoteGameManager:receive()",
	"draw",
	"love.graphics.present()"
}

function Application:drawDebug()
	if not _DEBUG or (not self.showDebug and not _MOBILE) then
		self:drawFPS()
		return
	end

	love.graphics.setFont(self.defaultFont)

	local drawCalls = love.graphics.getStats().drawcalls
	local textureMemory = love.graphics.getStats().texturememory
	table.insert(self.drawCalls, drawCalls)
	while #self.drawCalls > self.MAX_DRAW_CALLS do
		table.remove(self.drawCalls, 1)
	end
	local maxDrawCalls = math.max(unpack(self.drawCalls))

	local _, nbunnyTime = NLuaRuntime.getMeasurements()

	local numNbunnyCalls = NLuaRuntime.getNumCalls()
	table.insert(self.nbunnyCalls, numNbunnyCalls)
	while #self.nbunnyCalls > self.MAX_DRAW_CALLS do
		table.remove(self.nbunnyCalls, 1)
	end
	numNbunnyCalls = math.max(unpack(self.nbunnyCalls))

	local width = love.window.getMode()
	local r = _ITSYREALM_VERSION and string.format("ItsyRealm %s\n", _ITSYREALM_VERSION)
	r = (r or "") .. string.format("FPS: %03d/%.02f ms (%03d draws, %03d draws max, %04d nbunny calls (%02.02f ms), >%04d MB)\n", love.timer.getFPS(), 1 / love.timer.getFPS() * 1000, drawCalls, maxDrawCalls, numNbunnyCalls, nbunnyTime * 1000, collectgarbage("count") / 1024 + textureMemory / 1024 / 1024 + (self.serverMemory or 0) / 1024)
	local sum = 0
	for i = 1, #self.times do
		r = r .. string.format(
			"%s: %.04f ms (%.04f max, %0.4f avg), %05d KB (%03d)\n",
			self.times[i].name,
			self.times[i].value * 1000,
			(self.times[i].max or self.times[i].value) * 1000,
			self.times[i].average * 1000,
			self.times[i].memory,
			#self.times[i].samples)

		for _, func in ipairs(MEASURE_ROOT_FUNCS) do
			if func == self.times[i].name then
				sum = sum + self.times[i].average
				break
			end
		end
	end
	if 1 / sum < 60 then
		r = r .. string.format(
				"!!! sum: %3.04f ms (%010d)\n",
				sum * 1000,
				1 / sum)
	else
		r = r .. string.format(
				"sum: %3.04f ms (%010d)\n",
				sum * 1000,
				1 / sum)
	end

	r = r .. string.format(
			"average tick = %.04f ms\nmax (client) tick = %0.4f ms\nmax (server) tick = %0.4f ms\ntarget tick = %.04f ms\nlast tick = %.04f ms\n",
			self:getAverageTickDelta() * 1000,
			self:getMaxClientTickDelta() * 1000,
			self:getMaxServerTickDelta() * 1000,
			self:getGame():getTargetDelta() * 1000,
			self:getGame():getDelta() * 1000)

	if not _MOBILE then
		local w, lines = love.graphics.getFont():getWrap(r, width)

		love.graphics.setColor(0, 0, 0, 0.25)
		love.graphics.rectangle(
			"fill",
			width - w,
			0,
			w,
			#lines * love.graphics.getFont():getHeight())
	end

	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.printf(
		r,
		2,
		2,
		width,
		'right')

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(
		r,
		0,
		0,
		width,
		'right')
end

function Application:_draw()
	if _CONF.server then
		return
	end

	local width, height = love.window.getMode()
	self.camera:setWidth(width)
	self.camera:setHeight(height)

	local delta = self:getFrameDelta()
	do
		if self.show3D and (not self.uiView:getIsFullscreen() or _MOBILE) then
			self:measure("3d renderer", self.gameView.draw, self.gameView, delta)
		end

		if self.show2D then
			self.gameView:getSpriteManager():draw(self.gameView:getScene(), self.camera, delta)
		end
	end

	love.graphics.setBlendMode('alpha')
	love.graphics.origin()
	love.graphics.ortho(width, height)

	if self.showUI then
		self:measure("ui renderer", self.uiView.draw, self.uiView)
	end

	if self.clickActionTime > 0 and not (_DEBUG and (love.keyboard.isDown("rshift") or love.keyboard.isDown("lshift"))) then
		local color
		if self.clickActionType == Application.CLICK_WALK then
			color = Color(1, 1, 0, 0.25)
		else
			color = Color(1, 0, 0, 0.25)
		end

		local mu = Tween.powerEaseInOut(
			self.clickActionTime / Application.CLICK_DURATION,
			3)
		local oldColor = { love.graphics.getColor() }
		love.graphics.setColor(color:get())
		love.graphics.circle(
			'fill',
			self.clickX, self.clickY,
			mu * Application.CLICK_RADIUS)
		love.graphics.setColor(unpack(oldColor))
	end

	self.previousFrameDelta = self:getFrameDelta()
end

local function draw()
	_APP:_draw()
end

function Application:draw()
	local s, r = xpcall(self.measure, debug.traceback, self, 'draw', draw)
	if not s then
		love.graphics.setBlendMode('alpha')
		love.graphics.origin()
		love.graphics.ortho(love.window.getMode())

		error(r, 0)
	end

	self:drawDebug()

	self.frames = self.frames + 1
	local currentTime = love.timer.getTime()
	if currentTime > self.frameTime + 1 then
		self.fps = math.floor(self.frames / (currentTime - self.frameTime))
		self.frames = 0
		self.frameTime = currentTime
	end
end

return Application
