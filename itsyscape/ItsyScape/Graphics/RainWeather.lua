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

local RainWeather = Class(Weather)

RainWeather.MESH_FORMAT = {
	{ "VertexPosition", 'float', 3 }
}

RainWeather.QUAD = {
	{ -1,  0,  0 },
	{  1,  0,  0 },
	{  1,  1,  0 },
	{ -1,  0,  0 },
	{  1,  1,  0 },
	{ -1,  1,  0 },

	{  0,  0, -1 },
	{  0,  1, -1 },
	{  0,  1,  1 },
	{  0,  0, -1 },
	{  0,  1,  1 },
	{  0,  0,  1 }
}

ffi.cdef [[
	typedef struct {
		float x, y, z;
		float length;
		bool moving;
	} scape_RainParticle;	
]]

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
	self:getMaterial():setColor(weather.color)
	self:getMaterial():setIsFullLit(true)

	self.weather = weather
end

function RainWeather.SceneNode:draw(renderer, delta)
	local mesh = self.weather.mesh

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

function RainWeather:new(gameView, map, props)
	Weather.new(self, gameView, map)

	props = props or {}

	local width, height = map:getSize()

	self.gravity = Vector(unpack(props.gravity or { 0, -20, 0 }))
	self.wind = Vector(unpack(props.wind or { 0, 0, 0 }))
	self.heaviness = math.floor(math.max(props.heaviness or 0.0, 0.0) * width * height)
	self.minHeight = props.minHeight or 30
	self.maxHeight = props.maxHeight or 50
	self.minLength = props.minLength or 2
	self.maxLength = props.maxLength or 4
	self.size = props.size or 1 / 32
	self.color = Color(unpack(props.color or { 0.0, 0.6, 0.8, 0.4 }))

	self.particles = ffi.new("scape_RainParticle[?]", self.heaviness)

	self.vertices = {}
	self.vertexCount = self.heaviness * 12 -- 6 per quad, 2 quads per rain streak
	for i = 1, self.vertexCount do
		table.insert(self.vertices, { 0, 0, 0 })
	end

	self.mesh = love.graphics.newMesh(
		RainWeather.MESH_FORMAT,
		self.vertices,
		'triangles',
		'dynamic')
	self.mesh:setAttributeEnabled("VertexPosition", true)

	self.node = RainWeather.SceneNode(self)
	self.node:setParent(gameView:getScene())

	if props.init then
		for i = 1, props.steps or 100 do
			self:update(1)
		end
	else
		self:update(0) 
	end
end

function RainWeather:update(delta)
	Weather.update(self, delta)


	local map = self:getMap()
	local startI, startJ = map:getPosition()
	local mapWidth, mapHeight = map:getSize()
	local cellSize = map:getCellSize()
	local velocity = (self.gravity + self.wind) * delta
	local speed = self.gravity:getLength() * delta
	local direction = -(self.gravity + self.wind):getNormal()
	local size = self.size
	local vertexIndex = 1
	local vertices = RainWeather.QUAD

	for i = 1, self.heaviness do
		local p = self.particles + (i - 1)

		if p.length <= 0 then
			local s, t = math.random(), math.random()
			do
				s = s * cellSize
				t = t * cellSize
			end

			local i, j = math.random(startI, startI + mapWidth), math.random(startJ, startJ + mapHeight)
			local x = (i - 1) * cellSize + s
			local y = math.random() * (self.maxHeight - self.minHeight) + self.minHeight
			local z = (j - 1) * cellSize + t

			local length = math.random() * (self.maxLength - self.minLength) + self.minLength

			p.x, p.y, p.z = x, y, z
			p.length = length
			p.moving = true
		else
			if p.moving then
				local i = math.floor(p.x / cellSize + 1)
				local j = math.floor(p.z / cellSize + 1)

				local height = math.max(map:getHeightAt(i, j), 0)
				if p.y <= height then
					p.moving = false
				else
					p.x = p.x + velocity.x
					p.y = p.y + velocity.y
					p.z = p.z + velocity.z
				end
			else
				p.length = p.length - speed
			end
		end

		for j = 1, #vertices do
			local input = vertices[j]
			local output = self.vertices[vertexIndex]
			output[1] = input[1] * size + p.x + input[2] * direction.x * p.length
			output[2] = input[2] * size + p.y + input[2] * direction.y * p.length
			output[3] = input[3] * size + p.z + input[2] * direction.z * p.length

			vertexIndex = vertexIndex + 1
		end
	end

	self.mesh:setVertices(self.vertices)
	self.node:getTransform():setLocalTranslation(map:getAbsolutePosition())
end

function RainWeather:remove()
	self.node:setParent(nil)
end

return RainWeather
