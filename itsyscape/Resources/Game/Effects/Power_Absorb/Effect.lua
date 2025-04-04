--------------------------------------------------------------------------------
-- Resources/Game/Effects/Power_Absorb/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"

-- Damage taken over the next 10 seconds heals you 150%-300%.
local Absorb = Class(Effect)
Absorb.DURATION = 10

function Absorb:new(activator)
	Effect.new(self)

	self.damage = 0

	local level = activator:getState():count(
		"Skill",
		"Defense",
		{ ['skill-as-level'] = true })

	self.damageMultiplier = (math.min(level / 50, 1.5) + 1.5)
end

function Absorb:getDescription()
	return string.format("%d%%", math.floor(self.damageMultiplier * 100))
end

function Absorb:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function Absorb:applyTargetToAttack(attackRoll)
	attackRoll:setAlwaysHits(true)
end

function Absorb:applyTargetToDamage(roll)
	roll:setDamageMultiplier(-self.damageMultiplier)
end

return Absorb
