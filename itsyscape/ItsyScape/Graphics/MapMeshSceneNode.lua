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

function MapMeshSceneNode:fromMap(map, tileSet, x, y, w, h)
	if self.isOwner and self.mapMesh then
		self.mapMesh:release()
	end

	self.mapMesh = MapMesh(map, tileSet, x, x + (w - 1), y, y + (h - 1))
	self.isOwner = true

	if self.mapMesh:getIsMultiTexture() then
		self:getMaterial():setShader(MapMeshSceneNode.MULTITEXTURE_SHADER)
	else
		self:getMaterial():setShader(MapMeshSceneNode.DEFAULT_SHADER)
	end

	self:setBounds(self.mapMesh:getBounds())
end

function MapMeshSceneNode:setMapMesh(mapMesh)
	if self.isOwner then
		if self.mapMesh then
			self.mapMesh:release()
			self.mapMesh = false
		end

		self.isOwner = false
	end

	self.mapMesh = mapMesh or false

	if self.mapMesh and self.mapMesh:getIsMultiTexture() then
		self:getMaterial():setShader(MapMeshSceneNode.MULTITEXTURE_SHADER)
	else
		self:getMaterial():setShader(MapMeshSceneNode.DEFAULT_SHADER)
	end
end

function MapMeshSceneNode:drawMultiTexture(renderer, delta)
	local shader = renderer:getCurrentShader()

	if shader:hasUniform("scape_DiffuseTexture") then
		local texture = self.mapMesh:getTileSetArrayTexture()
		texture:setFilter('nearest', 'nearest')
		shader:send("scape_DiffuseTexture", texture)
	end

	local dataTextures = self.mapMesh:getDataTextures()

	if shader:hasUniform("scape_DataTexture1") then
		dataTextures[1]:setFilter('nearest', 'nearest')
		shader:send("scape_DataTexture1", dataTextures[1])
	end

	if shader:hasUniform("scape_DataTexture2") then
		dataTextures[2]:setFilter('nearest', 'nearest')
		shader:send("scape_DataTexture2", dataTextures[2])
	end

	if shader:hasUniform("scape_DataTexture3") then
		dataTextures[3]:setFilter('nearest', 'nearest')
		shader:send("scape_DataTexture3", dataTextures[3])
	end

	if shader:hasUniform("scape_DataTexture4") then
		dataTextures[4]:setFilter('nearest', 'nearest')
		shader:send("scape_DataTexture4", dataTextures[4])
	end

	if shader:hasUniform("scape_DataTextureSize") then
		shader:send("scape_DataTextureSize", { dataTextures[1]:getWidth(), dataTextures[1]:getHeight() })
	end

	self.mapMesh:draw()
end

function MapMeshSceneNode:draw(renderer, delta)
	local shader = renderer:getCurrentShader()

	if self.mapMesh and self.mapMesh:getIsMultiTexture() then
		self:drawMultiTexture(renderer, delta)
		return
	end

	local texture = self:getMaterial():getTexture(1)
	if shader:hasUniform("scape_DiffuseTexture") and
	   texture and texture:getIsReady()
	then
		texture:getResource():setFilter('nearest', 'nearest')
		shader:send("scape_DiffuseTexture", texture:getResource())
	end

	if self.mapMesh then
		self.mapMesh:draw()
	end
end

return MapMeshSceneNode
