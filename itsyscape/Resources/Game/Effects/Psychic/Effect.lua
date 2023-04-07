--------------------------------------------------------------------------------
-- Resources/Game/Effects/Psychic/Effect.lua
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

-- Slows the foe up to 25% for 60 seconds.
local Psychic = Class(MovementEffect)

Psychic.DURATION = 0.5
Psychic.PULL = 0.5

function Psychic:new(activator)
	MovementEffect.new(self)

	self.activator = activator
end

function Psychic:getBuffType()
	return Effect.BUFF_TYPE_NONE
end

function Psychic:applyToVelocity(velocity)
	local selfPosition = Utility.Peep.getAbsolutePosition(self:getPeep())
	local activatorPosition = Utility.Peep.getAbsolutePosition(self.activator)

	return velocity + (activatorPosition - selfPosition):getNormal() * (Psychic.PULL / Psychic.DURATION)
end

return Psychic
