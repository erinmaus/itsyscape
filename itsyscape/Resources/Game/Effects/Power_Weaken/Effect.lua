--------------------------------------------------------------------------------
-- Resources/Game/Effects/Power_Weaken/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Curve = require "ItsyScape.Game.Curve"
local Effect = require "ItsyScape.Peep.Effect"
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"

-- Lowers damage 10-30%, depending on Wisdom level, capping at level 50.
local Weaken = Class(CombatEffect)
Weaken.DURATION = 30

function Weaken:new(activator)
	CombatEffect.new(self)

	local level = activator:getState():count(
		"Skill",
		"Wisdom",
		{ ['skill-as-level'] = true })

	self.damageDebuff = 1 - (math.max(level / 50 * 20, 20) + 10) / 100
end

function Weaken:getBuffType()
	return Effect.BUFF_TYPE_NEGATIVE
end

function Weaken:applySelfToDamage(roll)
	local max, min = roll:getMaxHit(), roll:getMinHit()
	roll:setMaxHit(math.max(max * self.damageDebuff, 1))
	roll:setMinHit(math.max(min * self.damageDebuff, 1))
end

return Weaken
