--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Svalbard_Special_Magic/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local MagicWeapon = require "ItsyScape.Game.MagicWeapon"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"

local SvalbardMagicSpecial = Class(MagicWeapon)

function SvalbardMagicSpecial:perform(peep, target)
	local roll = self:rollDamage(peep, Weapon.PURPOSE_KILL, target)
	roll:setMinHit(math.floor(roll:getMaxHit() / 2 + 0.5))

	local ray, range = Utility.Peep.getTargetLineOfSight(peep, target)
	local hits = Utility.Peep.getPeepsAlongRay(peep, ray, range)

	for i = 1, #hits do
		local _, _, _, tile = Utility.Peep.getTile(hits[i])
		if tile:hasFlag('impassable') then
			Log.info("Bloody vomit blocked!")
			break
		else
			local attack = AttackPoke({
				attackType = self:getBonusForStance(peep):lower(),
				weaponType = self:getWeaponType(),
				damage = roll:roll(),
				aggressor = peep
			})

			local additionalCooldown = attack:getDamage() / 10
			local _, cooldown = target:addBehavior(AttackCooldownBehavior)
			cooldown.cooldown = cooldown.cooldown + additionalCooldown
			cooldown.ticks = peep:getDirector():getGameInstance():getCurrentTick()

			Log.info("'%s' was stunned for %.2f seconds by by bloody vomit!", hits[i]:getName(), cooldown.cooldown)
			hits[i]:poke('receiveAttack', attack)
			peep:poke('initiateAttack', attack)
		end
	end

	Log.info("All targets hit by bloody vomit.")
	self:applyCooldown(peep)
end

function SvalbardMagicSpecial:getBonusForStance(peep)
	return Weapon.BONUS_MAGIC
end

function SvalbardMagicSpecial:getAttackRange()
	return 32
end

function SvalbardMagicSpecial:onEquip(peep)
	peep:poke('equipSpecialWeapon', self, "Special (Magic)")
end

function SvalbardMagicSpecial:getWeaponType()
	return 'unarmed'
end

function SvalbardMagicSpecial:getCooldown(peep)
	return 3
end

function SvalbardMagicSpecial:getProjectile()
	return nil
end

return SvalbardMagicSpecial
