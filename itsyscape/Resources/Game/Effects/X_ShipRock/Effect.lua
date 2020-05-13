--------------------------------------------------------------------------------
-- Resources/Game/Effects/X_ShipRock/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Effect = require "ItsyScape.Peep.Effect"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"

local ShipRock = Class(Effect)
ShipRock.DURATION = 5

function ShipRock:new(...)
	Effect.new(self, ...)

	self.rotation = Quaternion.IDENTITY
end

function ShipRock:getBuffType()
	return Effect.BUFF_TYPE_NONE
end

function ShipRock:update(delta)
	Effect.update(self, delta)

	local peep = self:getPeep()
	if peep then
		local rotation = peep:getBehavior(RotationBehavior)
		if rotation then
			local delta = self:getDuration() / self.DURATION
			local mu = delta * math.pi * 4
			local angle = math.sin(mu) * math.pi / 32
			self.rotation = Quaternion.fromAxisAngle(
				Vector.UNIT_X,
				angle)

			rotation.rotation = rotation.rotation * self.rotation
		end
	end
end

return ShipRock
