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
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local MapGridMesh = require "ItsyScape.World.MapGridMesh"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"

local MapGridMeshSceneNode = Class(SceneNode)
MapGridMeshSceneNode.DEFAULT_SHADER = ShaderResource()
do
	MapGridMeshSceneNode.DEFAULT_SHADER:loadFromFile("Resources/Shaders/BasicMapGridMesh")
end

function MapGridMeshSceneNode:new()
	SceneNode.new(self)

	self.mapMesh = false
	self.isOwner = false

	self:getMaterial():setIsTranslucent(true)
	self:getMaterial():setIsFullLit(true)
	self:getMaterial():setShader(MapGridMeshSceneNode.DEFAULT_SHADER)

	self.lineWidth = 2
end

function MapGridMeshSceneNode:getLineWidth()
	return self.lineWidth
end

function MapGridMeshSceneNode:setLineWidth(value)
	self.lineWidth = value or self.lineWidth
end

function MapGridMeshSceneNode:fromMap(map, motion, x, y, w, h)
	if self.isOwner and self.mapMesh then
		self.mapMesh:release()
	end

	self.mapMesh = MapGridMesh(map, motion, x, y, w, h)
	self.isOwner = true
end

function MapGridMeshSceneNode:setMapMesh(mapMesh)
	if self.isOwner then
		if self.mapMesh then
			self.mapMesh:release()
			self.mapMesh = false
		end

		self.isOwner = false
	end

	self.mapMesh = mapMesh or false
end

function MapGridMeshSceneNode:draw(renderer, delta)
	love.graphics.setDepthMode('lequal', false)
	love.graphics.setLineWidth(self.lineWidth)

	if self.mapMesh then
		self.mapMesh:draw()
	end

	love.graphics.setDepthMode('lequal', true)
end

return MapGridMeshSceneNode
