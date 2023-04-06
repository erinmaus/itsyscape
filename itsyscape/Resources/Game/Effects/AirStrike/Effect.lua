--------------------------------------------------------------------------------
-- Resources/Game/Effects/AirStrike/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Effect = require "ItsyScape.Peep.Effect"
local MovementEffect = require "ItsyScape.Peep.Effects.MovementEffect"

-- Pushes the opponent away by 0.25 units over 0.25 seconds or
-- 0.5 units over 0.5 seconds.
local AirStrike = Class(MovementEffect)

AirStrike.DURATION_WEAK   = 0.25
AirStrike.DURATION_STRONG = 0.5

AirStrike.PULL_WEAK   = 0.25
AirStrike.PULL_STRONG = 0.5

function AirStrike:new(activator)
	MovementEffect.new(self)

	self.activator = activator

	self:boost(false)
end

function AirStrike:getBuffType()
	return Effect.BUFF_TYPE_NONE
end

function AirStrike:boost(strong)
	if strong then
		self.pullDuration = self.DURATION_WEAK
		self.pullStrength = self.PULL_WEAK
	else
		self.pullDuration = self.DURATION_STRONG
		self.pullStrength = self.PULL_STRONG
	end

	self:setDuration(self.pullDuration)
end

function AirStrike:applyToVelocity(velocity)
	local selfPosition = Utility.Peep.getAbsolutePosition(self:getPeep())
	local activatorPosition = Utility.Peep.getAbsolutePosition(self.activator)

	return velocity + (selfPosition - activatorPosition):getNormal() * (self.pullStrength / self.pullDuration)
end

return AirStrike
