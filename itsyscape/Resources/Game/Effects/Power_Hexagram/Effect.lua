--------------------------------------------------------------------------------
-- Resources/Game/Effects/Power_Hexagram/Effect.lua
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

-- Binds the foe to the hexagram for 30 - 60 levels based on Wisdom level.
local Hexagram = Class(MovementEffect)
Hexagram.DURATION = 30
Hexagram.DISTANCE = 4.5

function Hexagram:new(activator)
	local level = activator:getState():count(
		"Skill",
		"Wisdom",
		{ ['skill-as-level'] = true })

	local width = math.min(math.max(level - 20, 0), 40)
	local percent = width / 40
	self.DURATION = percent * 30 + 30

	MovementEffect.new(self)
end

function Hexagram:getBuffType()
	return Effect.BUFF_TYPE_NEGATIVE
end

function Hexagram:enchant(peep)
	MovementEffect.enchant(self, peep)
	self.center = Utility.Peep.getAbsolutePosition(peep)
end

function Hexagram:applyToVelocity(velocity)
	local currentPosition = Utility.Peep.getAbsolutePosition(self:getPeep())
	local centerPosition = self.center

	local distance = (currentPosition - centerPosition):getLength()
	local delta = 1 - (math.min(distance, Hexagram.DISTANCE) / Hexagram.DISTANCE)

	return velocity * delta
end

return Hexagram
