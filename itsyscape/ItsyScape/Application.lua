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

	self.gameDB = GameDB.create("Resources/Game/DB/Init.lua", ":memory:")
	self.game = LocalGame(self.gameDB)
	self.gameView = GameView(self.game)
	self.uiView = UIView(self.game)

	self.gameView:getRenderer():setCamera(self.camera)
end

function Application:initialize()
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

function Application:probe(x, y, performDefault)
	local ray = self:shoot(x, y)
	local probe = Probe(self.game, self.gameDB, ray)
	probe:all()

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

	self.gameView:update(delta)
	self.uiView:update(delta)
end

function Application:tick()
	self.gameView:tick()
	self.game:tick()
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

		if not self.startDrawTime then
			self.startDrawTime = currentTime
		end

		self.gameView:getRenderer():draw(self.gameView:getScene(), delta)
		self.gameView:getRenderer():present()
		self.gameView:getSpriteManager():draw(self.camera, delta)

		love.graphics.setBlendMode('alpha')
		love.graphics.origin()
		love.graphics.ortho(width, height)

		self.uiView:draw()
	end

	local s, r = xpcall(draw, debug.traceback)
	if not s then
		love.graphics.setBlendMode('alpha')
		love.graphics.origin()
		love.graphics.ortho(width, height)

		error(r, 0)
	end
end

return Application
