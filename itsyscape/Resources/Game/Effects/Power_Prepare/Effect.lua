--------------------------------------------------------------------------------
-- Resources/Game/Effects/Power_Prepare/Effect.lua
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

-- Prevents 50%-100% of damage from the next attack.
local Prepare = Class(CombatEffect)
Prepare.DURATION = math.huge

function Prepare:new(activator)
	CombatEffect.new(self)

	local level = activator:getState():count(
		"Skill",
		"Wisdom",
		{ ['skill-as-level'] = true })

	self.damageMultiplier = 1 - (math.min(level / 50, 0.5) + 0.5)
end

function Prepare:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function Prepare:applyTargetToDamage(roll)
	roll:setMaxHit(math.floor(roll:getMaxHit() * self.damageMultiplier))
	roll:setMinHit(math.floor(roll:getMinHit() * self.damageMultiplier))

	self:getPeep():removeEffect(self)
end

return Prepare
