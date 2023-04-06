--------------------------------------------------------------------------------
-- Resources/Game/Effects/SharpMind/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Effect = require "ItsyScape.Peep.Effect"
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"

local SharpMind = Class(CombatEffect)

SharpMind.MIN_LEVEL = 20
SharpMind.MAX_LEVEL = 40
SharpMind.MIN_BOOST = 0.1
SharpMind.MAX_BOOST = 0.2

function SharpMind:new()
	CombatEffect.new(self)
end

function SharpMind:getBoost()
	local state = self:getPeep():getState()
	local faithLevel = state:count("Skill", "Faith", { ['skill-as-level'] = true })
	return Utility.Combat.calcBoost(faithLevel, self.MIN_LEVEL, self.MAX_LEVEL, self.MIN_BOOST, self.MAX_BOOST)
end

function SharpMind:getDescription()
	return string.format("%d%%", self:getBoost() * 100)
end

function SharpMind:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function SharpMind:applyToSelfWeaponCooldown(peep, cooldown)
	local weapon = Utility.Peep.getEquippedWeapon(peep, true)
	if weapon and weapon:getStyle() == Weapon.STYLE_MAGIC then
		local result = cooldown * (1 - self:getBoost())
		return result
	end

	return cooldown
end

return SharpMind
