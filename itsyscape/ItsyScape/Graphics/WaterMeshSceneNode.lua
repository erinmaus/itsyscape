
--------------------------------------------------------------------------------
-- ItsyScape/Graphics/SceneNode.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local WaterMesh = require "ItsyScape.World.WaterMesh"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"

local WaterMeshSceneNode = Class(SceneNode)
WaterMeshSceneNode.DEFAULT_SHADER = ShaderResource()
do
	WaterMeshSceneNode.DEFAULT_SHADER:loadFromFile("Resources/Shaders/Water")
end

function WaterMeshSceneNode:new()
	SceneNode.new(self)

	self.waterMesh = false
	self.isOwner = false

	self.yOffset = 0.125
	self.positionTimeScale = 8
	self.textureTimeScale = Vector(math.pi / 4, 0.5):keep()

	self.width = 0
	self.height = self.yOffset * 2
	self.depth = 0

	self:getMaterial():setShader(WaterMeshSceneNode.DEFAULT_SHADER)
	self:getMaterial():setIsStencilMaskEnabled(true)
end

function WaterMeshSceneNode:getYOffset()
	return self.yOffset
end

function WaterMeshSceneNode:setYOffset(value)
	self.yOffset = value or self.yOffset

	if self.waterMesh then
		local min, max = self.waterMesh:getBounds()

		if self.yOffset < 0 then
			self:setBounds(min + Vector(0, self.yOffset, 0), max)
		else
			self:setBounds(min, max + Vector(0, self.yOffset, 0))
		end
	end
end

function WaterMeshSceneNode:getPositionTimeScale()
	return self.positionTimeScale
end

function WaterMeshSceneNode:setPositionTimeScale(value)
	self.positionTimeScale = value or self.positionTimeScale
end

function WaterMeshSceneNode:getTextureTimeScale()
	return self.textureTimeScale.x, self.textureTimeScale.y
end

function WaterMeshSceneNode:setTextureTimeScale(x, y)
	self.textureTimeScale.x = x or self.textureTimeScale.x
	self.textureTimeScale.y = y or self.textureTimeScale.y
end

function WaterMeshSceneNode:generate(map, i, j, w, h, y, scale, fine, cellSize)
	fine = fine or 2
	y = y or (map and map:getTileCenter(i + math.floor(w / 2), j + math.floor(h / 2)).y + 0.5) or 1

	if self.isOwner and self.waterMesh then
		self.waterMesh:release()
	end

	local width, height = w * fine, h * fine

	self.waterMesh = WaterMesh(width, height, scale, i, j - 1, fine * map:getCellSize())
	self.isOwner = true

	local cellSize = cellSize or (map and map:getCellSize()) or 2
	local x, z = (i - 1) * cellSize, (j - 1) * cellSize

	local transform = self:getTransform()
	transform:setLocalScale(Vector(1 / fine * cellSize, 1, 1 / fine * cellSize))
	transform:setLocalTranslation(Vector(x, y, z))

	self.width = width
	self.depth = height

	self:setBounds(Vector.ZERO, Vector(self.width, self.height, self.depth))
end

function WaterMeshSceneNode:setMesh(mesh)
	if self.isOwner and self.waterMesh then
		self.waterMesh:release()
	end

	self.waterMesh = mesh
	self.isOwner = false

	self:setBounds(self.waterMesh:getBounds())
end

function WaterMeshSceneNode:getMesh()
	return self.waterMesh
end

-- Hahahahaha.
function WaterMeshSceneNode:degenerate()
	if self.waterMesh then
		self.waterMesh:release()
	end
end

function WaterMeshSceneNode:frame()
	local material = self:getMaterial()

	local diffuseTexture = self:getMaterial():getTexture(1)
	if diffuseTexture and diffuseTexture:getIsReady() then
		material:send(material.UNIFORM_TEXTURE, "scape_DiffuseTexture", diffuseTexture:getResource())
	end

	material:send(material.UNIFORM_FLOAT, "scape_TimeScale", self.positionTimeScale, self.textureTimeScale.x, self.textureTimeScale.y, 0)
	material:send(material.UNIFORM_FLOAT, "scale_YOffset", self.yOffset)
	material:send(material.UNIFORM_FLOAT, "scale_XZScale", self.waterMesh and self.waterMesh:getScale() or 4)

	local Color = require "ItsyScape.Graphics.Color"
	material:send(material.UNIFORM_FLOAT, "scape_FoamColor", Color.fromHexString("7a253c", 0.5):get())
	material:send(material.UNIFORM_FLOAT, "scape_ShallowWaterColor", Color.fromHexString("604ba5", 1.0):get())
	material:send(material.UNIFORM_FLOAT, "scape_DeepWaterColor", Color.fromHexString("604ba5", 1.0):get())
end

function WaterMeshSceneNode:draw(renderer, delta)
	if self.waterMesh then
		self.waterMesh:draw()
	end
end

return WaterMeshSceneNode
