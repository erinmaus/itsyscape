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

			local state = self:getProp():getState()
			self.csgNode:setBounds(
				Vector((state.root.i - 2 + 0.1) * 2, 0, (state.root.j - 2 + 0.1) * 2),
				Vector((state.root.i - 2 + 0.1 + state.root.width + 0.1) * 2, CSGBuilding.HEIGHT * 2, (state.root.j - 2 + 0.1 + state.root.width + 0.1)) * 2)
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

function CSGBuilding:cube(builder, volumeType, graph)
	local transform = love.math.newTransform()

	-- Scale to the size of a map cell.
	transform:scale(2, 2, 2)

	-- Translate to (0, 0, 0).
	-- The graph starts at (1, 0, 1) but the world starts at (0, 0, 0).
	transform:translate(-1, 0, -1)

	-- Translate to the top-left corner of the graph.
	transform:translate(graph.i, 0, graph.j)

	-- Scale to the size of the cube.
	transform:scale(graph.width, CSGBuilding.HEIGHT, graph.depth)

	-- Apply.
	builder:cube(volumeType, transform)
end

function CSGBuilding:exterior(builder, volumeType, graph)
	self:cube(builder, volumeType, {
		i = graph.i + 0.1,
		j = graph.j + 0.1,
		width = graph.width - 0.2,
		depth = graph.depth - 0.2
	})
end

function CSGBuilding:interior(builder, volumeType, graph)
	self:cube(builder, volumeType, {
		i = graph.i + 0.25,
		j = graph.j + 0.25,
		width = graph.width - 0.5,
		depth = graph.depth - 0.5
	})
end

function CSGBuilding:wall(builder, volumeType, graph)
	self:cube(builder, volumeType, {
		i = graph.i,
		j = graph.j,
		width = graph.width,
		depth = graph.depth
	})
end

function CSGBuilding:generate()
	local state = self:getProp():getState()
	local rooms = state.rooms or {}

	local builder = NPOHBuilder()
	--self:cube(builder, NPOHVolumes.TYPE_SOLID, state.root.i - 2 + 0.1, state.root.j - 2 + 0.1, state.root.width - 0.2, state.root.depth - 0.2)
	self:exterior(builder, NPOHVolumes.TYPE_SOLID, state.root)

	for i = 1, #rooms do
		local room = rooms[i]

		for j = 1, #room.graphs do
			local graph = room.graphs[j]
			self:interior(builder, NPOHVolumes.TYPE_AIR, graph)
		end

		for j = 1, #room.graphs do
			local a = room.graphs[j]
			for k = j + 1, #room.graphs do
				local b = room.graphs[k]

				local i, j, width, depth
				if a.right == b.left then
					i = a.right - 1
					j = math.max(a.top, b.top)
					width = 2
					depth = math.min(a.bottom, b.bottom) - j
				elseif a.left == b.right then
					i = a.left - 1
					j = math.max(a.top, b.top)
					width = 2
					depth = math.min(a.bottom, b.bottom) - j
				elseif a.bottom == b.top then
					i = math.max(a.left, b.left)
					j = a.bottom - 1
					width = math.min(a.right, b.right) - i
					depth = 2
				elseif a.top == b.bottom then
					i = math.max(a.left, b.left)
					j = a.top - 1
					width = math.min(a.right, b.right) - i
					depth = 2
				end

				if i and j and width and depth and width > 0 and depth > 0 then
					self:interior(builder, NPOHVolumes.TYPE_AIR, {
						i = i,
						j = j,
						width = width,
						depth = depth
					})
				end
			end
		end
	end

	return builder:build()
end

return CSGBuilding
