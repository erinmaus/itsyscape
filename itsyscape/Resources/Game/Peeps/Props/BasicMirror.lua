--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicMirror.lua
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
local MirrorBehavior = require "ItsyScape.Peep.Behaviors.MirrorBehavior"

local BasicMirror = Class(Prop)

function BasicMirror:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2.5, 4, 2.5)

	self:addPoke('rotate')
	self:addPoke('lightHit')
	self:addPoke('lightFade')

	self.hitCount = 0

	self:addBehavior(MirrorBehavior)
end

function BasicMirror:onFinalize(...)
	Prop.onFinalize(self, ...)

	local rotation = self:getBehavior(RotationBehavior)
	do
		local angle = (math.random(1, 4) - 1) * (math.pi / 2)
		rotation.rotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, angle)
	end
end

function BasicMirror:onLightHit()
	self.hitCount = self.hitCount + 1
end

function BasicMirror:onLightFade()
	self.hitCount = math.max(self.hitCount - 1, 0)
end

function BasicMirror:isLit()
	return self.hitCount > 0
end

function BasicMirror:getPropState()
	return { lit = self.hitCount > 0 }
end

return BasicMirror
