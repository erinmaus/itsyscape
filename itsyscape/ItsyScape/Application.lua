--------------------------------------------------------------------------------
-- ItsyScape/Application.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local Ray = require "ItsyScape.Common.Math.Ray"
local AlertWindow = require "ItsyScape.Editor.Common.AlertWindow"
local Probe = require "ItsyScape.Game.Probe"
local GameDB = require "ItsyScape.GameDB.GameDB"
local LocalGame = require "ItsyScape.Game.LocalModel.Game"
local ClientRPCService = require "ItsyScape.Game.RPC.ClientRPCService"
local ChannelRPCService = require "ItsyScape.Game.RPC.ChannelRPCService"
local LocalGameManager = require "ItsyScape.Game.LocalModel.LocalGameManager"
local RemoteGameManager = require "ItsyScape.Game.RemoteModel.RemoteGameManager"
local Color = require "ItsyScape.Graphics.Color"
local Renderer = require "ItsyScape.Graphics.Renderer"
local ToolTip = require "ItsyScape.UI.ToolTip"

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

			count = count + 1
		end

		Log.info("There are %d '%s' resources.", count, resourceType)
	end
end

local Application = Class()
Application.CLICK_NONE = 0
Application.CLICK_ACTION = 1
Application.CLICK_WALK = 2
Application.CLICK_DURATION = 0.25
Application.CLICK_RADIUS = 32
Application.DEBUG_DRAW_THRESHOLD = 160
Application.MAX_TICKS = 100

function Application:new(multiThreaded)
	self.previousTickTime = love.timer.getTime()
	self.startDrawTime = false
	self.time = 0

	self.frames = 0
	self.frameTime = 0

	self.gameDB = GameDB.create()

	self.multiThreaded = multiThreaded or false

	self.adminChannel = love.thread.newChannel()
	self.inputChannel = love.thread.getChannel('ItsyScape.Game::input')
	self.outputChannel = love.thread.getChannel('ItsyScape.Game::output')

	if not self.multiThreaded then
		self.localGame = LocalGame(self.gameDB)
	else
		self.rpcService = ChannelRPCService(self.outputChannel, self.inputChannel)
		self.remoteGameManager = RemoteGameManager(self.rpcService, self.gameDB)

		self.gameThread = love.thread.newThread("ItsyScape/Game/LocalModel/Threads/Game.lua")
		self.gameThread:start({
			_DEBUG = _DEBUG
		}, self.adminChannel)

		self.remoteGameManager.onTick:register((_CONF.server and self.tickServer) or self.tickMultiThread, self)
		self.game = self.remoteGameManager:getInstance("ItsyScape.Game.Model.Game", 0):getInstance()
	end

	self:getGame().onLeave:register(self.quitGame, self)

	self.times = {}
	self.ticks = {}

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

		self.gameView = GameView(self:getGame())
		self.gameView:attach()
		self.uiView = UIView(self.gameView)

		self.gameView:getRenderer():setCamera(self.camera)

		self.defaultFont = love.graphics.getFont()
	end

	self.showDebug = true
	self.show2D = true
	self.show3D = true

	self.clickActionTime = 0
	self.clickActionType = Application.CLICK_NONE

	if _DEBUG then
		inspectGameDB(self.gameDB)
	end

	self.paused = false
end

function Application:measure(name, func, ...)
	local before = love.timer.getTime()
	func(...)
	local after = love.timer.getTime()

	local index
	if not self.times[name] then
		index = #self.times + 1
		self.times[name] = index
	else
		index = self.times[name]
	end

	self.times[index] = { value = after - before, name = name }
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

function Application:probe(x, y, performDefault, callback, tests)
	if self.paused then
		return
	end

	local ray = self:shoot(x, y)
	local probe = Probe(self:getGame(), self.gameView, self.gameDB, ray, tests)
	probe.onExamine:register(function(name, description)
		self.uiView:examine(name, description)
	end)
	probe:all(function()
		if performDefault then
			for action in probe:iterate() do
				if action.id ~= "Examine" and not action.suppress then
					if action.id == "Walk" then
						self.clickActionType = Application.CLICK_WALK
					else
						self.clickActionType = Application.CLICK_ACTION
					end

					self.clickActionTime = Application.CLICK_DURATION
					self.clickX, self.clickY = love.mouse.getPosition()

					local s, r = pcall(action.callback)
					if not s then
						Log.warn("couldn't perform action: %s", r)
					end
					break
				end
			end
		end

		if callback then
			callback(probe)
		end
	end)
end

function Application:shoot(x, y)
	local width, height = love.window.getMode()
	y = height - y

	love.graphics.origin()
	self.camera:apply()

	local a = Vector(love.graphics.unproject(x, y, 0.0))
	local b = Vector(love.graphics.unproject(x, y, 0.1))
	local r = Ray(a, b - a)

	return r
end

function Application:update(delta)
	-- Accumulator. Stores time until next tick.
	self.time = self.time + delta

	-- Only update at the specified intervals.
	if not self.multiThreaded then
		while self.time > self.localGame:getDelta() do
			self:tickSingleThread()

			-- Handle cases where 'delta' exceeds TICK_RATE
			self.time = self.time - self.localGame:getDelta()

			-- Store the previous frame time.
			self.previousTickTime = love.timer.getTime()
		end

		self:measure('game:update()', function() self.localGame:update(delta) end)
	else
		self.remoteGameManager:receive()
	end

	if not _CONF.server then
		self:measure('gameView:update()', function() self.gameView:update(delta) end)
		self:measure('uiView:update()', function() self.uiView:update(delta) end)
	end

	self.clickActionTime = self.clickActionTime - delta
end

function Application:doCommonTick()
	table.insert(self.ticks, 1, love.timer.getTime() - self.previousTickTime)
	while #self.ticks > self.MAX_TICKS do
		table.remove(self.ticks)
	end

	local average
	do
		local sum = 0
		for i = 1, #self.ticks do
			sum = sum + self.ticks[i]
		end
		average = sum / math.max(#self.ticks, 1)
	end

	self.adaptiveTick = average
end

function Application:getAdaptiveTickDelta()
	return self.adaptiveTick or self:getGame():getDelta() or 0
end

function Application:tickSingleThread()
	self:doCommonTick()

	self:measure('gameView:tick()', function() self.gameView:tick() end)
	self:measure('game:tick()', function() self.localGame:tick() end)
end

function Application:tickMultiThread()
	self:doCommonTick()

	self:measure('gameView:tick()', function() self.gameView:tick() end)
	self.remoteGameManager:pushTick()
	self.previousTickTime = love.timer.getTime()
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
end

function Application:host(port, password)
	Log.info("Hosting on port %d.", port)

	self.adminChannel:push({
		type = 'host',
		address = "*",
		port = tostring(port),
		password = password
	})

	self.isConnected = true

	self:setPassword(password)
	self:swapRPCService(ClientRPCService, "localhost", tostring(port))
end

function Application:disconnect()
	Log.info("Switching to single player.")

	self.adminChannel:push({
		type = 'disconnect'
	})

	self.isConnected = false

	self:swapRPCService(ChannelRPCService, self.outputChannel, self.inputChannel)
end

function Application:setAdmin(clientID)
	Log.info("Setting admin to client %d.")

	self.adminChannel:push({
		type = 'admin',
		admin = clientID
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

	self.isConnected = true
end

function Application:getIsConnected()
	return self.isConnected
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

function Application:quit()
	if self.multiThreaded then
		self.game:quit()
		self.remoteGameManager:pushTick()

		if self.rpcService then
			self.rpcService:close()
		end

		if self.gameThread then
			self.adminChannel:push({
				type = 'quit'
			})
			self.gameThread:wait()

			local e = self.gameThread:getError()
			if e then
				Log.warn("Error quitting logic thread: %s", e)
			end
		end
	end

	return false
end

function Application:quitGame(game)
	-- Nothing.
end

function Application:mousePress(x, y, button)
	if self.uiView:getInputProvider():isBlocking(x, y) then
		self.uiView:getInputProvider():mousePress(x, y, button)
		return true
	end

	return false
end

function Application:mouseRelease(x, y, button)
	self.uiView:getInputProvider():mouseRelease(x, y, button)

	return false
end

function Application:mouseScroll(x, y)
	if self.uiView:getInputProvider():isBlocking(love.mouse.getPosition()) then
		self.uiView:getInputProvider():mouseScroll(x, y)
		return true
	end

	return false
end

function Application:mouseMove(x, y, button)
	self.uiView:getInputProvider():mouseMove(x, y, dx, dy)

	return false
end

function Application:keyDown(...)
	self.uiView:getInputProvider():keyDown(...)
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
	return math.min(math.max((currentTime - previousTime) / self:getAdaptiveTickDelta(), 0), 1)
end

function Application:drawDebug()
	if not _DEBUG or not self.showDebug then
		return
	end

	love.graphics.setFont(self.defaultFont)

	local drawCalls = love.graphics.getStats().drawcalls
	local width = love.window.getMode()
	local r = string.format("FPS: %03d (%03d draws, %03d MB)\n", love.timer.getFPS(), drawCalls, collectgarbage("count") / 1024)
	local sum = 0
	for i = 1, #self.times do
		r = r .. string.format(
			"%s: %.04f ms (%010d)\n",
			self.times[i].name,
			self.times[i].value * 1000,
			1 / self.times[i].value)
		sum = sum + self.times[i].value
	end
	if 1 / sum < 60 then
		r = r .. string.format(
				"!!! sum: %.04f ms (%010d)\n",
				sum * 1000,
				1 / sum)
	else
		r = r .. string.format(
				"sum: %.04f ms (%010d)\n",
				sum * 1000,
				1 / sum)
	end

	r = r .. string.format(
			"tick delta: %.04f ms\n",
			self:getAdaptiveTickDelta() * 1000)

	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.printf(
		r,
		width - 600 + 1,
		1,
		600,
		'right')

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(
		r,
		width - 600,
		0,
		600,
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
		if self.show3D and not self.uiView:getIsFullscreen() then
			self.gameView:getRenderer():draw(self.gameView:getScene(), delta)
		end

		self.gameView:getRenderer():present()

		if self.show2D then
			self.gameView:getSpriteManager():draw(self.camera, delta)
		end
	end

	love.graphics.setBlendMode('alpha')
	love.graphics.origin()
	love.graphics.ortho(width, height)

	if self.show2D then
		self.uiView:draw()
	end

	if self.clickActionTime > 0 then
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
