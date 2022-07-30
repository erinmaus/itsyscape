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
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Effect = require "ItsyScape.Peep.Effect"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local MovementEffect = require "ItsyScape.Peep.Effects.MovementEffect"

-- Binds the foe to the hexagram for 30 - 60 levels based on Wisdom level.
local Hexagram = Class(MovementEffect)
Hexagram.DISTANCE = 4.5
Hexagram.PLAYER_DURATION = 10
Hexagram.OTHER_DURATION  = 20 

function Hexagram:new()
	MovementEffect.new(self)
end

function Hexagram:getBuffType()
	return Effect.BUFF_TYPE_NEGATIVE
end

function Hexagram:enchant(peep)
	MovementEffect.enchant(self, peep)
	self.center = Utility.Peep.getAbsolutePosition(peep)

	if peep:hasBehavior(PlayerBehavior) then
		self:setDuration(Hexagram.PLAYER_DURATION)
	else
		self:setDuration(Hexagram.OTHER_DURATION)
	end
end

function Hexagram:applyToPosition(position)
	local difference = (position - self.center)
	local distance = difference:getLength()

	if distance >= Hexagram.DISTANCE then
		local normal = difference:getNormal()
		return normal * Hexagram.DISTANCE + self.center
	else
		return position
	end
end

return Hexagram
