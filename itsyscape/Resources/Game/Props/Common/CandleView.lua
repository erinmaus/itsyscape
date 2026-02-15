--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/CandleView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Building = require "ItsyScape.Graphics.Building"
local Color = require "ItsyScape.Graphics.Color"
local Decoration = require "ItsyScape.Graphics.Decoration"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local FlameGreeble = require "Resources.Game.Props.Common.Greeble.FlameGreeble"
local FlickerGreeble = require "Resources.Game.Props.Common.Greeble.FlickerGreeble"

local CandleView = Class(PropView)

CandleView.COLORS = {
	Color(1)
}

CandleView.FLAME_SCALE = 0.25

CandleView.INNER_FLAME_COLORS = {
	{ unpack(FlameGreeble.INNER_FLAME_COLORS) }
}

CandleView.OUTER_FLAME_COLORS = {
	{ unpack(FlameGreeble.OUTER_FLAME_COLORS) }
}

CandleView.FLICKER_COLORS = {
	{ unpack(FlameGreeble.OUTER_FLAME_COLORS) }
}

CandleView.MIN_FLICKER_ATTENUATION_SCALE = 2
CandleView.MAX_FLICKER_ATTENUATION_SCALE = 4

CandleView.CANDLE_DECORATION_TILE_SET = "Candles1"
CandleView.DECORATION_RADIUS = 0.3
CandleView.DECORATION_HEIGHT = 0.5

CandleView.MAX_XZ_SCALE = 1
CandleView.MIN_XZ_SCALE = 0.5

CandleView.MIN_Y_SCALE  = 0.25
CandleView.MAX_Y_SCALE  = 1

CandleView.MIN_CANDLES = 1
CandleView.MAX_CANDLES = 5

CandleView.MIN_ADDITIONAL_RADIUS = 0
CandleView.MAX_ADDITIONAL_RADIUS = 0.3

function CandleView:new(...)
	PropView.new(self, ...)

	self.candleSceneNodes = {}
	self.flameGreebles = {}
end

function CandleView:_addCandle(position, scale, rng, building, decoration)
	local groupIndex = rng:random(building:getNumDecorationGroups())
	local group = building:getDecorationGroupByIndex(groupIndex)

	for _, feature in group:iterate() do
		local color = self.COLORS[rng:random(#self.COLORS)]

		decoration:add(feature:getID(), position, Quaternion.IDENTITY, scale, color, 1, feature:getMaterial())
	end

	local flameGreeblePosition = Vector(position.x, scale.y * self.DECORATION_HEIGHT, position.z)
	local flame = self:addGreeble(FlameGreeble, {
		INNER_FLAME_COLORS = self.INNER_FLAME_COLORS[love.math.random(#self.INNER_FLAME_COLORS)],
		OUTER_FLAME_COLORS = self.OUTER_FLAME_COLORS[love.math.random(#self.OUTER_FLAME_COLORS)],
	}, {
		translation = flameGreeblePosition,
		scale = Vector(math.max(scale.x, scale.z) * self.FLAME_SCALE)
	})

	table.insert(self.flameGreebles, flame)
end

function CandleView:_load()
	for _, greeble in ipairs(self.flameGreebles) do
		self:removeGreeble(greeble)
	end

	self.flameGreebles = {}

	if self.flickerGreeble then
		self:removeGreeble(self.flickerGreeble)
	end

	local position = self:getProp():getPosition()
	local a, b = math.floor(position.x * 32), math.floor(position.z * 32)
	local rng = love.math.newRandomGenerator(a, b)

	local building = Building(string.format("Resources/Game/TileSets/%s/Building.lua", self.CANDLE_DECORATION_TILE_SET))
	local decoration = Decoration()

	local numCandles = rng:random(self.MIN_CANDLES, self.MAX_CANDLES)
	local candleSizes = {}
	local radius = 0
	local height = 0
	for i = 1, numCandles do
		local xzScale = math.lerp(self.MIN_XZ_SCALE, self.MAX_XZ_SCALE, rng:random())
		local yScale = math.lerp(self.MIN_Y_SCALE, self.MAX_Y_SCALE, rng:random())

		radius = math.max(radius, xzScale * self.DECORATION_RADIUS)
		height = math.max(height, yScale * self.DECORATION_HEIGHT)

		table.insert(candleSizes, Vector(xzScale, yScale, xzScale))
	end

	radius = radius + math.lerp(self.MIN_ADDITIONAL_RADIUS, self.MAX_ADDITIONAL_RADIUS, rng:random())

	local attenuationScale = math.lerp(self.MIN_FLICKER_ATTENUATION_SCALE, self.MAX_FLICKER_ATTENUATION_SCALE, rng:random())
	self.flickerGreeble = self:addGreeble(FlickerGreeble, {
		OFFSET = Vector(0, height, 0),
		MIN_ATTENUATION = attenuationScale * self.DECORATION_RADIUS,
		MAX_ATTENUATION = attenuationScale * radius,
		COLORS = self.FLICKER_COLORS[rng:random(#self.FLICKER_COLORS)]
	})

	local angle = rng:random() * math.pi * 2

	for i = 1, numCandles do
		local angle = (i - 1) / numCandles * math.pi * 2 + angle
		local x = math.cos(angle) * radius
		local y = math.sin(angle) * radius

		self:_addCandle(Vector(x, 0, y), candleSizes[i], rng, building, decoration)
	end

	local baseMaterials = building:getMaterials()
	local decorationsByMaterial = {}
	for feature in decoration:iterate() do
		local material = feature:getMaterial()

		local g = decorationsByMaterial[material]
		if not g then
			g = Decoration()
			decorationsByMaterial[material] = g
		end

		g:push(feature)
	end

	for _, sceneNode in ipairs(self.candleSceneNodes) do
		sceneNode:setParent()
	end

	self.candleSceneNodes = {}
	local candleSceneNodes = self.candleSceneNodes

	self:getResources():queue(
		StaticMeshResource,
		string.format("Resources/Game/TileSets/%s/Layout.lstatic", self.CANDLE_DECORATION_TILE_SET),
		function(mesh)
			for materialName, subDecoration in pairs(decorationsByMaterial) do
				if candleSceneNodes ~= self.candleSceneNodes then
					return
				end

				local sceneNode = DecorationSceneNode()
				sceneNode:fromDecoration(subDecoration, mesh:getResource())
				sceneNode:setParent(self:getRoot())

				local material = baseMaterials[materialName]
				if material then
					material:apply(sceneNode, self:getResources())
				end

				table.insert(self.candleSceneNodes, sceneNode)
			end
		end)
end

function CandleView:_tryLoad()
	local currentX, _, currentZ = self:getProp():getPosition():get()
	if not (self.currentX == currentX and self.currentZ == currentZ) then
		self.currentX = currentX
		self.currentZ = currentZ
		self:_load()
	end
end

function CandleView:updateTransform()
	PropView.updateTransform(self)
	self:_tryLoad()
end

return CandleView
