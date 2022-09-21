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
local MapMesh = require "ItsyScape.World.MapMesh"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"

local MapMeshSceneNode = Class(SceneNode)
MapMeshSceneNode.DEFAULT_SHADER = ShaderResource()
do
	MapMeshSceneNode.DEFAULT_SHADER:loadFromFile("Resources/Shaders/BasicMapMesh")
end
MapMeshSceneNode.MULTITEXTURE_SHADER = ShaderResource()
do
	MapMeshSceneNode.MULTITEXTURE_SHADER:loadFromFile("Resources/Shaders/MultiTextureMapMesh")
end

function MapMeshSceneNode:new()
	SceneNode.new(self)

	self.mapMesh = false
	self.isOwner = false

	self:getMaterial():setShader(MapMeshSceneNode.DEFAULT_SHADER)
end

function MapMeshSceneNode:fromMap(map, tileSet, x, y, w, h, mask)
	if self.isOwner and self.mapMesh then
		self.mapMesh:release()
	end

	self.mapMesh = MapMesh(map, tileSet, x, x + (w - 1), y, y + (h - 1), mask)
	self.isOwner = true

	self:setBounds(self.mapMesh:getBounds())
end

function MapMeshSceneNode:setMapMesh(mapMesh, isMultiTexture)
	if self.isOwner then
		if self.mapMesh then
			self.mapMesh:release()
			self.mapMesh = false
		end

		self.isOwner = false
	end

	self.mapMesh = mapMesh or false
	self.isMultiTexture = isMultiTexture
end

function MapMeshSceneNode:draw(renderer, delta)
	local shader = renderer:getCurrentShader()
	local diffuse = self:getMaterial():getTexture(1)
	if shader:hasUniform("scape_DiffuseTexture") and
	   diffuse and diffuse:getIsReady()
	then
		diffuse:getResource():setFilter('nearest', 'nearest')
		shader:send("scape_DiffuseTexture", diffuse:getResource())
	end

	local mask = self:getMaterial():getTexture(2)
	if shader:hasUniform("scape_MaskTexture") and
	   mask and mask:getIsReady()
	then
		mask:getResource():setFilter('nearest', 'nearest')
		shader:send("scape_MaskTexture", mask:getResource())
	end

	if self.mapMesh then
		self.mapMesh:draw()
	end
end

return MapMeshSceneNode
