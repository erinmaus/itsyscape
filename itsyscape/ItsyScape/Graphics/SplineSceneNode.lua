--------------------------------------------------------------------------------
-- ItsyScape/Graphics/SplineSceneNode.lua
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

local SplineSceneNode = Class(SceneNode)

SplineSceneNode.MESH_FORMAT = {
	{ 'VertexPosition', 'float', 3 },
	{ 'VertexNormal', 'float', 3 },
	{ 'VertexTexture', 'float', 3 },
	{ 'VertexColor', 'float', 4 }
}

SplineSceneNode.DEFAULT_SHADER = ShaderResource()
do
	SplineSceneNode.DEFAULT_SHADER:loadFromFile("Resources/Shaders/StaticModel")
end

function SplineSceneNode:new()
	SceneNode.new(self)

	self.vertices = {}

	self:getMaterial():setShader(SplineSceneNode.DEFAULT_SHADER)
end

function SplineSceneNode:fromSpline(spline, staticMesh)
	table.clear(self.vertices)

	local min, max = Vector(math.huge), Vector(-math.huge)
	for i = 1, spline:getNumFeatures() do
		local feature = spline:getFeatureByIndex(i)

		if staticMesh:hasGroup(feature:getID()) then
			local vertices = staticMesh:getVertices(feature:getID())
			for i = 1, #vertices, 1 do
				local v = vertices[i]
				local p = feature:getCurve():transform(Vector(unpack(v, 1, 3)))

				local nx, ny, nz = unpack(v, 4, 6)
				local tx, ty = unpack(v, 7, 8)
				local tz = feature:getTexture() - 1

				local cr, cg, cb, ca = unpack(v, 9, 13)
				cr = cr or 1
				cg = cg or 1
				cb = cb or 1
				ca = ca or 1

				local c = feature:getColor()
				cr = cr * c.r
				cg = cg * c.g
				cb = cb * c.b
				ca = ca * c.a

				min = min:min(p)
				max = max:max(p)

				table.insert(self.vertices, {
					p.x, p.y, p.z,
					nx, ny, nz,
					tx, ty, tz,
					cr, cg, cb, ca
				})
			end
		end

		if coroutine.running() then
			coroutine.yield()
		end
	end

	if #self.vertices >= 3 then
		self.mesh = love.graphics.newMesh(SplineSceneNode.MESH_FORMAT, self.vertices, 'triangles', 'static')
		self:setBounds(min, max)
	else
		self.mesh = nil
	end
end

function SplineSceneNode:draw(renderer)
	local shader = renderer:getCurrentShader()
	local diffuse = self:getMaterial():getTexture(1)
	if shader:hasUniform("scape_DiffuseTexture") and
	   diffuse and diffuse:getIsReady()
	then
		diffuse:getResource(renderer:getCurrentPass():getID()):setFilter('nearest', 'nearest')
		shader:send("scape_DiffuseTexture", diffuse:getResource())
	end

	if self.mesh then
		love.graphics.draw(self.mesh)
	end
end

return SplineSceneNode