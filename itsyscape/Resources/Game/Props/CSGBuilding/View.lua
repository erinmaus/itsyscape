--------------------------------------------------------------------------------
-- Resources/Game/Props/CSGBuilding/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local PropView = require "ItsyScape.Graphics.PropView"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local NPOHBuilder = require "nbunny.world.pohbuilder"
local NPOHVolumes = require "nbunny.world.pohvolumes"

local CSGBuilding = Class(PropView)
CSGBuilding.HEIGHT = 2

CSGBuilding.Node = Class(SceneNode)
CSGBuilding.Node.SHADER = ShaderResource()
do
	CSGBuilding.Node.SHADER:loadFromFile("Resources/Shaders/LightBeam")
end

function CSGBuilding.Node:new()
	SceneNode.new(self)

	self:getMaterial():setShader(CSGBuilding.Node.SHADER)

	self.mesh = false
end

function CSGBuilding.Node:setMesh(value)
	self.mesh = value
end

function CSGBuilding.Node:getMesh()
	return self.mesh
end

function CSGBuilding.Node:draw()
	if self.mesh then
		love.graphics.draw(self.mesh)
	end
end

function CSGBuilding:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.csgNode = CSGBuilding.Node()

	resources:queueEvent(
		function()
			self.csgNode:setMesh(self:generate())
			self.csgNode:setParent(root)
		end)
end

function CSGBuilding:cube(builder, volumeType, x, z, width, depth)
	local transform = love.math.newTransform()
	transform:scale(2, 2, 2)
	transform:translate(0.5, CSGBuilding.HEIGHT / 2, 0.5)
	transform:translate(width / 2, 0, depth / 2)
	transform:translate(x, 0, z)
	transform:scale(width / 2, CSGBuilding.HEIGHT / 2, depth / 2)

	builder:cube(volumeType, transform)
end

function CSGBuilding:generate()
	local state = self:getProp():getState()
	local rooms = state.rooms or {}

	local builder = NPOHBuilder()
	self:cube(builder, NPOHVolumes.TYPE_SOLID, state.root.i - 2 + 0.1, state.root.j - 2 + 0.1, state.root.width - 0.2, state.root.depth - 0.2)

	for i = 1, #rooms do
		local room = rooms[i]

		for j = 1, #room.graphs do
			local graph = room.graphs[j]
			self:cube(builder, NPOHVolumes.TYPE_AIR, graph.i - 1 - 0.5, graph.j - 1 - 0.5, graph.width - 2 + 1, graph.depth - 2 + 1)
		end
	end

	return builder:build()
end

return CSGBuilding
