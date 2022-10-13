--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/BuildingConstructor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Constructor = require "ItsyScape.Game.Skills.Antilogika.Constructor"
local NoiseBuilder = require "ItsyScape.Game.Skills.Antilogika.NoiseBuilder"

local RiverConstructor = Class(Constructor)
RiverConstructor.START_ANGLE = -math.pi / 8
RiverConstructor.STOP_ANGLE  = math.pi * 2 + math.pi / 8

RiverConstructor.IMPASSABLE_ANGLE_MIN = math.pi / 4
RiverConstructor.IMPASSABLE_ANGLE_MAX = math.pi * 2 - math.pi / 4

RiverConstructor.SPAN_VERTICAL   = 1
RiverConstructor.SPAN_HORIZONTAL = 2
RiverConstructor.MAX_SPANS       = 2

RiverConstructor.SUB_TILE_SIZE = 2

RiverConstructor.DEFAULT_PROPS = {
	span = { min = 8, max = 13 },
	spanModifier = { min = 0, max = 3 },
	elevation = { min = 4, max = 6 },
	bridgeWidth = 2,
	underwaterFlat = "sand",
	bridgeFlat = "wood",
	bridgeEdge = "wood",
	waterTexture = "PurpleFoamyWater1"
}

function RiverConstructor:getSplitIJ()
	local spanType = self:getRNG():random(RiverConstructor.MAX_SPANS)
	if spanType == RiverConstructor.SPAN_VERTICAL then
		return 0, 1
	elseif spanType == RiverConstructor.SPAN_HORIZONTAL then
		return 1, 0
	end

	return 0, 0
end

function RiverConstructor:getMaxLengthSpan(splitI, splitJ, map)
	if splitI ~= 0 then
		return map:getWidth() * RiverConstructor.SUB_TILE_SIZE
	elseif splitJ ~= 0 then
		return map:getHeight() * RiverConstructor.SUB_TILE_SIZE
	end

	return 0
end

function RiverConstructor:getCenterIJ(splitI, splitJ, span, map)
	if splitI ~= 0 then
		return math.floor(map:getWidth() / 2) * RiverConstructor.SUB_TILE_SIZE - math.floor(span / 2), 0
	elseif splitJ ~= 0 then
		return 0, math.floor(map:getHeight() / 2) * RiverConstructor.SUB_TILE_SIZE - math.floor(span / 2)
	end

	return 0
end

function RiverConstructor:getWaterProps(splitI, splitJ, span, elevation, map, props)
	if splitI ~= 0 then
		return {
			texture = props.waterTexture or RiverConstructor.DEFAULT_PROPS.waterTexture,
			i = math.floor(map:getWidth() / 2) - math.floor(span / RiverConstructor.SUB_TILE_SIZE / 2) + 2,
			j = 1,
			width = math.floor(span / RiverConstructor.SUB_TILE_SIZE),
			height = map:getHeight(),
			y = elevation - 0.5
		}
	elseif splitJ ~= 0 then
		return {
			texture = props.waterTexture or RiverConstructor.DEFAULT_PROPS.waterTexture,
			i = 1,
			j = math.floor(map:getHeight() / 2) - math.floor(span / RiverConstructor.SUB_TILE_SIZE / 2) + 2,
			width = map:getWidth(),
			height = math.floor(span / RiverConstructor.SUB_TILE_SIZE),
			y = elevation - 0.5
		}
	end

	return nil
end

function RiverConstructor:placeRiver(map, mapScript, water)
	local props = water.props or RiverConstructor.DEFAULT_PROPS
	local span = self:getRNG():random(
		(props.span and props.span.min) or RiverConstructor.DEFAULT_PROPS.span.min,
		(props.span and props.span.max) or RiverConstructor.DEFAULT_PROPS.span.max)
	if span % 2 ~= 0 then
		span = span + 1
	end
	span = span * RiverConstructor.SUB_TILE_SIZE

	local spanModifierMin = (props.spanModifier and props.spanModifier.min) or RiverConstructor.DEFAULT_PROPS.spanModifier.min
	local spanModifierMax = (props.spanModifier and props.spanModifier.max) or RiverConstructor.DEFAULT_PROPS.spanModifier.max
	local elevation = self:getRNG():random(
		(props.elevation and props.elevation.min) or RiverConstructor.DEFAULT_PROPS.elevation.min,
		(props.elevation and props.elevation.max) or RiverConstructor.DEFAULT_PROPS.elevation.max)

	local noiseOffset = Vector(self:getRNG():random(), self:getRNG():random(), self:getRNG():random())
	local noiseBuilder = NoiseBuilder.TERRAIN {
		offset = { noiseOffset:get() }
	}

	local splitI, splitJ = self:getSplitIJ()
	local centerI, centerJ = self:getCenterIJ(splitI, splitJ, span, map)
	local maxLengthSpan = self:getMaxLengthSpan(splitI, splitJ, map)

	local spanMiddleMin = math.floor(maxLengthSpan / 2) - (props.bridgeWidth or RiverConstructor.DEFAULT_PROPS.bridgeWidth) * RiverConstructor.SUB_TILE_SIZE
	local spanMiddleMax = math.floor(maxLengthSpan / 2) + (props.bridgeWidth or RiverConstructor.DEFAULT_PROPS.bridgeWidth) * RiverConstructor.SUB_TILE_SIZE

	local tileSets = {}

	for currentSpan = 1, maxLengthSpan - RiverConstructor.SUB_TILE_SIZE do
		local maxWidthSpanOffset = math.floor(((noiseBuilder:sample1D(currentSpan / maxLengthSpan) + 1) / 2) * (spanModifierMax - spanModifierMin) + spanModifierMin)
		maxWidthSpanOffset = maxWidthSpanOffset * RiverConstructor.SUB_TILE_SIZE

		for currentOffset = -maxWidthSpanOffset, span + maxWidthSpanOffset, 2 do

			for subOffset = -1, 0 do
				local globalS = (1 - splitI) * currentSpan + splitI * (currentOffset + subOffset) + centerI
				local globalT = (1 - splitJ) * currentSpan + splitJ * (currentOffset + subOffset) + centerJ

				local tileI = math.floor(globalS / RiverConstructor.SUB_TILE_SIZE)
				local tileJ = math.floor(globalT / RiverConstructor.SUB_TILE_SIZE)

				local subTileS = globalS % RiverConstructor.SUB_TILE_SIZE
				local subTileT = globalT % RiverConstructor.SUB_TILE_SIZE

				local mapTile = map:getTile(tileI + 1, tileJ + 1)
				local cornerName = mapTile:getCornerName(subTileS + 1, subTileT + 1)

				local y
				local angle
				do
					local delta = (currentOffset / (span + maxWidthSpanOffset * 2))
					if currentSpan >= spanMiddleMin and currentSpan < spanMiddleMax then
						angle = 0
						y = elevation + math.sin(delta * math.pi)
					else
						angle = delta * (RiverConstructor.STOP_ANGLE - RiverConstructor.START_ANGLE) + RiverConstructor.START_ANGLE
						y = elevation * math.cos(angle)
					end
				end

				mapTile[cornerName] = y

				local tileSet = tileSets[mapTile.tileSetID] or MultiTileSet({ mapTile.tileSetID }, false):getTileSetByIndex(1)
				if currentSpan >= spanMiddleMin and currentSpan < spanMiddleMax then
					mapTile:setFlag("building")
					mapTile.flat = tileSet:getTileIndex(props.bridgeFlat or RiverConstructor.DEFAULT_PROPS.bridgeFlat)
					mapTile.edge = tileSet:getTileIndex(props.bridgeEdge or RiverConstructor.DEFAULT_PROPS.bridgeEdge)
				elseif angle > RiverConstructor.IMPASSABLE_ANGLE_MIN and angle < RiverConstructor.IMPASSABLE_ANGLE_MAX then
					mapTile:setFlag("impassable")
					mapTile.flat = tileSet:getTileIndex(props.underwaterFlat or RiverConstructor.DEFAULT_PROPS.underwaterFlat)
				end
				tileSets[mapTile.tileSetID] = tileSet
			end
		end
	end

	local stage = mapScript:getDirector():getGameInstance():getStage()
	local waterProps = self:getWaterProps(splitI, splitJ, span, elevation, map, props)
	if waterProps then
		stage:flood("Antilogika_River", waterProps, mapScript:getLayer())
	end
end

function RiverConstructor:place(map, mapScript)
	self:placeRiver(map, mapScript, {})
end

return RiverConstructor
