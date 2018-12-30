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
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local Prop = Class(Peep)

function Prop:new(resource, ...)
	Peep.new(self, ...)

	self:addBehavior(PropReferenceBehavior)
	self:addBehavior(PositionBehavior)
	self:addBehavior(RotationBehavior)
	self:addBehavior(ScaleBehavior)
	self:addBehavior(SizeBehavior)
	
	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 1, 1)

	Utility.Peep.setResource(self, resource)

	self:addPoke('spawnedByAction')
end

function Prop:spawnOrPoofTile(tile, i, j, mode)
	if mode == 'spawn' then
		tile:pushImpassable()
	elseif mode == 'poof' then
		tile:popImpassable()
	end
end

function Prop:spawnOrPoof(mode)
	local game = self:getDirector():getGameInstance()
	local position = self:getBehavior(PositionBehavior)
	local size = self:getBehavior(SizeBehavior)
	if position then
		local map = self:getDirector():getMap(position.layer or 1)
		if map then
			local p = position.position
			local halfSize
			do
				local transform = Utility.Peep.getTransform(self)
				local min, max = Vector.transformBounds(Vector.ZERO, size.size, transform)
				halfSize = (max - min) / 2
			end

			for x = p.x - halfSize.x, p.x + halfSize.x do
				for z = p.z - halfSize.z, p.z + halfSize.z do
					local tile, i, j = map:getTileAt(x, z)

					self:spawnOrPoofTile(tile, i, j, mode)
				end
			end
		end
	end
end

function Prop:ready(director, game)
	Peep.ready(self, director, game)

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
