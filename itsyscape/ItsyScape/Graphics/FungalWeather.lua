--------------------------------------------------------------------------------
-- ItsyScape/Graphics/FungalWeather.lua
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
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local Weather = require "ItsyScape.Graphics.Weather"
local NFungalWeather = require "nbunny.optimaus.fungalweather"

local FungalWeather = Class(Weather)

FungalWeather.SceneNode = Class(SceneNode)
FungalWeather.SceneNode.SHADER = ShaderResource()
do
	FungalWeather.SceneNode.SHADER:loadFromFile("Resources/Shaders/WeatherFungus")
end
FungalWeather.SceneNode.TEXTURE = TextureResource()
do
	FungalWeather.SceneNode.TEXTURE:loadFromFile("Resources/Shaders/WeatherFungus_Spore.png")
end

function FungalWeather.SceneNode:new(weather)
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
	self:getMaterial():setTextures(FungalWeather.SceneNode.TEXTURE)
	self:getMaterial():setShader(FungalWeather.SceneNode.SHADER)
	self:getMaterial():setIsTranslucent(true)
	self:getMaterial():setIsFullLit(true)

	self.weather = weather
end

function FungalWeather.SceneNode:draw(renderer, delta)
	local mesh = self.weather:getMesh()

	local shader = renderer:getCurrentShader()
	local diffuseTexture = self:getMaterial():getTexture(1)
	if shader:hasUniform("scape_DiffuseTexture") and
	   diffuseTexture and diffuseTexture:getIsReady()
	then
		shader:send("scape_DiffuseTexture", diffuseTexture:getResource())
	end

	if mesh then
		love.graphics.push('all')
		love.graphics.setBlendMode('alpha')
		love.graphics.setMeshCullMode('none')
		love.graphics.setDepthMode('lequal', false)
		love.graphics.draw(mesh)
		love.graphics.setDepthMode('lequal', true)
		love.graphics.draw(mesh)
		love.graphics.pop()
	end
end

function FungalWeather:new(gameView, layer, map, props)
	Weather.new(self, gameView, map)

	props = props or {}

	local width, height = map:getSize()

	self._handle = NFungalWeather()
	self._handle:setGravity(unpack(props.gravity or { 0, -20, 0 }))
	self._handle:setWind(unpack(props.wind or { 0, 0, 0 }))
	self._handle:setHeaviness(math.max(props.heaviness or 0.0, 0))
	self._handle:setMinHeight(props.minHeight or 30)
	self._handle:setMaxHeight(props.maxHeight or 50)
	self._handle:setMinSize(props.minSize or 2)
	self._handle:setMaxSize(props.maxSize or 4)
	self._handle:setCeiling(props.ceiling or 0.0)
	self._handle:setColors(props.colors or { { 1.0, 1.0, 1.0, 1.0 } })

	self.node = FungalWeather.SceneNode(self)
	self.node:setParent(gameView:getMapSceneNode(layer))

	if props.init then
		for i = 1, props.steps or 100 do
			self:update(1)
		end
	else
		self:update(0) 
	end
end

function FungalWeather:getMesh()
	return self._handle:getMesh()
end

function FungalWeather:getGravity()
	return Vector(self._handle:getGravity())
end

function FungalWeather:setGravity(value)
	self._handle:setGravity(value:get())
end

function FungalWeather:getWind()
	return Vector(self._handle:getWind())
end

function FungalWeather:setWind(value)
	self._handle:setWind(value:get())
end

function FungalWeather:getHeaviness()
	return self._handle:getHeaviness()
end

function FungalWeather:setHeaviness(value)
	self._handle:setHeaviness(value)
end

function FungalWeather:getMinHeight()
	return self._handle:getMinHeight()
end

function FungalWeather:setMinHeight(value)
	self._handle:setMinHeight(value)
end

function FungalWeather:getMaxHeight()
	return self._handle:getMaxHeight()
end

function FungalWeather:setMaxHeight(value)
	self._handle:setMaxHeight(value)
end

function FungalWeather:getMinSize()
	return self._handle:getMinSize()
end

function FungalWeather:setMinSize(value)
	self._handle:setMinSize(value)
end

function FungalWeather:getMaxSize()
	return self._handle:getMaxSize()
end

function FungalWeather:setMaxSize(value)
	self._handle:setMaxSize(value)
end

function FungalWeather:getCeiling()
	return self._handle:getCeiling()
end

function FungalWeather:setCeiling(value)
	self._handle:setCeiling(value)
end

function FungalWeather:getColors()
	local colors = self._handle:getColors()
	local c = {}
	for i = 1, #c do
		c[i] = Color(colors[i])
	end

	return c
end

function FungalWeather:setColors(colors)
	local c = {}
	for i = 1, #colors do
		c[i] = { colors[i]:get() }
	end

	self._handle:setColors(c)
end

function FungalWeather:update(delta)
	Weather.update(self, delta)

	self._handle:update(self:getMap():getHandle(), delta)

	local map = self:getMap()
	local startI, startJ = map:getPosition()
	local cellSize = map:getCellSize()
	self.node:getTransform():setLocalTranslation(Vector(startI * cellSize, 0, startJ * cellSize))
end

function FungalWeather:remove()
	self.node:setParent(nil)
end

return FungalWeather
