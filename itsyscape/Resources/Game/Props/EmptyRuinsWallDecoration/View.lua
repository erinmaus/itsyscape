--------------------------------------------------------------------------------
-- Resources/Game/Props/EmptyRuinsWallDecoration/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local Decoration = require "ItsyScape.Graphics.Decoration"
local PropView = require "ItsyScape.Graphics.PropView"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"

local EmptyRuinsWallDecoration = Class(PropView)

EmptyRuinsWallDecoration.MIN_NUM_ATTEMPTS = 2
EmptyRuinsWallDecoration.MAX_NUM_ATTEMPTS = 4

EmptyRuinsWallDecoration.NUM_FEATURES = 3

EmptyRuinsWallDecoration.OFFSET = 1 / 32
EmptyRuinsWallDecoration.DISTANCE_BETWEEN_FEATURES = math.sqrt(3)

EmptyRuinsWallDecoration.WOOD_COLOR  = Color.fromHexString("4e5583")
EmptyRuinsWallDecoration.STONE_COLOR = Color.fromHexString("39273f")

EmptyRuinsWallDecoration.WOOD_SCALE  = Vector(1.5, 1, 1)
EmptyRuinsWallDecoration.STONE_SCALE = Vector(1, 1, 1)

function EmptyRuinsWallDecoration:load(...)
	PropView.load(self, ...)

	self.decoration = Decoration({ tileSetID = "EmptyRuins" })
end

function EmptyRuinsWallDecoration:_initBricks()
	local rng = love.math.newRandomGenerator()

	self:getResources():queueEvent(function()
		local gameView = self:getGameView()
		local decorations = gameView:getDecorations()
		local staticMeshes = gameView:getDecorationMeshes()
		local walls = {}

		for name, decoration in pairs(decorations) do
			local layer = gameView:getDecorationLayer(decoration)
			if decoration:getTileSetID():match("EmptyRuinsSkull") and staticMeshes[name] and layer then
				Log.info("Found '%s' to brick-ify.", name)

				table.insert(walls, { decoration = decoration, name = name, layer = layer })
			end
		end

		table.sort(decorations, function(a, b)
			return a.name < b.name
		end)

		for _, d in ipairs(walls) do
			local decoration = d.decoration
			local name = d.name
			local layer = d.layer

			local triangles = {}

			for feature in decoration:iterate() do
				if feature:getID():match("skull") then
					feature:map(function(v1, v2, v3, normal) 
						if (math.abs(normal.x) > math.abs(normal.y) or math.abs(normal.z) > math.abs(normal.y))then
							table.insert(triangles, { vertices = { v1, v2, v3 }, normal = normal })
						end
					end, staticMeshes[name]:getResource())

					coroutine.yield()
				end
			end

			if #triangles > 0 then
				local numBricks = rng:random(EmptyRuinsWallDecoration.MIN_NUM_ATTEMPTS, EmptyRuinsWallDecoration.MAX_NUM_ATTEMPTS) * decoration:getNumFeatures()
				local bricks = {}
				for i = 1, numBricks do
					local a = (rng:random() + 1) / 4
					local b = (rng:random() + 1) / 4

					local triangle = triangles[rng:random(#triangles)]

					if a + b > 1 then
						a = 1 - a
						b = 1 - b
					end

					local v1 = triangle.vertices[1] - triangle.vertices[3]
					local v2 = triangle.vertices[2] - triangle.vertices[3]

					local p = a * v1 + b * v2 + triangle.vertices[3]

					local isValid = true
					for _, position in ipairs(bricks) do
						local distance = (position - p):getLength()
						if distance < EmptyRuinsWallDecoration.DISTANCE_BETWEEN_FEATURES then
							isValid = false
							break
						end
					end

					local rotation
					do
						local x = triangle.normal.x
						local z = triangle.normal.z

						if x > 0 then
							rotation = Quaternion.Y_90
						elseif x < 0 then
							rotation = -Quaternion.Y_90
						elseif z > 0 then
							rotation = Quaternion.IDENTITY
						else -- z < 0 or a catch all case if somehow a +Y normal slipped through
							rotation = Quaternion.Y_180
						end

						rotation = (rotation * -Quaternion.X_90):getNormal()
					end

					local index = rng:random(EmptyRuinsWallDecoration.NUM_FEATURES)

					local color, scale
					do
						if decoration:getTileSetID():match("Wood") then
							color = EmptyRuinsWallDecoration.WOOD_COLOR
							scale = EmptyRuinsWallDecoration.WOOD_SCALE
						else
							color = EmptyRuinsWallDecoration.STONE_COLOR
							scale = EmptyRuinsWallDecoration.STONE_SCALE
						end
					end

					if isValid then
						local brickFeatureName = string.format("brick%d", index)

						local mapSceneNode = gameView:getMapSceneNode(layer)
						if mapSceneNode then
							local translation = mapSceneNode:getTransform():getLocalTranslation()

							self.decoration:add(
								brickFeatureName,
								p + translation + triangle.normal * EmptyRuinsWallDecoration.OFFSET,
								rotation,
								scale,
								color)
							table.insert(bricks, p)
						end
					end

					coroutine.yield()
				end
			end
		end

		local _, layer = self:getProp():getPosition()
		gameView:decorate("x-empty-ruins-skull-wall", self.decoration, layer)

		self.isLoading = false
		self.isLoaded = true
	end)
end

function EmptyRuinsWallDecoration:tick()
	PropView.tick(self)

	if not self.isLoading and not self.isLoaded then
		self.isLoading = true
		self:_initBricks()
	end
end

return EmptyRuinsWallDecoration
