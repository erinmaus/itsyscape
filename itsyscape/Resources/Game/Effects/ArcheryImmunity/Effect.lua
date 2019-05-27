--------------------------------------------------------------------------------
-- Resources/Game/EffectsArcheryImmunity/Effect.lua
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

-- Prevents damage from all archery attacks.
local ArcheryImmunity = Class(CombatEffect)

function ArcheryImmunity:new(activator)
	CombatEffect.new(self)
end

function ArcheryImmunity:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function ArcheryImmunity:applyTargetToDamage(roll)
	local _, _, style = roll:getWeapon():getSkill(Weapon.PURPOSE_KILL)
	if style == "Archery" then
		roll:setMaxHit(0)
		roll:setMinHit(0)
	end
end

return ArcheryImmunity
