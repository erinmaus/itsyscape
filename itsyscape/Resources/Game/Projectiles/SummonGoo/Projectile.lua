--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/SummonGoo/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Actor = require "ItsyScape.Game.Model.Actor"
local Prop = require "ItsyScape.Game.Model.Prop"
local Color = require "ItsyScape.Graphics.Color"
local Projectile = require "ItsyScape.Graphics.Projectile"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local MapMeshSceneNode = require "ItsyScape.Graphics.MapMeshSceneNode"
local Map = require "ItsyScape.World.Map"
local MapMeshIslandProcessor = require "ItsyScape.World.MapMeshIslandProcessor"
local TileSet = require "ItsyScape.World.TileSet"
local MapMeshMask = require "ItsyScape.World.MapMeshMask"

local SummonGoo = Class(Projectile)

SummonGoo.DURATION = 2

SummonGoo.ALPHA_MULTIPLIER = 1.75

SummonGoo.GOO_OFFSET = 0.125

SummonGoo.GOO_FLAT = 2
SummonGoo.NIL_FLAT = 1
SummonGoo.NIL_EDGE = 1

SummonGoo.BUBBLE_CHANCE = 0.2
SummonGoo.BUBBLE_OFFSET = 0.5

SummonGoo.LIGHT_COLOR = Color.fromHexString("BFF251")

function SummonGoo:getDuration()
	return SummonGoo.DURATION
end

function SummonGoo:load()
	Projectile.load(self)

	local resources = self:getResources()

	self.mask = MapMeshMask()

	resources:queueEvent(
		function()
			self.tileSet, self.texture = TileSet.loadFromFile(
				"Resources/Game/TileSets/SummonGoo/Layout.lua",
				true)
		end)
end

function SummonGoo:tick()
	Projectile.tick(self)

	if not (self.tileSet and self.texture) then
		return
	end

	if self.mapMesh then
		return
	end

	local i, j, size
	do
		local gameView = self:getGameView()
		local destination = self:getDestination()

		local destinationI, destinationJ, destinationK
		local mapWidth, mapHeight

		if Class.isCompatibleType(destination, Actor) or Class.isCompatibleType(destination, Prop) then
			local min, max = destination:getBounds()
			destinationI, destinationJ, destinationK = destination:getTile()

			mapWidth = math.max(math.ceil(max.x - min.x), 1)
			mapHeight = math.max(math.ceil(max.z - min.z), 1)

			self.lightOffset = Vector(0, (max.y - min.y) / 2, 0)
		elseif Class.isCompatibleType(destination, Vector) then
			local source = self:getSource()

			if not (Class.isCompatibleType(source, Actor) or Class.isCompatibleType(source, Prop)) then
				return
			end

			local _, _, k = source:getTile()
			local map = gameView:getMap(k)
			if map then
				local _, i, j = map:getTileAt(destination.x, destination.z)
				destinationI, destinationJ, destinationK = i, j, k
			end

			mapWidth = 3
			mapHeight = 3

			self.lightOffset = Vector(0, 1.5, 0)
		else
			return
		end

		self.lightAttenuation = math.max(mapWidth, mapHeight) * 2

		local map = gameView:getMap(destinationK)
		if not map then
			return
		end

		local gooMap = Map(mapWidth * 2 + 1, mapHeight * 2 + 1, map:getCellSize())

		local gooCircle1I, gooCircle1J, gooCircle1Radius =
			love.math.random(-math.ceil(mapWidth / 4), math.ceil(mapWidth / 4)),
			love.math.random(-math.ceil(mapHeight / 4), math.ceil(mapHeight / 4)),
			love.math.random(2, math.max(mapWidth, mapHeight) / 4) ^ 2
		local gooCircle2I, gooCircle2J, gooCircle2Radius =
			love.math.random(-math.ceil(mapWidth / 4), math.ceil(mapWidth / 4)),
			love.math.random(-math.ceil(mapHeight / 4), math.ceil(mapHeight / 4)),
			love.math.random(2, math.max(mapWidth, mapHeight) / 4) ^ 2

		for i = -mapWidth, mapWidth do
			for j = -mapHeight, mapHeight do
				local gooMapI = i + mapWidth + 1
				local gooMapJ = j + mapHeight + 1

				local mapI = i + destinationI
				local mapJ = j + destinationJ

				local mapTile = map:getTile(mapI, mapJ)
				local gooTile = gooMap:getTile(gooMapI, gooMapJ)

				gooTile.topLeft = mapTile.topLeft
				gooTile.topRight = mapTile.topRight
				gooTile.bottomLeft = mapTile.bottomLeft
				gooTile.bottomRight = mapTile.bottomRight

				local inside1 = ((i - gooCircle1I) ^ 2 + (j - gooCircle1J) ^ 2) <= gooCircle1Radius
				local inside2 = ((i - gooCircle2I) ^ 2 + (j - gooCircle2J) ^ 2) <= gooCircle2Radius

				if inside1 or inside2 then
					gooTile.flat = SummonGoo.GOO_FLAT

					if love.math.random() <= SummonGoo.BUBBLE_CHANCE then
						gameView:fireProjectile("HexLab_VatBubbles", map:getTileCenter(mapI, mapJ), Vector(0, SummonGoo.BUBBLE_OFFSET, 0))
					end
				else
					gooTile.flat = SummonGoo.NIL_FLAT
				end

				gooTile.edge = SummonGoo.NIL_EDGE
			end
		end

		local islandProcessor = MapMeshIslandProcessor(
			gooMap,
			self.tileSet,
			gooCircle1I + mapWidth + 1,
			gooCircle1J + mapHeight + 1)

		self.mapMesh = MapMeshSceneNode()
		self.mapMesh:setParent(self:getRoot())
		self.mapMesh:fromMap(gooMap, self.tileSet, 1, 1, gooMap:getWidth(), gooMap:getHeight(), true, islandProcessor)

		local center = map:getTileCenter(destinationI, destinationJ)

		local gooOffset = Vector(
			center.x - (mapWidth * 2 + 1) / 2 * gooMap:getCellSize(),
			SummonGoo.GOO_OFFSET,
			center.z - (mapWidth * 2 + 1) / 2 * gooMap:getCellSize())
		self.mapMesh:getTransform():setLocalTranslation(gooOffset)

		local material = self.mapMesh:getMaterial()
		material:setColor(Color(1, 1, 1, 0))
		material:setIsTranslucent(true)
		material:setTextures(self.texture, self.mask:getTexture())

		self.light = PointLightSceneNode()
		self.light:setAttenuation(0)
		self.light:setColor(SummonGoo.LIGHT_COLOR)
		self.light:getTransform():setLocalTranslation(self.lightOffset + center * Vector.PLANE_XZ)
		self.light:setParent(self:getRoot())

		self:resetTime()
	end
end

function SummonGoo:update(elapsed)
	Projectile.update(self, elapsed)

	if not self.mapMesh then
		return
	end

	local delta = self:getDelta()
	local alpha = math.abs(math.sin(delta * math.pi)) * SummonGoo.ALPHA_MULTIPLIER
	alpha = math.min(alpha, 1)

	self.mapMesh:getMaterial():setColor(Color(1, 1, 1, alpha))
	self.light:setAttenuation(alpha * self.lightAttenuation)
end

return SummonGoo
