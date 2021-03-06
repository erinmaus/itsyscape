--------------------------------------------------------------------------------
-- Resources/Game/EffectsMagicImmunity/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Effect = require "ItsyScape.Peep.Effect"
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"

-- Prevents damage from all magic attacks.
local MagicImmunity = Class(CombatEffect)

function MagicImmunity:new(activator)
	CombatEffect.new(self)
end

function MagicImmunity:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function MagicImmunity:applyTargetToDamage(roll)
	local _, _, style = roll:getWeapon():getSkill(Weapon.PURPOSE_KILL)
	if style == "Magic" then
		roll:setMaxHit(0)
		roll:setMinHit(0)
	end
end

return MagicImmunity
