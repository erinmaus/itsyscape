--------------------------------------------------------------------------------
-- Resources/Peeps/Props/Valve.lua
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
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"

local Valve = Class(Prop)
Valve.VERTICAL   = "vertical"
Valve.HORIZONTAL = "horizontal"
Valve.NONE       = "none"

function Valve:new(...)
	Prop.new(self, ...)

	self:addPoke('rotate')

	self.currentRotation = Quaternion.IDENTITY
end

function Valve:onRotate(p)
	-- The rotate action adds the rotation behavior, but we don't want the whole prop to rotate.
	-- The prop view takes the rotation from prop state and rotates the valve only.
	self:removeBehavior(RotationBehavior)

	self.currentRotation = self.currentRotation * p.rotation
end

function Valve:getDirection()
	local v = self.currentRotation:transformVector(Vector(1, 0, 0))
	if math.abs(v.x) > 0 then
		return Valve.HORIZONTAL
	elseif math.abs(v.z) > 0 then
		return Valve.VERTICAL
	end
	
	return Valve.NONE
end

function Valve:getPropState()
	return { rotation = { self.currentRotation:get() } }
end

return Valve
