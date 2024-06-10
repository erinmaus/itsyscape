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

function SplineSceneNode:fromSpline(decoration, staticMesh)
	table.clear(self.vertices)

	for i = 1, spline:getNumFeatures() do
		local feature = spline:getFeatureByIndex(i)

		if staticMesh:hasGroup(feature:getID()) then
			local vertices = staticMesh:getVertices(feature:getID())
			for i = 1, #vertices, 1 do
				local v = vertices[i]
				v = staticMesh:getCurve():transform(Vector(unpack(v, 1, 3)))

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

				table.insert(vertices, {
					v.x, v.y, v.z,
					nx, ny, nz,
					tx, ty, tz,
					cr, cg, cb, ca
				})
			end
		end

		if coroutine.isrunning() then
			coroutine.yield()
		end
	end

	if #vertices >= 3 then
		self.mesh = love.graphics.newMesh(SplineSceneNode.MESH_FORMAT, self.vertices, 'triangles', 'static')
	end
end

return SplineSceneNode
