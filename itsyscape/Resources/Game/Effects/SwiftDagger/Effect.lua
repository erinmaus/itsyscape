--------------------------------------------------------------------------------
-- Resources/Game/Effects/SwiftDagger/Effect.lua
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

local SwiftDagger = Class(CombatEffect)

SwiftDagger.MIN_LEVEL = 20
SwiftDagger.MAX_LEVEL = 40
SwiftDagger.MIN_BOOST = 0.1
SwiftDagger.MAX_BOOST = 0.2

function SwiftDagger:new()
	CombatEffect.new(self)
end

function SwiftDagger:getBoost()
	local state = self:getPeep():getState()
	local faithLevel = state:count("Skill", "Faith", { ['skill-as-level'] = true })
	return Utility.Combat.calcBoost(faithLevel, self.MIN_LEVEL, self.MAX_LEVEL, self.MIN_BOOST, self.MAX_BOOST)
end

function SwiftDagger:getDescription()
	return string.format("%d%%", self:getBoost() * 100)
end

function SwiftDagger:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function SwiftDagger:applyToSelfWeaponCooldown(peep, cooldown)
	local weapon = Utility.Peep.getEquippedWeapon(peep, true)
	if weapon and weapon:getStyle() == Weapon.STYLE_MELEE then
		local result = cooldown * (1 - self:getBoost())
		return result
	end

	return cooldown
end

return SwiftDagger
