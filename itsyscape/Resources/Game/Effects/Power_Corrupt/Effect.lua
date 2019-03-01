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
Corrupt.DURATION = 10
Corrupt.INTERVAL = 2

function Corrupt:new(activator)
	Effect.new(self)

	local level = activator:getState():count(
		"Skill",
		"Wisdom",
		{ ['skill-as-level'] = true })

	local weapon = Utility.Peep.getEquippedItem(activator, Equipment.PLAYER_SLOT_RIGHT_HAND) or
	               Utility.Peep.getEquippedItem(activator, Equipment.PLAYER_SLOT_TWO_HANDED)
	if weapon then
		local logic = activator:getDirector():getItemManager():getLogic(weapon:getID())
		local damageRoll = logic:rollDamage(activator, Weapon.PURPOSE_KILL)
		local maxHit = damageRoll:getMaxHit() + 1
		local multiplier = math.min(math.max(level - 5, 0) / 50, 2) + 1

		self.damage = math.floor(maxHit * multiplier)
	else
		self.damage = 0
	end

	self.tick = 0
	self.aggressor = activator
end

function Corrupt:getBuffType()
	return Effect.BUFF_TYPE_NEGATIVE
end


function Corrupt:update(delta)
	Effect.update(self, delta)

	self.tick = self.tick - delta
	if self.tick < 0 then
		local damage = math.floor(self.damage / (Corrupt.DURATION / Corrupt.INTERVAL) + 0.5)

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
	end
end

return Corrupt
