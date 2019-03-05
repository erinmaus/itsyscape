--------------------------------------------------------------------------------
-- Resources/Game/Effects/Power_Confuse/Effect.lua
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

-- Lowers accuracy 10-30%, depending on Wisdom level, capping at level 50.
local Confuse = Class(CombatEffect)
Confuse.DURATION = 30

function Confuse:new(activator)
	CombatEffect.new(self)

	local level = activator:getState():count(
		"Skill",
		"Wisdom",
		{ ['skill-as-level'] = true })

	self.accuracyDebuff = 1 - (math.min(level / 50 * 20, 20) + 10) / 100
end

function Confuse:getBuffType()
	return Effect.BUFF_TYPE_NEGATIVE
end

function Confuse:applySelfToAttack(roll)
	local attackRoll = roll:getMaxAttackRoll() * self.accuracyDebuff
	roll:setMaxAttackRoll(attackRoll)
end

return Confuse
