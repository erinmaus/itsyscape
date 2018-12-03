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
local Vector = require "ItsyScape.Common.Math.Vector"
local Ray = require "ItsyScape.Common.Math.Ray"
local Probe = require "ItsyScape.Game.Probe"
local GameDB = require "ItsyScape.GameDB.GameDB"
local LocalGame = require "ItsyScape.Game.LocalModel.Game"
local GameView = require "ItsyScape.Graphics.GameView"
local Renderer = require "ItsyScape.Graphics.Renderer"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local UIView = require "ItsyScape.UI.UIView"

local function createGameDB()
	local t = {
		"Resources/Game/DB/Init.lua"
	}

	for _, item in ipairs(love.filesystem.getDirectoryItems("Resources/Game/Maps/")) do
		local f1 = "Resources/Game/Maps/" .. item .. "/DB/Main.lua"
		local f2 = "Resources/Game/Maps/" .. item .. "/DB/Default.lua"
		if love.filesystem.getInfo(f1) then
			table.insert(t, f1)
		elseif love.filesystem.getInfo(f2) then
			table.insert(t, f2)
		end
	end

	return GameDB.create(t, ":memory:")
end

local FONT = love.graphics.getFont()

local Application = Class()
function Application:new()
	self.camera = ThirdPersonCamera()
	do
		self.camera:setDistance(30)
		self.camera:setUp(Vector(0, -1, 0))
		self.camera:setHorizontalRotation(-math.pi / 8)
		self.camera:setVerticalRotation(-math.pi / 2)
	end

	self.previousTickTime = love.timer.getTime()
	self.startDrawTime = false
	self.time = 0

	self.frames = 0
	self.frameTime = 0

	self.gameDB = createGameDB()
	self.game = LocalGame(self.gameDB)
	self.gameView = GameView(self.game)
	self.uiView = UIView(self.gameView)

	self.times = {}

	self.gameView:getRenderer():setCamera(self.camera)

	self.showDebug = true
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
	self:getGame():getStage():newMap(1, 1, 1)

	self:tick()
end

function Application:getCamera()
	return self.camera
end

function Application:getGameDB()
	return self.gameDB
end

function Application:getGame()
	return self.game
end

function Application:getGameView()
	return self.gameView
end

function Application:getUIView()
	return self.uiView
end

function Application:probe(x, y, performDefault, callback)
	local ray = self:shoot(x, y)
	local probe = Probe(self.game, self.gameDB, ray)
	probe:all(function()
		if performDefault then
			for action in probe:iterate() do
				local s, r = pcall(action.callback)
				if not s then
					Log.warn("couldn't perform action: %s", r)
				end
				break
			end
		else
			self.uiView:probe(probe:toArray())
		end

		if callback then
			callback()
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
	while self.time > self.game:getDelta() do
		self:tick()

		-- Handle cases where 'delta' exceeds TICK_RATE
		self.time = self.time - self.game:getDelta()

		-- Store the previous frame time.
		self.previousTickTime = love.timer.getTime()
	end

	self:measure('game:update()', function() self.game:update(delta) end)
	self:measure('gameView:update()', function() self.gameView:update(delta) end)
	self:measure('uiView:update()', function() self.uiView:update(delta) end)
	--self.gameView:update(delta)
	--self.uiView:update(delta)
end

function Application:tick()
	self:measure('gameView:tick()', function() self.gameView:tick() end)
	self:measure('game:tick()', function() self.game:tick() end)
	--self.gameView:tick()
	--self.game:tick()
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
	self.uiView:getInputProvider():mouseScroll(x, y)

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
	return (currentTime - previousTime) / self.game:getDelta()
end

function Application:draw()
	local width, height = love.window.getMode()
	local function draw()
		local delta = self:getFrameDelta()

		self.camera:setWidth(width)
		self.camera:setHeight(height)

		self.gameView:getRenderer():draw(self.gameView:getScene(), delta)
		self.gameView:getRenderer():present()
		self.gameView:getSpriteManager():draw(self.camera, delta)

		love.graphics.setBlendMode('alpha')
		love.graphics.origin()
		love.graphics.ortho(width, height)

		self.uiView:draw()
	end

	local s, r = xpcall(function() self:measure('draw', draw) end, debug.traceback)
	if not s then
		love.graphics.setBlendMode('alpha')
		love.graphics.origin()
		love.graphics.ortho(width, height)

		error(r, 0)
	end

	if _DEBUG and self.showDebug then
		love.graphics.setFont(FONT)

		local width = love.window.getMode()
		local r = string.format("FPS: %d\n", love.timer.getFPS())
		local sum = 0
		for i = 1, #self.times do
			r = r .. string.format(
				"%s: %.04f (%010d)\n",
				self.times[i].name,
				self.times[i].value,
				1 / self.times[i].value)
			sum = sum + self.times[i].value
		end
		if 1 / sum < 60 then
			r = r .. string.format(
					"!!! sum: %.04f (%010d)\n",
					sum,
					1 / sum)
		else
			r = r .. string.format(
					"sum: %.04f (%010d)\n",
					sum,
					1 / sum)
		end

		love.graphics.printf(
			r,
			width - 300,
			0,
			300,
			'right')
	end

	self.frames = self.frames + 1
	local currentTime = love.timer.getTime()
	if currentTime > self.frameTime + 1 then
		self.fps = math.floor(self.frames / (currentTime - self.frameTime))
		self.frames = 0
		self.frameTime = currentTime
	end
end

return Application
