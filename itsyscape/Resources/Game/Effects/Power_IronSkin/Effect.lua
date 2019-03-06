--------------------------------------------------------------------------------
-- Resources/Game/Effects/Power_IronSkin/Effect.lua
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

-- Prevents damage from the next melee attack.
local IronSkin = Class(CombatEffect)
IronSkin.DURATION = 10

function IronSkin:new(activator)
	CombatEffect.new(self)

	local level = activator:getState():count(
		"Skill",
		"Defense",
		{ ['skill-as-level'] = true })

	self.damageMultiplier = (1 - math.min(level / 50, 1)) * 0.5 + 0.5
end

function IronSkin:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function IronSkin:applySelfToDamage(roll)
	roll:setMaxHit(math.floor(roll:getMaxHit() * self.damageMultiplier + 0.5))
	roll:setMinHit(math.floor(roll:getMinHit() * self.damageMultiplier + 0.5))
end

function IronSkin:applyTargetToDamage(roll)
	roll:setMaxHit(0)
	roll:setMinHit(0)
end

return IronSkin
