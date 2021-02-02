--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ParticleSceneNode.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local ParticleSystem = require "ItsyScape.Graphics.ParticleSystem"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local ParticleSceneNode = Class(SceneNode)
ParticleSceneNode.DEFAULT_SHADER = ShaderResource()
do
	ParticleSceneNode.DEFAULT_SHADER:loadFromFile("Resources/Shaders/StaticModel")
end

ParticleSceneNode.MESH_FORMAT = {
	{ "VertexPosition", 'float', 3 },
	{ "VertexNormal", 'float', 3 },
	{ "VertexColor", 'float', 4 },
	{ "VertexTexture", 'float', 2 }
}

ParticleSceneNode.MESH_DATA = {
	{ -1, -1, -1, 0, 0, 1, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0 },
	{  1, -1, -1, 0, 0, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0 },
	{  1,  1, -1, 0, 0, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 },
	{ -1, -1, -1, 0, 0, 1, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0 },
	{  1,  1, -1, 0, 0, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 },
	{ -1,  1, -1, 0, 0, 1, 1.0, 1.0, 1.0, 1.0, 0.0, 1.0 }
}

function ParticleSceneNode:new()
	SceneNode.new(self)

	self:getMaterial():setShader(ParticleSceneNode.DEFAULT_SHADER)
	self:getMaterial():setIsTranslucent(true)
	self:getMaterial():setIsFullLit(true)

	self.mesh = false

	self.vertexData = {}
end

function ParticleSceneNode:setParticleSystem(particleSystem)
	self.particleSystem = particleSystem
end

function ParticleSceneNode:getParticleSystem()
	return self.particleSystem
end

function ParticleSceneNode:initParticleSystemFromDef(def, resources)
	self.particleSystem = ParticleSystem(def.numParticles)

	self.textures = {
		{ left = 0, right = 1, top = 0, bottom = 1 }
	}

	if def.texture then
		self.textures = {}
		resources:queue(TextureResource, def.texture, function(texture)
			self:getMaterial():setTextures(texture)

			local w, h = texture:getResource():getWidth(), texture:getResource():getHeight() 
			local columns = def.columns or 1
			local cellSizeX = w / columns
			local rows = def.rows or math.max(h / cellSizeX, 1)
			local cellSizeY = h / rows

			self.textures = {}
			for j = 1, rows do
				for i = 1, columns do
					local left = (i - 1) * cellSizeX / w
					local right = i * cellSizeX / w
					local top = (j - 1) * cellSizeY / h
					local bottom = j * cellSizeY / h

					table.insert(self.textures, {
						left = left, right = right,
						top = top, bottom = bottom
					})
				end
			end
		end)
	end

	if def.rowWidth then
		self.rowWidth = def.rowWidth
	else
		self.rowWidth = 1
	end

	local emitters = def.emitters or {}
	self:initParticleEmittersFromDef(emitters)

	local paths = def.paths or {}
	self:initParticlePathsFromDef(paths)

	local emissionStrategy = def.emissionStrategy
	self:initParticleEmissionStrategyFromDef(emissionStrategy)
end

local function instantiate(def)
	local TypeName = string.format("ItsyScape.Graphics.Particles.%s", def.type)
	local Type = require(TypeName)

	local instance = Type()
	for key, value in pairs(def) do
		if key ~= "type" then
			local base = key:sub(1, 1):upper() .. key:sub(2)
			local setFuncName = "set" .. base
			local setFunc = instance[setFuncName]

			if setFunc then
				setFunc(instance, unpack(value))
			end
		end
	end

	return instance
end

function ParticleSceneNode:initParticleEmittersFromDef(defs)
	for i = 1, #defs do
		local emitter = instantiate(defs[i])
		self.particleSystem:addEmitter(emitter)
	end
end

function ParticleSceneNode:initParticlePathsFromDef(defs)
	for i = 1, #defs do
		local path = instantiate(defs[i])
		self.particleSystem:addPath(path)
	end
end

function ParticleSceneNode:initParticleEmissionStrategyFromDef(def)
	if def then
		local path = instantiate(def)
		self.particleSystem:setEmissionStrategy(path)
	end
end

function ParticleSceneNode:getGlobalRotation(delta)
	local parent = self
	local currentRotation, previousRotation = Quaternion.IDENTITY, Quaternion.IDENTITY
	repeat
		local transform = parent:getTransform()
		local parentCurrentRotation = transform:getLocalRotation()
		local _, parentPreviousRotation = transform:getPreviousTransform()

		currentRotation = parentCurrentRotation * currentRotation
		previousRotation = parentPreviousRotation * previousRotation

		parent = parent:getParent()
	until not parent

	return previousRotation:slerp(currentRotation, delta)
end

function ParticleSceneNode:frame(delta)
	if not self.particleSystem then
		return
	end

	local previousTime = self.previousTime or love.timer.getTime()
	local currentTime = love.timer.getTime()
	self.previousTime = currentTime

	self.particleSystem:update(currentTime - previousTime)

	local inverseRotation = -self:getGlobalRotation(delta)

	self.min = Vector(math.huge)
	self.max = Vector(-math.huge)

	local index = 1
	local numParticles = self.particleSystem:length()
	for i = 1, numParticles do
		local particle = self.particleSystem:get(i)

		local isAlive = particle.age < particle.lifetime
		if isAlive then
			if index + #ParticleSceneNode.MESH_DATA > #self.vertexData then
				self:pushNewQuad()
			end

			self:updateQuad(index, particle, inverseRotation)
			index = index + #ParticleSceneNode.MESH_DATA

			local particlePosition = Vector(particle.positionX, particle.positionY, particle.positionZ)
			self.min:min(particlePosition)
			self.max:max(particlePosition)
		end
	end

	while #self.vertexData >= index do
		table.remove(self.vertexData)
	end

	self.numVertices = index - 1

	if (not self.mesh or #self.vertexData > self.mesh:getVertexCount())
	   and #self.vertexData > 0
	then
		self.mesh = love.graphics.newMesh(
			ParticleSceneNode.MESH_FORMAT,
			self.vertexData,
			'triangles',
			'dynamic')
		self.mesh:setAttributeEnabled("VertexPosition", true)
		self.mesh:setAttributeEnabled("VertexNormal", true)
		self.mesh:setAttributeEnabled("VertexColor", true)
		self.mesh:setAttributeEnabled("VertexTexture", true)
	elseif self.mesh then
		self.mesh:setVertices(self.vertexData, 1, self.numVertices)
	end
end

function ParticleSceneNode:pushNewQuad()
	for i = 1, #ParticleSceneNode.MESH_DATA do
		table.insert(self.vertexData, { unpack(ParticleSceneNode.MESH_DATA[i]) })
	end
end

function ParticleSceneNode:updateQuad(index, particle, rotation)
	for i = 0, #ParticleSceneNode.MESH_DATA - 1 do
		local localIndex = i + 1
		local vertex = self.vertexData[index + i]
		local templateVertex = ParticleSceneNode.MESH_DATA[localIndex]

		vertex[1], vertex[2], vertex[3] =
			templateVertex[1] * particle.scaleX,
			templateVertex[2] * particle.scaleY,
			templateVertex[3]

		do
			-- TODO: Optimize
			local v = Vector(vertex[1], vertex[2], vertex[3])
			local r = rotation * Quaternion.fromAxisAngle(Vector.UNIT_Z, particle.rotation)
			vertex[1], vertex[2], vertex[3] = r:transformVector(v):get()
		end

		vertex[1], vertex[2], vertex[3] =
			vertex[1] + particle.positionX,
			vertex[2] + particle.positionY,
			vertex[3] + particle.positionZ
		vertex[7], vertex[8], vertex[9], vertex[10] =
			particle.colorRed, particle.colorGreen, particle.colorBlue, particle.colorAlpha

		local texture = self.textures[particle.textureIndex]
		if texture then
			if templateVertex[11] == 0 then
				vertex[11] = texture.left
			else
				vertex[11] = texture.right
			end
			if templateVertex[12] == 0 then
				vertex[12] = texture.top
			else
				vertex[12] = texture.bottom
			end
		end
	end
end

function ParticleSceneNode:draw(renderer, delta)
	local shader = renderer:getCurrentShader()
	local diffuseTexture = self:getMaterial():getTexture(1)
	if shader:hasUniform("scape_DiffuseTexture") and
	   diffuseTexture and diffuseTexture:getIsReady()
	then
		shader:send("scape_DiffuseTexture", diffuseTexture:getResource())
	end

	if self.mesh and self.numVertices > 0 then
		self.mesh:setDrawRange(1, self.numVertices)
		love.graphics.draw(self.mesh)
	end
end

return ParticleSceneNode
