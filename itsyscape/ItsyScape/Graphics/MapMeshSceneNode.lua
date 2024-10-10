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
local Color = require "ItsyScape.Graphics.Color"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local MapMesh = require "ItsyScape.World.MapMesh"
local MultiTileSet = require "ItsyScape.World.MultiTileSet"
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
	self:getMaterial():setOutlineThreshold(-0.01)
	self:getMaterial():setOutlineColor(Color(0.7))
end

function MapMeshSceneNode:fromMap(map, tileSet, x, y, w, h, mask, islandProcessor, largeTileSet)
	if self.isOwner and self.mapMesh then
		self.mapMesh:release()
	end

	if Class.isCompatibleType(tileSet, MultiTileSet) or largeTileSet then
		self:getMaterial():setShader(MapMeshSceneNode.MULTITEXTURE_SHADER)
	else
		self:getMaterial():setShader(MapMeshSceneNode.DEFAULT_SHADER)
	end

	self.mapMesh = MapMesh(map, tileSet, x, x + (w - 1), y, y + (h - 1), mask, islandProcessor, largeTileSet)
	self.isOwner = true

	self:setBounds(self.mapMesh:getBounds())
end

function MapMeshSceneNode:getMapMesh()
	return self.mapMesh
end

function MapMeshSceneNode:setMapMesh(mapMesh, isMultiTexture)
	if self.isOwner then
		if self.mapMesh then
			self.mapMesh:release()
			self.mapMesh = false
		end

		self.isOwner = false
	end

	if isMultiTexture then
		self:getMaterial():setShader(MapMeshSceneNode.MULTITEXTURE_SHADER)
	else
		self:getMaterial():setShader(MapMeshSceneNode.DEFAULT_SHADER)
	end

	self.mapMesh = mapMesh or false
end

function MapMeshSceneNode:draw(renderer, delta)
	local shader = renderer:getCurrentShader()
	local diffuse = self:getMaterial():getTexture(1)
	if shader:hasUniform("scape_DiffuseTexture") and
	   diffuse and diffuse:getIsReady()
	then
		diffuse:getHandle():getPerPassTexture(renderer:getCurrentPass():getID()):setFilter('nearest', 'nearest')
		shader:send("scape_DiffuseTexture", diffuse:getHandle():getPerPassTexture(renderer:getCurrentPass():getID()))
	end

	local mask = self:getMaterial():getTexture(2)
	if shader:hasUniform("scape_MaskTexture") and
	   mask and mask:getIsReady()
	then
		mask:getResource():setFilter('nearest', 'nearest')
		shader:send("scape_MaskTexture", mask:getResource())
	end

	local specular = self:getMaterial():getTexture(3)
	if shader:hasUniform("scape_SpecularTexture") and
	   specular and specular:getIsReady()
	then
		specular:getResource():setFilter('nearest', 'nearest')
		shader:send("scape_SpecularTexture", specular:getResource())
	end

	if self.mapMesh then
		self.mapMesh:draw()
	end
end

return MapMeshSceneNode
