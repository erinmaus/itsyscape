--------------------------------------------------------------------------------
-- Resources/Game/Effects/Power_Deflect/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local Effect = require "ItsyScape.Peep.Effect"

-- Deflect 50% of all damage received back on the attacker
local Deflect = Class(Effect)
Deflect.MIN_LEVEL = 20
Deflect.MAX_LEVEL = 50
Deflect.MIN_DURATION = 15
Deflect.MAX_DURATION = 30
Deflect.DEFLECT = 0.5

function Deflect:new(activator)
	Effect.new(self)

	local level = activator:getState():count(
		"Skill",
		"Defense",
		{ ['skill-as-level'] = true })

	local duration = (level - Deflect.MIN_LEVEL) / (Deflect.MAX_LEVEL - Deflect.MIN_LEVEL)
	duration = math.min(math.max(duration, 0), 1)
	duration = duration * (Deflect.MAX_DURATION - Deflect.MIN_DURATION) + Deflect.MIN_DURATION
	self:setDuration(duration)
end

function Deflect:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function Deflect:enchant(peep)
	Effect.enchant(self, peep)

	self._onHit = function(_, p)
		local damage = p:getDamage()
		local aggressor = p:getAggressor()

		local damage = math.floor(damage * Deflect.DEFLECT + 0.5),

		aggressor:poke('receiveAttack', AttackPoke({
			attackType = 'deflect',
			damageType = 'deflect',
			damage = damage,
			aggressor = peep
		}))

		Log.info("Deflected %d damage to '%s' from '%s'.", damage, aggressor:getName(), peep:getName())
	end

	peep:listen('hit', self._onHit)
end

function Deflect:sizzle()
	self:getPeep():silence('hit', self._onHit)
	Effect.sizzle(self)
end

return Deflect
