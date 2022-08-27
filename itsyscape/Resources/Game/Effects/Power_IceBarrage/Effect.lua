--------------------------------------------------------------------------------
-- Resources/Game/Effects/Power_IceBarrage/Effect.lua
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
local Effect = require "ItsyScape.Peep.Effect"
local MovementEffect = require "ItsyScape.Peep.Effects.MovementEffect"

-- Slows the foe for 30 - 60 seconds, based on wisdom level. Caps at level 70.
local IceBarrage = Class(MovementEffect)
IceBarrage.SPEED_DEBUFF = 0.5
IceBarrage.MIN_LEVEL = 30
IceBarrage.MAX_LEVEL = 70
IceBarrage.MIN_DURATION = 30
IceBarrage.MAX_DURATION = 60

function IceBarrage:new(activator)
	MovementEffect.new(self)

	local level = activator:getState():count(
		"Skill",
		"Wisdom",
		{ ['skill-as-level'] = true })

	local delta = math.min((level - IceBarrage.MIN_LEVEL) / IceBarrage.MAX_LEVEL, 1)
	local duration = delta * (IceBarrage.MAX_DURATION - IceBarrage.MIN_DURATION) + IceBarrage.MIN_DURATION

	self:setDuration(duration)
end

function IceBarrage:getBuffType()
	return Effect.BUFF_TYPE_NEGATIVE
end

function IceBarrage:applyToVelocity(velocity)
	return velocity * IceBarrage.SPEED_DEBUFF
end

return IceBarrage
