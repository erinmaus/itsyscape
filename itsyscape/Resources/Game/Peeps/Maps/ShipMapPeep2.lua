--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Maps/ShipMapPeep2.lua
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
local Utility = require "ItsyScape.Game.Utility"
local MapScript = require "ItsyScape.Peep.Peeps.Map"
local MapOffsetBehavior = require "ItsyScape.Peep.Behaviors.MapOffsetBehavior"
local OceanBehavior = require "ItsyScape.Peep.Behaviors.OceanBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"
local ShipStatsBehavior = require "ItsyScape.Peep.Behaviors.ShipStatsBehavior"

local ShipMapScript = Class(MapScript)

function ShipMapScript:new(resource, name, ...)
	MapScript.new(self, resource, name or 'ShipMapScript', ...)

	self:addBehavior(PositionBehavior)
	self:addBehavior(RotationBehavior)

	self:addBehavior(BossStatsBehavior)
	self:addBehavior(ShipMovementBehavior)
	self:addBehavior(ShipStatsBehavior)

	local _, movement = self:addBehavior(MovementBehavior)
	movement.noClip = true

	self:addPoke('hit')
	self:addPoke('sink')
	self:addPoke('sunk')
	self:addPoke('beach')
	self:addPoke('rock')
	self:addPoke('leak')

	self.isBeached = false
end

function ShipMapScript:onLoad(...)
	MapScript.onLoad(self, ...)

	local shipMovement = self:getBehavior(ShipMovementBehavior)
	if shipMovement then
		local map = self:getDirector():getMap(self:getLayer())
		if map then
			shipMovement.length = map:getWidth() * map:getCellSize()
			shipMovement.beam = map:getHeight() * map:getCellSize()
		end
	end
end

function ShipMapScript:_updateRotation()
	local game = self:getDirector():getGameInstance()

	local position = self:getBehavior(PositionBehavior)
	local layer = position and position.layer or self:getLayer()

	local mapScript = Utility.Peep.getInstance(self):getMapScriptByLayer(layer)
	local ocean = mapScript and mapScript:getBehavior(OceanBehavior)

	local windDirection, windSpeed, windPattern = Utility.Map.getWind(game, layer)

	local worldPosition = Utility.Peep.getPosition(self)
	worldPosition = Utility.Map.transformWorldPositionByWave(
		ocean and ocean.time or 0,
		windSpeed * (ocean and ocean.windSpeedMultiplier or 1),
		windDirection,
		windPattern * (ocean and ocean.windPatternMultiplier or Vector(2, 4, 8)),
		Vector(worldPosition.x, -(ocean and ocean.offset or 1), worldPosition.z),
		Vector(worldPosition.x, 0, worldPosition.z))

	local normal = Utility.Map.calculateWaveNormal(
		ocean and ocean.time or 0,
		windSpeed * (ocean and ocean.windSpeedMultiplier or 1),
		windDirection,
		windPattern * (ocean and ocean.windPatternMultiplier or Vector(2, 4, 8)),
		worldPosition - (ocean and ocean.offset / 2 or 0.5),
		worldPosition)

	local playerPeep = Utility.Peep.getInstance(self):getPartyLeader():getActor():getPeep()
	Utility.Peep.setPosition(playerPeep, worldPosition + Vector(0, 0, 0), true)

	--print(">>> (be) time, offset", ocean.time, ocean.offset)
	--print(">>> (be) pattern", windPattern:get())
	--print(">>> (be) ocean pattern", ocean.windPatternMultiplier:get())
	--print(">>> (be) ocean/wind speed", ocean.windSpeedMultiplier, windSpeed)
	--print(">>> (be) dir", windDirection:get())

	local rotation = Quaternion.fromVectors(Vector.UNIT_Y, normal):getNormal()
	--Utility.Peep.setRotation(self, Quaternion.IDENTITY:slerp(rotation, 0.3):getNormal())
	--print(">>> y", worldPosition:get())
	Utility.Peep.setPosition(self, worldPosition + Vector(0, 0, 0))
end

function ShipMapScript:update(director, game)
	MapScript.update(self, director, game)

	self:_updateRotation()
end

return ShipMapScript
