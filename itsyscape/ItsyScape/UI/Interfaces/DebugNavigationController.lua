--------------------------------------------------------------------------------
-- ItsyScape/UI/DebugNavigationController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local slick = require "slick"
local Class = require "ItsyScape.Common.Class"
local Function = require "ItsyScape.Common.Function"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"
local Peep = require "ItsyScape.Peep.Peep"
local StaticBehavior = require "ItsyScape.Peep.Behaviors.StaticBehavior"
local MovementCortex = require "ItsyScape.Peep.Cortexes.MovementCortex"
local SmartNavMeshPathFinder = require "ItsyScape.World.SmartNavMeshPathFinder"
local Tile = require "ItsyScape.World.Tile"

local DebugNavigationController = Class(Controller)

function DebugNavigationController:new(peep, director)
	Controller.new(self, peep, director)

	self.layers = {}

	local instance = Utility.Peep.getInstance(peep)
	for groupIndex, groupLayers in instance:iterateMapGroups() do
		local mapScript = groupLayers[1] and instance:getMapScriptByLayer(groupLayers[1])
		local resource = mapScript and Utility.Peep.getResource(mapScript)

		if mapScript and resource then
			for localLayer, globalLayer in ipairs(groupLayers) do
				local layer = {
					group = groupIndex,
					resource = resource.name,
					localLayer = localLayer,
					globalLayer = globalLayer
				}

				table.insert(self.layers, layer)
			end
		end
	end
end

function DebugNavigationController:poke(actionID, actionIndex, e)
	if actionID == "select" then
		self:select(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	elseif actionID == "path" then
		self:path(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

local function _marshalUserdata(userdata)
	if not userdata then
		return false
	end

	local result = {}
	for tile in userdata:iterate() do
		local t = Tile(tile:serialize())

		-- We want to include runtime flags.
		-- These do not get serialized.
		for flag in tile:iterateFlags() do
			t:setFlag(flag)
		end

		table.insert(result, t:serialize())
	end
	return result
end

function DebugNavigationController:sendLayer(layerInfo, layer)
	local movement = self:getDirector():getCortex(MovementCortex)
	local mesh, meshBuilder = movement:getNavigationMesh(layer)
	if mesh and meshBuilder then
		local points = mesh.inputPoints
		local edges = mesh.inputEdges
		local triangles = {}

		for _, triangle in ipairs(mesh.triangles) do
			local t = {
				index = triangle.index,

				indices = {
					triangle.triangle[1].index,
					triangle.triangle[2].index,
					triangle.triangle[3].index
				},

				points = { 
					{ triangle.triangle[1].x, triangle.triangle[1].y },
					{ triangle.triangle[2].x, triangle.triangle[2].y },
					{ triangle.triangle[3].x, triangle.triangle[3].y },
				},

				userdata = {
					_marshalUserdata(meshBuilder:getEdgeUserdata(triangle.triangle[1].index, triangle.triangle[2].index)),
					_marshalUserdata(meshBuilder:getEdgeUserdata(triangle.triangle[2].index, triangle.triangle[3].index)),
					_marshalUserdata(meshBuilder:getEdgeUserdata(triangle.triangle[3].index, triangle.triangle[1].index))
				}
			}

			table.insert(triangles, t)
		end

		self:send("showLayer", layerInfo, { points = points, edges = edges, triangles = triangles })
	end
end

function DebugNavigationController:select(e)
	assert(type(e.group) == "number", "map group must be number")
	assert(type(e.localLayer) == "number", "local layer must be number")

	for _, layer in ipairs(self.layers) do
		if layer.group == e.group and layer.localLayer == e.localLayer then
			self:sendLayer(layer, layer.globalLayer)
		end
	end
end

function DebugNavigationController:path(e)
	assert(type(e.group) == "number", "map group must be number")
	assert(type(e.localLayer) == "number", "local layer must be number")
	assert(type(e.startX) == "number" and type(e.startY) == "number", "start xy must be number")
	assert(type(e.endX) == "number" and type(e.endY) == "number", "end xy must be number")

	local globalLayer
	for _, layer in ipairs(self.layers) do
		if layer.group == e.group and layer.localLayer == e.localLayer then
			globalLayer = layer.globalLayer
		end
	end

	if not globalLayer then
		return
	end

	local SmartNavMeshPathFinder = love.filesystem.load("ItsyScape/World/SmartNavMeshPathFinder.lua")()

	local before = love.timer.getTime()
	local pathFinder = SmartNavMeshPathFinder(self:getPeep(), { debug = true })
	local path = pathFinder:find(Vector(e.startX, 0, e.startY), Vector(e.endX, 0, e.endY))
	local after = love.timer.getTime()

	if not path then
		Log.info("Couldn't generate path from (%.2f, %.2f) to (%.2f, %.2f) in %0.2f ms.", e.startX, e.startY, e.endX, e.endY, (after - before) * 1000)
		return
	end

	local result = {}
	for i = 1, path:getNumNodes() do
		local p = path:getNodeAtIndex(i)
		table.insert(result, p.position.x)
		table.insert(result, p.position.z)
	end

	local edges = {}
	local debugInfo = pathFinder:getDebugStats()
	for e in pairs(debugInfo.edges) do
		table.insert(edges, {
			e.a.point.x,
			e.a.point.y,
			e.b.point.x,
			e.b.point.y,
		})
	end

	Log.info("Generated from from (%.2f, %.2f) to (%.2f, %.2f) in %0.2f ms.", e.startX, e.startY, e.endX, e.endY, (after - before) * 1000)

	self:send("showPath", result, { visited = edges })
end

function DebugNavigationController:pull()
	return {
		layers = self.layers
	}
end

return DebugNavigationController
