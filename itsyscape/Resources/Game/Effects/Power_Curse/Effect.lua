--------------------------------------------------------------------------------
-- Resources/Game/Effects/Power_Curse/Effect.lua
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
local Curse = Class(CombatEffect)
Curse.DURATION = 30

function Curse:new(activator)
	CombatEffect.new(self)

	local level = activator:getState():count(
		"Skill",
		"Wisdom",
		{ ['skill-as-level'] = true })

	self.defenseDebuff = 1 - (math.max(level / 50 * 20, 20) + 10) / 100
end

function Curse:getBuffType()
	return Effect.BUFF_TYPE_NEGATIVE
end

function Curse:applyTargetToAttack(roll)
	local defenseRoll = roll:getMaxDefenseRoll() * self.defenseDebuff
	roll:setMaxDefenseRoll(defenseRoll)
end

return Curse
