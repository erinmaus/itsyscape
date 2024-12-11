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
local SailingResourceBehavior = require "ItsyScape.Peep.Behaviors.SailingResourceBehavior"
local BasicSailingItem = require "Resources.Game.Peeps.Props.BasicSailingItem"

local BasicCannon = Class(BasicSailingItem, ICannon)

BasicCannon.DEFAULT_SPEED = 16
BasicCannon.DEFAULT_GRAVITY = Vector(0, -18, 0)
BasicCannon.DEFAULT_DRAG = 0.9
BasicCannon.DEFAULT_TIMESTEP = 1 / 10
BasicCannon.DEFAULT_MAX_STEPS = 100

BasicCannon.DEFAULT_ROTATION = Quaternion.fromAxisAngle(Vector.UNIT_X, math.rad(15))
BasicCannon.DEFAULT_POSITION = Vector(0, 1.4, -1.5)

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

function BasicCannon:previewTilt(rotation)
	self.currentRotation = rotation
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
