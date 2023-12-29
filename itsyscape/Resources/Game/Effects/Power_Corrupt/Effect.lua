--------------------------------------------------------------------------------
-- Resources/Game/Effects/Power_Corrupt/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local Effect = require "ItsyScape.Peep.Effect"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

-- Deals 100%-300% damage over 10 seconds scaling with wisdom level, capping at
-- level 55.
local Corrupt = Class(Effect)
Corrupt.DURATION = 12
Corrupt.INTERVAL = 2

function Corrupt:new(activator)
	Effect.new(self)

	self.tick = Corrupt.INTERVAL
	self.aggressor = activator
end

function Corrupt:getBuffType()
	return Effect.BUFF_TYPE_NEGATIVE
end

function Corrupt:enchant(peep)
	Effect.enchant(self, peep)

	local level = self.aggressor:getState():count(
		"Skill",
		"Wisdom",
		{ ['skill-as-level'] = true })

	local weapon = Utility.Peep.getEquippedWeapon(self.aggressor, true)
	if weapon then
		local damageRoll = weapon:rollDamage(self.aggressor, Weapon.PURPOSE_KILL, peep)
		damageRoll:setMinHit(damageRoll:getMaxHit() + 1)
		damageRoll:setMaxHit(damageRoll:getMaxHit() + 1)

		local maxHit = damageRoll:roll()
		local multiplier = math.min(math.max(level - 5, 0) / 50, 2) + 1

		self.damage = math.floor(maxHit * multiplier * damageRoll:getDamageMultiplier())
	else
		self.damage = 0
	end

	self.damageRemaining = math.floor(self.damage / (Corrupt.DURATION / Corrupt.INTERVAL) + 0.5) * (Corrupt.DURATION / Corrupt.INTERVAL)
end

function Corrupt:update(delta)
	Effect.update(self, delta)

	self.tick = self.tick - delta
	if self.tick < 0 then
		local damage = math.max(math.floor(self.damage / (Corrupt.DURATION / Corrupt.INTERVAL) + 0.5), 1)

		local attack = AttackPoke({
			damage = damage,
			aggressor = self.aggressor
		})

		local peep = self:getPeep()
		if peep then
			peep:poke('receiveAttack', attack)

			local actor = peep:getBehavior(ActorReferenceBehavior)
			if actor and actor.actor then
				actor = actor.actor

				local animation = CacheRef(
					"ItsyScape.Graphics.AnimationResource",
					"Resources/Game/Animations/Power_Corrupt/Script.lua")
				actor:playAnimation(
					'x-effect-corrupt', 1, animation)
			end
		end
		
		self.tick = Corrupt.INTERVAL

		self.damageRemaining = self.damageRemaining - damage
	end
end

return Corrupt
