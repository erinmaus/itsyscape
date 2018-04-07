--------------------------------------------------------------------------------
-- ItsyScape/Graphics/DebugCubeSceneNode.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SceneNode = require "ItsyScape.Graphics.SceneNode"

local DebugCubeSceneNode = Class(SceneNode)

DebugCubeSceneNode.MESH_FORMAT = {
	{ "VertexPosition", 'float', 3 },
	{ "VertexNormal", 'float', 3 },
	{ "VertexColor", 'float', 4 }
}


DebugCubeSceneNode.MESH_DATA = {
	-- Front.
	{ -1, -1,  1, 0, 0, 1, 1.0, 0.0, 0.0, 1.0 },
	{  1, -1,  1, 0, 0, 1, 1.0, 0.0, 0.0, 1.0 },
	{  1,  1,  1, 0, 0, 1, 1.0, 0.0, 0.0, 1.0 },
	{ -1, -1,  1, 0, 0, 1, 1.0, 0.0, 0.0, 1.0 },
	{  1,  1,  1, 0, 0, 1, 1.0, 0.0, 0.0, 1.0 },
	{ -1,  1,  1, 0, 0, 1, 1.0, 0.0, 0.0, 1.0 },

	-- Back.
	{  1, -1, -1, 0, 0, -1, 0.0, 1.0, 0.0, 1.0 },
	{ -1, -1, -1, 0, 0, -1, 0.0, 1.0, 0.0, 1.0 },
	{  1,  1, -1, 0, 0, -1, 0.0, 1.0, 0.0, 1.0 },
	{  1,  1, -1, 0, 0, -1, 0.0, 1.0, 0.0, 1.0 },
	{ -1, -1, -1, 0, 0, -1, 0.0, 1.0, 0.0, 1.0 },
	{ -1,  1, -1, 0, 0, -1, 0.0, 1.0, 0.0, 1.0 },

	-- Left.
	{ -1, -1, -1, -1, 0, 0, 0.0, 0.0, 1.0, 1.0 },
	{ -1, -1,  1, -1, 0, 0, 0.0, 0.0, 1.0, 1.0 },
	{ -1,  1,  1, -1, 0, 0, 0.0, 0.0, 1.0, 1.0 },
	{ -1,  1, -1, -1, 0, 0, 0.0, 0.0, 1.0, 1.0 },
	{ -1, -1, -1, -1, 0, 0, 0.0, 0.0, 1.0, 1.0 },
	{ -1,  1,  1, -1, 0, 0, 0.0, 0.0, 1.0, 1.0 },

	-- Right.
	{  1,  1,  1, 1, 0, 0, 1.0, 0.0, 1.0, 1.0 },
	{  1, -1,  1, 1, 0, 0, 1.0, 0.0, 1.0, 1.0 },
	{  1, -1, -1, 1, 0, 0, 1.0, 0.0, 1.0, 1.0 },
	{  1,  1,  1, 1, 0, 0, 1.0, 0.0, 1.0, 1.0 },
	{  1, -1, -1, 1, 0, 0, 1.0, 0.0, 1.0, 1.0 },
	{  1,  1, -1, 1, 0, 0, 1.0, 0.0, 1.0, 1.0 },

	-- Top
	{  1,  1, -1, 0, -1, 0, 1.0, 1.0, 0.0, 1.0 },
	{ -1,  1, -1, 0, -1, 0, 1.0, 1.0, 0.0, 1.0 },
	{  1,  1,  1, 0, -1, 0, 1.0, 1.0, 0.0, 1.0 },
	{ -1,  1, -1, 0, -1, 0, 1.0, 1.0, 0.0, 1.0 },
	{ -1,  1,  1, 0, -1, 0, 1.0, 1.0, 0.0, 1.0 },
	{  1,  1,  1, 0, -1, 0, 1.0, 1.0, 0.0, 1.0 },

	-- Bottom.
	{ -1, -1, -1, 0, 1, 0, 1.0, 0.5, 0.0, 1.0 },
	{  1, -1, -1, 0, 1, 0, 1.0, 0.5, 0.0, 1.0 },
	{  1, -1,  1, 0, 1, 0, 1.0, 0.5, 0.0, 1.0 },
	{  1, -1,  1, 0, 1, 0, 1.0, 0.5, 0.0, 1.0 },
	{ -1, -1,  1, 0, 1, 0, 1.0, 0.5, 0.0, 1.0 },
	{ -1, -1, -1, 0, 1, 0, 1.0, 0.5, 0.0, 1.0 },
}

function DebugCubeSceneNode:new()
	SceneNode.new(self)

	self.mesh = love.graphics.newMesh(
		DebugCubeSceneNode.MESH_FORMAT,
		DebugCubeSceneNode.MESH_DATA,
		'triangles',
		'static')
	self.mesh:setAttributeEnabled("VertexPosition", true)
	self.mesh:setAttributeEnabled("VertexNormal", true)
	self.mesh:setAttributeEnabled("VertexColor", true)
end

function DebugCubeSceneNode:draw(renderer, delta)
	love.graphics.draw(self.mesh)
end

return DebugCubeSceneNode
