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
local Decoration = require "ItsyScape.Graphics.Decoration"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMesh = require "ItsyScape.Graphics.StaticMesh"

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

function DecorationSceneNode:fromGroup(staticMesh, group)
	local decoration = Decoration({
		tileSetID = "anonymous",
		{ id = group }
	})

	self:fromDecoration(decoration, staticMesh)
end

function DecorationSceneNode:fromLerp(staticMesh, from, to, delta)
	local decoration1 = Decoration({
		tileSetID = "anonymous",
		{ id = from }
	})

	local min1, max1, vertices1
	if self._previousFromVertices and self._previousFromVertices.name == from then
		min1, max1, vertices1 = unpack(self._previousFromVertices)
	else
		min1, max1, vertices1 = self:_generateVertices(decoration1, staticMesh)
		self._previousFromVertices = { name = from, min1, max1, vertices1 }
	end

	local decoration2 = Decoration({
		tileSetID = "anonymous",
		{ id = to }
	})
	
	local min2, max2, vertices2
	if self._previousToVertices and self._previousToVertices.name == from then
		min2, max2, vertices2 = unpack(self._previousToVertices)
	else
		min2, max2, vertices2 = self:_generateVertices(decoration2, staticMesh)
		self._previousToVertices = { name = from, min2, max2, vertices2 }
	end

	if #vertices1 ~= #vertices2 then
		return false
	end

	local vertices
	if not self._previousVertices or #self._previousVertices ~= #vertices1 then
		vertices = {}
		for i = 1, #vertices1 do
			vertices[i] = {}
		end

		self._previousVertices = vertices
	else
		vertices = self._previousVertices 
	end 

	local min = min1:lerp(min2, delta)
	local max = max1:lerp(max2, delta)
	for i = 1, #vertices1 do
		local v1 = vertices1[i]
		local v2 = vertices2[i]

		local v = vertices[i]
		for j = 1, #v1 do
			v[j] = v1[j] + (v2[j] - v1[j]) * delta 
		end
	end

	self:_generateMesh(min, max, vertices)
end

function DecorationSceneNode:_generateVertices(decoration, staticMesh)
	local min, max = Vector(math.huge), Vector(-math.huge)

	local vertices = {}
	local transform = love.math.newTransform()
	local inverseTranspose = love.math.newTransform()
	for feature in decoration:iterate() do
		do
			transform:reset()
			inverseTranspose:reset()

			local position = feature:getPosition()
			transform:translate(position.x, position.y, position.z)

			local rotation = feature:getRotation()
			transform:applyQuaternion(
				rotation.x,
				rotation.y,
				rotation.z,
				rotation.w)
			inverseTranspose:applyQuaternion(
				rotation.x,
				rotation.y,
				rotation.z,
				rotation.w)

			local scale = feature:getScale()
			transform:scale(
				scale.x,
				scale.y,
				scale.z)
			inverseTranspose:scale(
				scale.x,
				scale.y,
				scale.z)

			inverseTranspose = inverseTranspose:inverseTranspose()
		end

		local group = feature:getID()

		-- Assumes indices 1-3 are vertex positions. Bad.
		-- Also assumes indices 4-6 are vertex normals. And also bad.
		-- Lastly, assumes indices 9-12 are color. Ugh.
		if staticMesh:hasGroup(group) then
			local groupVertices = staticMesh:getVertices(group)
			for i = 1, #groupVertices do
				local v = { unpack(groupVertices[i]) }
				v[1], v[2], v[3] = transform:transformPoint(v[1], v[2], v[3])
				v[4], v[5], v[6] = inverseTranspose:transformPoint(v[4], v[5], v[6])
				do
					local l = 1 / math.sqrt(v[4] * v[4] + v[5] * v[5] + v[6] * v[6])
					v[4] = v[4] * l
					v[5] = v[5] * l
					v[6] = v[6] * l
				end

				v[9], v[10], v[11], v[12] = feature:getColor():get()

				local p = Vector(v[1], v[2], v[3])
				min = min:min(p)
				max = max:max(p)

				table.insert(vertices, v)
			end
		end
	end

	return min, max, vertices
end

function DecorationSceneNode:_generateMesh(min, max, vertices)
	if self.isOwner and self.mesh then
		self.mesh:release()
	end

	if #vertices > 0 then
		local format = StaticMesh.DEFAULT_FORMAT
		self.mesh = love.graphics.newMesh(format, vertices, 'triangles', 'static')	
		for _, element in ipairs(format) do
			self.mesh:setAttributeEnabled(element[1], true)
		end

		self.isOwner = true
		self:setBounds(min, max)
	else
		self:setBounds(Vector(0), Vector(0))
	end
end

function DecorationSceneNode:fromDecoration(decoration, staticMesh)
	local min, max, vertices = self:_generateVertices(decoration, staticMesh)
	self:_generateMesh(min, max, vertices)
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
		love.graphics.draw(self.mesh)
	end
end

return DecorationSceneNode
