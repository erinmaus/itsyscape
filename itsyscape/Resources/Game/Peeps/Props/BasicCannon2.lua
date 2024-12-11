--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicCannon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local ICannon = require "ItsyScape.Game.Skills.ICannon"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SailingResourceBehavior = require "ItsyScape.Peep.Behaviors.SailingResourceBehavior"
local BasicSailingItem = require "Resources.Game.Peeps.Props.BasicSailingItem"

local BasicCannon = Class(BasicSailingItem, ICannon)

BasicCannon.DEFAULT_SPEED = 16
BasicCannon.DEFAULT_GRAVITY = Vector(0, -18, 0)
BasicCannon.DEFAULT_DRAG = 0.9
BasicCannon.DEFAULT_TIMESTEP = 1 / 10
BasicCannon.DEFAULT_MAX_STEPS = 100

BasicCannon.DEFAULT_ROTATION = Quaternion.fromAxisAngle(Vector.UNIT_X, math.rad(-15))
BasicCannon.DEFAULT_POSITION = Vector(0, 1.4, 1.5)

BasicCannon.DEFAULT_MIN_X = math.rad(-30)
BasicCannon.DEFAULT_MAX_X = math.rad(30)

BasicCannon.DEFAULT_MIN_Y = math.rad(-30)
BasicCannon.DEFAULT_MAX_Y = math.rad(30)

function BasicCannon:new(...)
	BasicSailingItem.new(self, ...)

	self:addPoke("tilt")
	self:addPoke("fire")

	self.currentRotation = self.DEFAULT_ROTATION
end

function BasicCannon:_getRotation()
	local transform = Utility.Peep.getAbsoluteTransform(self)
	local _, baseRotation = MathCommon.decomposeTransform(transform)

	return (baseRotation * self.currentRotation):getNormal()
end

function BasicCannon:_getPosition(currentRotation)
	local currentRotation = currentRotation or self:_getRotation()
	local currentOffset = currentRotation:transformVector(self.DEFAULT_POSITION)
	local currentPosition = Utility.Peep.getAbsolutePosition(self)

	return currentPosition + currentOffset
end

function BasicCannon:previewTilt(x, y)
	local gameDB = self:getDirector():getGameDB()

	local sailingResource = self:getBehavior(SailingResourceBehavior)
	if not (sailingResource and sailingResource.resource) then
		return
	end

	local minX, maxX
	local minY, maxY
	do
		local cannonRecord = gameDB:getRecord("Cannon", { Resource = sailingResource.resource })
		if cannonRecord then
			minX, maxX = math.rad(cannonRecord:get("MinXRotation"), cannonRecord:get("MaxXRotation"))
			minY, maxY = math.rad(cannonRecord:get("MinYRotation"), cannonRecord:get("MaxYRotation"))
		end
	end

	minX = (not minX or minX == 0) and self.DEFAULT_MIN_X or minX
	maxX = (not maxX or maxX == 0) and self.DEFAULT_MAX_X or maxX

	minY = (not minY or minY == 0) and self.DEFAULT_MIN_Y or minY
	maxY = (not maxY or maxY == 0) and self.DEFAULT_MAX_Y or maxY

	self.currentRotation = Quaternion.fromEulerXYZ(
		math.lerp(minX, maxX, x),
		math.lerp(minY, maxY, y),
		0)
end

function BasicCannon:onFire(ammo, path, duration)
	local gameDB = self:getDirector():getGameDB()

	local mapScript = Utility.Peep.getMapScript(self)
	local mapScriptPosition = mapScript and mapScript:getBehavior(PositionBehavior)
	local parentLayer = mapScriptPosition and mapScriptPosition.layer or Utility.Peep.getInstance(self):getBaseLayer()
	local parentMapScript = Utility.Peep.getInstance(self):getMapScriptByLayer(parentLayer)

	local ammoItemResource
	if type(ammo) == "string" then
		ammoItemResource = gameDB:getResource(ammo, "Item")
	else
		ammoItemResource = ammo
	end

	if not ammoItemResource then
		return
	end

	local ammoItemMappingRecord = gameDB:getRecord("ItemSailingItemMapping", { Item = ammoItemResource })
	if not ammoItemMappingRecord then
		return
	end

	local ammoSailingItemResource = ammoItemMappingRecord:get("SailingItem")
	local ammoPropRecord = gameDB:getRecord("ShipSailingItemPropHotspot", {
		Slot = "Cannonball",
		ItemGroup = "Cannonball",
		SailingItem = ammoItemMappingRecord:get("SailingItem")
	})

	if not ammoPropRecord then
		return
	end

	local ammoPropResource = ammoPropRecord:get("Prop")

	local cannonballProp = Utility.spawnPropAtPosition(parentMapScript, ammoPropResource, self:getCannonPosition():get())
	if not cannonballProp then
		return
	end

	cannonballProp:getPeep():listen("ready", function(peep)
		peep:poke("launch", path, duration)
	end)
end

function BasicCannon:getCannonDirection()
	return self:_getRotation()
end

function BasicCannon:getCannonPosition()
	return self:_getPosition()
end

function BasicCannon:getPropState()
	local propState = BasicSailingItem.getPropState(self)
	propState.rotation = { self.currentRotation:get() }

	return propState
end

return BasicCannon
