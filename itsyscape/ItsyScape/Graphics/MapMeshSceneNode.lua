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

local MapMeshSceneNode = Class(SceneNode)

function MapMeshSceneNode:new()
	SceneNode.new(self)

	self.mapMesh = false
	self.isOwner = false
end

function MapMeshSceneNode:fromMap(map, tileSet, x, y, w, h)
	if self.isOwner and self.mapMesh then
		self.mapMesh:release()
	end

	self.mapMesh = MapMesh(map, tileSet, x, y, w, h)
	self.isOwner = true
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
end

function MapMeshSceneNode:draw(renderer, delta)
	local texture = self:getMaterial():getTexture(1)
	if texture and texture:getIsReady() then
		texture = texture:getResource()
	end

	self.mapMesh:draw()
end

return MapMeshSceneNode
