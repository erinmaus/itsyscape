--------------------------------------------------------------------------------
-- ItsyScape/Graphics/DebugFrustumSceneNode.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SceneNode = require "ItsyScape.Graphics.SceneNode"

local DebugFrustumSceneNode = Class(SceneNode)

DebugFrustumSceneNode.MESH_FORMAT = {
	{ "VertexPosition", 'float', 3 }
}

DebugFrustumSceneNode.VERTICES = {
	-- Front
	{ -1, -1,  1 },
	{  1, -1,  1 },
	{  1,  1,  1 },
	{ -1, -1,  1 },
	{  1,  1,  1 },
	{ -1,  1,  1 },

	-- Back.
	{  1, -1, -1 },
	{ -1, -1, -1 },
	{  1,  1, -1 },
	{  1,  1, -1 },
	{ -1, -1, -1 },
	{ -1,  1, -1 },

	-- Left.
	{ -1, -1, -1 },
	{ -1, -1,  1 },
	{ -1,  1,  1 },
	{ -1,  1, -1 },
	{ -1, -1, -1 },
	{ -1,  1,  1 },

	-- Right.
	{  1,  1,  1 },
	{  1, -1,  1 },
	{  1, -1, -1 },
	{  1,  1,  1 },
	{  1, -1, -1 },
	{  1,  1, -1 },

	-- Top
	{  1,  1, -1 },
	{ -1,  1, -1 },
	{  1,  1,  1 },
	{ -1,  1, -1 },
	{ -1,  1,  1 },
	{  1,  1,  1 },

	-- Bottom.
	{ -1, -1, -1 },
	{  1, -1, -1 },
	{  1, -1,  1 },
	{  1, -1,  1 },
	{ -1, -1,  1 },
	{ -1, -1, -1 },
}

function DebugFrustumSceneNode:fromCamera(camera)
	local projection, view = camera:getTransforms()
	local projectionView = projection * view

	local vertices = {}
	for i = 1, #DebugFrustumSceneNode.VERTICES do
		local vertex = DebugFrustumSceneNode.VERTICES[i]
		vertex = { projectionView:inverseTransformPoint(unpack(vertex)) }

		table.insert(vertices, vertex)
	end

	if self.mesh then
		self.mesh:release()
	end

	self.mesh = love.graphics.newMesh(
		DebugFrustumSceneNode.MESH_FORMAT,
		vertices,
		'triangles',
		'static')
	self.mesh:setAttributeEnabled("VertexPosition", true)
end

function DebugFrustumSceneNode:draw(renderer, delta)
	love.graphics.setMeshCullMode('none')
	love.graphics.setDepthMode('lequal', true)

	love.graphics.setShader()
	love.graphics.setLineWidth(4)
	love.graphics.setWireframe(true)
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.push()
	love.graphics.applyTransform(self:getTransform():getGlobalDeltaTransform(delta))
	love.graphics.draw(self.mesh)
	love.graphics.pop()

	love.graphics.setLineWidth(1)
	love.graphics.setWireframe(false)
end

return DebugFrustumSceneNode
