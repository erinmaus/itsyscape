--------------------------------------------------------------------------------
-- Resources/Game/Powers/Meditate/Power.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CombatPower = require "ItsyScape.Game.CombatPower"
local Utility = require "ItsyScape.Game.Utility"
local Effect = require "ItsyScape.Peep.Effect"
local MovementEffect = require "ItsyScape.Peep.Effects.MovementEffect"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"

local Meditate = Class(CombatPower)

function Meditate:activate(activator, target)
	CombatPower.activate(self, activator, target)

	local movementEffects = {}
	for effect in activator:getEffects() do
		local isDebuff = effect:getBuffType() == Effect.BUFF_TYPE_NEGATIVE
		local isMovementEffect = Class.isCompatibleType(effect, MovementEffect)
		if isDebuff and isMovementEffect then
			table.insert(movementEffects, effect)
		end
	end

	for i = 1, #movementEffects do
		activator:removeEffect(movementEffects[i])
	end

	activator:removeBehavior(AttackCooldownBehavior)

	Log.info("Removed %d movement debuffs on '%s'.", #movementEffects, activator:getName())
end

return Meditate
