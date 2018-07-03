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
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"

local DecorationSceneNode = Class(SceneNode)
DecorationSceneNode.DEFAULT_SHADER = ShaderResource()
do
	DecorationSceneNode.DEFAULT_SHADER:loadFromFile("Resources/Shaders/StaticModel")
end

function DecorationSceneNode:new()
	SceneNode.new(self)

	self.mesh = false
	self.isOwner = false

	self:getMaterial():setShader(DecorationSceneNode.DEFAULT_SHADER)
end

function DecorationSceneNode:fromDecoration(decoration, staticMesh)
	if self.isOwner and self.mesh then
		self.mesh:release()
	end

	local vertices = {}
	local transform = love.math.newTransform()
	for feature in decoration:iterate() do
		do
			transform:reset()

			local position = feature:getPosition()
			transform:translate(position.x, position.y, position.z)

			local rotation = feature:getRotation()
			transform:applyQuaternion(
				rotation.x,
				rotation.y,
				rotation.z,
				rotation.w)

			local scale = feature:getScale()
			transform:scale(
				scale.x,
				scale.y,
				scale.z)
		end

		-- Assumes indices 1-3 are vertex positions. Bad.
		if staticMesh:hasGroup(group) then
			local group = staticMesh:getVertices(group)
			for i = 1, #group do
				local v = { unpack(group[i]) }
				v[1], v[2], v[3] = transform:transformPoint(v[1], v[2], v[3])

				table.insert(vertices, v)
			end
		end
	end

	local format = staticMesh:getFormat()
	self.mesh = love.graphics.newMesh(format, vertices, 'triangles', 'static')	
	for _, element in ipairs(format) do
		format:setAttributeEnabled(element[1], true)
	end

	self.isOwner = true
end

function DecorationSceneNode:draw(renderer, delta)
	local shader = renderer:getCurrentShader()
	local texture = self:getMaterial():getTexture(1)
	if shader:hasUniform("scape_DiffuseTexture") and
	   texture and texture:getIsReady()
	then
		texture:getResource():setFilter('nearest', 'nearest')
		shader:send("scape_DiffuseTexture", texture:getResource())
	end

	if self.mesh then
		self.mesh:draw()
	end
end

return DecorationSceneNode
