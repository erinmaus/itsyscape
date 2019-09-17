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
local Weather = require "ItsyScape.Graphics.Weather"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local FungalWeather = Class(Weather)

FungalWeather.MESH_FORMAT = {
	{ "VertexPosition", 'float', 3 },
	{ 'VertexTexture', 'float', 2 },
	{ "VertexColor", 'float', 4 }
}

FungalWeather.QUAD = {
	{ -1, -1,  0, 0, 0, 1, 1, 1, 1 },
	{  1, -1,  0, 1, 0, 1, 1, 1, 1 },
	{  1,  1,  0, 1, 1, 1, 1, 1, 1 },
	{ -1, -1,  0, 0, 0, 1, 1, 1, 1 },
	{  1,  1,  0, 1, 1, 1, 1, 1, 1 },
	{ -1,  1,  0, 0, 1, 1, 1, 1, 1 },

	{  0, -1, -1, 0, 0, 1, 1, 1, 1 },
	{  0,  1, -1, 1, 0, 1, 1, 1, 1 },
	{  0,  1,  1, 1, 1, 1, 1, 1, 1 },
	{  0, -1, -1, 0, 0, 1, 1, 1, 1 },
	{  0,  1,  1, 1, 1, 1, 1, 1, 1 },
	{  0, -1,  1, 0, 1, 1, 1, 1, 1 },
}

ffi.cdef [[
	typedef struct {
		float x, y, z;
		float size;
		float age;
		float alpha;
		int color;
		bool moving;
	} scape_SporeParticle;	
]]

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
	local mesh = self.weather.mesh

	local shader = renderer:getCurrentShader()
	local diffuseTexture = self:getMaterial():getTexture(1)
	if shader:hasUniform("scape_DiffuseTexture") and
	   diffuseTexture and diffuseTexture:getIsReady()
	then
		shader:send("scape_DiffuseTexture", diffuseTexture:getResource())
	end

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

function FungalWeather:new(gameView, map, props)
	Weather.new(self, gameView, map)

	props = props or {}

	local width, height = map:getSize()

	self.gravity = Vector(unpack(props.gravity or { 0, -20, 0 }))
	self.wind = Vector(unpack(props.wind or { 0, 0, 0 }))
	self.heaviness = math.floor(math.max(props.heaviness or 0.0, 0.0) * width * height)
	self.minHeight = props.minHeight or 10
	self.maxHeight = props.maxHeight or 30
	self.minSize = props.minSize or 2
	self.maxSize = props.maxSize or 4

	self.colors = {}
	do
		local colors = props.colors or {
			{ 1, 1, 1, 1 }
		}
		for i = 1, #colors do
			self.colors[i] = Color(unpack(colors[i]))
		end
	end

	self.particles = ffi.new("scape_SporeParticle[?]", self.heaviness)

	self.vertices = {}
	self.vertexCount = self.heaviness * 12 -- 6 per quad, 2 quads per rain streak
	for i = 1, self.vertexCount do
		table.insert(self.vertices, { 0, 0, 0 })
	end

	self.mesh = love.graphics.newMesh(
		FungalWeather.MESH_FORMAT,
		self.vertices,
		'triangles',
		'dynamic')
	self.mesh:setAttributeEnabled("VertexPosition", true)
	self.mesh:setAttributeEnabled("VertexTexture", true)
	self.mesh:setAttributeEnabled("VertexColor", true)

	self.node = FungalWeather.SceneNode(self)
	self.node:setParent(gameView:getScene())

	if props.init == nil or props.init then
		for i = 1, props.steps or 100 do
			self:update(1)
		end
	else
		self:update(0) 
	end
end

function FungalWeather:update(delta)
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
	local vertices = FungalWeather.QUAD

	for i = 1, self.heaviness do
		local p = self.particles + (i - 1)

		if p.alpha >= p.size then
			local s, t = math.random(), math.random()
			do
				s = s * cellSize
				t = t * cellSize
			end


			local i, j = math.random(startI, startI + mapWidth), math.random(startJ, startJ + mapHeight)
			local x = (i - 1) * cellSize + s
			local y = math.random() * (self.maxHeight - self.minHeight) + self.minHeight
			local z = (j - 1) * cellSize + t
			local s = math.random() * (self.maxSize - self.minSize) + self.minSize

			p.x, p.y, p.z = x, y, z
			p.alpha = 0
			p.age = 0
			p.size = s / 10
			p.moving = true
			p.color = math.random(#self.colors)
		else
			p.age = p.age + delta

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
				p.alpha = p.alpha + speed
			end
		end

		for j = 1, #vertices do
			local input = vertices[j]
			local output = self.vertices[vertexIndex]
			local r, g, b = self.colors[p.color]:get()
			local a = 1 - math.max(math.min(p.alpha / p.size,  1), 0)

			output[1] = input[1] * p.size + p.x + math.cos(p.age) * p.size * 2
			output[2] = input[2] * p.size + p.y + math.sin(p.age) * p.size * 2
			output[3] = input[3] * p.size + p.z
			output[4] = input[4]
			output[5] = input[5]
			output[6] = r
			output[7] = g
			output[8] = b
			output[9] = a

			vertexIndex = vertexIndex + 1
		end
	end

	self.mesh:setVertices(self.vertices)
end

return FungalWeather
