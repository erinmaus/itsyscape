--------------------------------------------------------------------------------
-- ItsyScape/Graphics/RainWeather.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local ffi = require "ffi"
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local Weather = require "ItsyScape.Graphics.Weather"
local NRainWeather = require "nbunny.optimaus.rainweather"

local RainWeather = Class(Weather)

RainWeather.SceneNode = Class(SceneNode)
RainWeather.SceneNode.SHADER = ShaderResource()
do
	RainWeather.SceneNode.SHADER:loadFromFile("Resources/Shaders/WeatherRain")
end

function RainWeather.SceneNode:new(weather)
	SceneNode.new(self)

	local map = weather:getMap()
	local x, z = map:getPosition()
	local w, h = map:getSize()
	local cellSize = map:getCellSize()

	x = x * cellSize
	z = z * cellSize
	w = w * cellSize
	h = h * cellSize

	self:setBounds(Vector(x, -math.huge, z), Vector(x, math.huge, z))
	self:getMaterial():setShader(RainWeather.SceneNode.SHADER)
	self:getMaterial():setIsTranslucent(true)
	self:getMaterial():setColor(weather:getColor())
	self:getMaterial():setIsFullLit(true)

	self.weather = weather
end

function RainWeather.SceneNode:draw(renderer, delta)
	local mesh = self.weather:getMesh()

	if mesh then
		love.graphics.push('all')
		love.graphics.setMeshCullMode('none')
		love.graphics.setDepthMode('lequal', false)
		love.graphics.draw(mesh)
		love.graphics.setDepthMode('lequal', true)
		love.graphics.draw(mesh)
		love.graphics.pop()
	end
end

function RainWeather:new(gameView, layer, map, props)
	Weather.new(self, gameView, map)

	props = props or {}

	local width, height = map:getSize()

	self._handle = NRainWeather()
	self._handle:setGravity(unpack(props.gravity or { 0, -20, 0 }))
	self._handle:setWind(unpack(props.wind or { 0, 0, 0 }))
	self._handle:setHeaviness(math.max(props.heaviness or 0.0, 0))
	self._handle:setMinHeight(props.minHeight or 30)
	self._handle:setMaxHeight(props.maxHeight or 50)
	self._handle:setMinLength(props.minLength or 2)
	self._handle:setMaxLength(props.maxLength or 4)
	self._handle:setSize(props.size or 1 / 32)
	self._handle:setColor(unpack(props.color or { 0.0, 0.6, 0.8, 0.4 }))

	self.node = RainWeather.SceneNode(self)
	self.node:setParent(gameView:getMapSceneNode(layer))

	if props.init then
		for i = 1, props.steps or 100 do
			self:update(1)
		end
	else
		self:update(0) 
	end
end

function RainWeather:getMesh()
	return self._handle:getMesh()
end

function RainWeather:getGravity()
	return Vector(self._handle:getGravity())
end

function RainWeather:setGravity(value)
	self._handle:setGravity(value:get())
end

function RainWeather:getWind()
	return Vector(self._handle:getWind())
end

function RainWeather:setWind(value)
	self._handle:setWind(value:get())
end

function RainWeather:getHeaviness()
	return self._handle:getHeaviness()
end

function RainWeather:setHeaviness(value)
	self._handle:setHeaviness(value)
end

function RainWeather:getMinHeight()
	return self._handle:getMinHeight()
end

function RainWeather:setMinHeight(value)
	self._handle:setMinHeight(value)
end

function RainWeather:getMaxHeight()
	return self._handle:getMaxHeight()
end

function RainWeather:setMaxHeight(value)
	self._handle:setMaxHeight(value)
end

function RainWeather:getMinLength()
	return self._handle:getMinLength()
end

function RainWeather:setMinLength(value)
	self._handle:setMinLength(value)
end

function RainWeather:getMaxLength()
	return self._handle:getMaxLength()
end

function RainWeather:setMaxLength(value)
	self._handle:setMaxLength(value)
end

function RainWeather:getSize()
	return self._handle:getSize()
end

function RainWeather:setSize(value)
	self._handle:setSize(value)
end

function RainWeather:getColor()
	return Color(self._handle:getColor())
end

function RainWeather:setColor(value)
	self._handle:setColor(value:get())
end

function RainWeather:update(delta)
	Weather.update(self, delta)

	pcall(self._handle.update, self._handle, self:getMap():getHandle(), delta)

	local map = self:getMap()
	local startI, startJ = map:getPosition()
	local cellSize = map:getCellSize()
	self.node:getTransform():setLocalTranslation(Vector(startI * cellSize, 0, startJ * cellSize))
end

function RainWeather:remove()
	self.node:setParent(nil)
end

return RainWeather
