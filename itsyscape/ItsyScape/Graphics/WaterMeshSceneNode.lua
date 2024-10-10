
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
	self:getMaterial():setIsReflectiveOrRefractive(true)
	self:getMaterial():setReflectionPower(1.0)
	self:getMaterial():setReflectionDistance(0.2)
end

function WaterMeshSceneNode:getYOffset()
	return self.yOffset
end

function WaterMeshSceneNode:setYOffset(value)
	self.yOffset = value or self.yOffset
	self:setBounds(Vector.ZERO, Vector(self.width, self.height, self.depth))
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

	self.waterMesh = WaterMesh(width, height, scale)
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

-- Hahahahaha.
function WaterMeshSceneNode:degenerate()
	if self.waterMesh then
		self.waterMesh:release()
	end
end

function WaterMeshSceneNode:draw(renderer, delta)
	local shader = renderer:getCurrentShader()
	local texture = self:getMaterial():getTexture(1)
	if shader:hasUniform("scape_DiffuseTexture") and
	   texture and texture:getIsReady()
	then
		texture:getResource():setFilter('nearest', 'nearest')
		texture:getResource():setWrap('repeat', 'repeat')
		shader:send("scape_DiffuseTexture", texture:getResource(renderer:getCurrentPass():getID()))
	end

	if shader:hasUniform("scape_TimeScale") then
		shader:send("scape_TimeScale", { self.textureTimeScale.x, self.textureTimeScale.y, self.positionTimeScale, self.width })
	end

	if shader:hasUniform("scape_YOffset") then
		shader:send("scape_YOffset", self.yOffset)
	end

	if shader:hasUniform("scape_XZScale") then
		shader:send("scape_XZScale", self.waterMesh and self.waterMesh:getScale() or 4)
	end

	if self.waterMesh then
		self.waterMesh:draw()
	end
end

return WaterMeshSceneNode
