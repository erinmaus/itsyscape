--------------------------------------------------------------------------------
-- ItsyScape/UI/DebugNavigationController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"
local MovementCortex = require "ItsyScape.Peep.Cortexes.MovementCortex"

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
		table.insert(result, tile:serialize())
	end
	return result
end

function DebugNavigationController:sendLayer(layer)
	local movement = self:getDirector():getCortex(MovementCortex)
	local mesh, meshBuilder = movement:getNavigationMesh(layer)
	if mesh and meshBuilder then
		local points = mesh.inputPoints
		local edges = mesh.inputEdges
		local triangles = {}

		for _, triangle in ipairs(mesh.triangles) do
			local t = {
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

		self:send("showLayer", { points = points, edges = edges, triangles = triangles })
	end
end

function DebugNavigationController:select(e)
	assert(type(e.group) == "number", "map group must be number")
	assert(type(e.localLayer) == "number", "local layer must be number")

	for _, layer in ipairs(self.layers) do
		if layer.group == e.group and layer.localLayer == e.localLayer then
			self:sendLayer(layer.globalLayer)
		end
	end
end

function DebugNavigationController:pull()
	return {
		layers = self.layers
	}
end

return DebugNavigationController
