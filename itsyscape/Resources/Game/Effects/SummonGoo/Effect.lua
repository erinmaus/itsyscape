--------------------------------------------------------------------------------
-- Resources/Game/Effects/SummonGoo/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Effect = require "ItsyScape.Peep.Effect"
local MovementEffect = require "ItsyScape.Peep.Effects.MovementEffect"

-- Slows the foe up to 25% for 60 seconds.
local SummonGoo = Class(MovementEffect)

SummonGoo.DURATION = 60

SummonGoo.INTERVAL = 0.05
SummonGoo.MAX_DEBUFF = 0.25

function SummonGoo:new()
	MovementEffect.new(self)

	self.percent = SummonGoo.INTERVAL
end

function SummonGoo:boost()
	self.percent = math.min(SummonGoo.INTERVAL + self.percent, SummonGoo.MAX_DEBUFF)
	self:setDuration(SummonGoo.DURATION)

	Log.info("Increased summon goo debuff to %d%%.", self.percent * 100)
end

function SummonGoo:getBuffType()
	return Effect.BUFF_TYPE_NEGATIVE
end

function SummonGoo:applyToVelocity(velocity)
	return velocity * (1 - self.percent)
end

return SummonGoo
