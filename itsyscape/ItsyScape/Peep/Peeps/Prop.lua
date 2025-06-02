--------------------------------------------------------------------------------
-- ItsyScape/Peep/Peeps/Prop.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StaticBehavior = require "ItsyScape.Peep.Behaviors.StaticBehavior"

local Prop = Class(Peep)

function Prop:new(resource, ...)
	Peep.new(self, ...)

	self:addBehavior(PropReferenceBehavior)
	self:addBehavior(PositionBehavior)
	self:addBehavior(RotationBehavior)
	self:addBehavior(ScaleBehavior)
	self:addBehavior(SizeBehavior)
	self:addBehavior(StaticBehavior)
	
	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 1, 1)

	Utility.Peep.setResource(self, resource)

	self:addPoke('spawnedByAction')
	self:addPoke('spawnedByPeep')
end

function Prop:spawnOrPoofTile(tile, i, j, mode)
	if mode == 'spawn' then
		tile:pushFlag('impassable')
	elseif mode == 'poof' then
		tile:popFlag('impassable')
	end
end

function Prop:spawnOrPoof(mode)
	local game = self:getDirector():getGameInstance()
	local position = self:getBehavior(PositionBehavior)
	local size = self:getBehavior(SizeBehavior)
	if position then
		local map = self:getDirector():getMap(position.layer or 1)
		if map then
			local transform = Utility.Peep.getTransform(self)
			local p = position.position
			local halfSize
			do
				local min, max = Vector.transformBounds(Vector.ZERO, size.size, transform)
				halfSize = (max - min) / 2
			end

			local rotation = Utility.Peep.getRotation(self)
			local polygon = {
				rotation:transformVector(Vector(-size.size.x / 2, 0, -size.size.z / 2)) + p,
				rotation:transformVector(Vector(size.size.x / 2, 0, -size.size.z / 2)) + p,
				rotation:transformVector(Vector(size.size.x / 2, 0, size.size.z / 2)) + p,
				rotation:transformVector(Vector(-size.size.x / 2, 0, size.size.z / 2)) + p
			}

			for x = p.x - halfSize.x, p.x + halfSize.x, map:getCellSize() do
				for z = p.z - halfSize.z, p.z + halfSize.z, map:getCellSize() do
					local p = Vector(x, 0, z)
					local tile, i, j = map:getTileAt(x, z)
					local center = map:getTileCenter(i, j)

					local inside = true
					local side
					for u = 1, #polygon do
						local v = (u % #polygon) + 1

						local s = MathCommon.side(polygon[u], polygon[v], center)
						side = side or s
						if side ~= s then
							inside = false
							break
						end
					end

					if inside then
						Log.info(">>> impassable %s %d %d", self:getName(), i, j)
						self:spawnOrPoofTile(tile, i, j, mode)
					else
						Log.info(">>> passable %s %d %d", self:getName(), i, j)
						Log.info("center %d %d", center.x, center.z)
						Log.info("polygon: %s", Log.dump(polygon))
					end
				end
			end
		end
	end
end

function Prop:onFinalize(director, game)
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)
	if mapObject or resource then
		local gameDB = game:getGameDB()
		local sizeRecord
		if mapObject then
			sizeRecord = gameDB:getRecord("MapObjectSize", { MapObject = mapObject })
		end

		if not sizeRecord and resource then
			sizeRecord = gameDB:getRecord("MapObjectSize", { MapObject = resource })
		end

		if sizeRecord then
			local size = self:getBehavior(SizeBehavior)
			size.size = Vector(
				sizeRecord:get("SizeX") or size.size.x,
				sizeRecord:get("SizeY") or size.size.y,
				sizeRecord:get("SizeZ") or size.size.z)
			size.offset = Vector(
				sizeRecord:get("OffsetX") or size.offset.x,
				sizeRecord:get("OffsetY") or size.offset.y,
				sizeRecord:get("OffsetZ") or size.offset.z)
			size.pan = Vector(
				sizeRecord:get("PanX") or size.pan.x,
				sizeRecord:get("PanY") or size.pan.y,
				sizeRecord:get("PanZ") or size.pan.z)
			size.zoom = sizeRecord:get("Zoom") or size.zoom
		end
	end

	Utility.Peep.setNameMagically(self)
	self:spawnOrPoof('spawn')
end

function Prop:onReaper()
	self:spawnOrPoof('poof')
end

function Prop:getPropState()
	return {}
end

return Prop
