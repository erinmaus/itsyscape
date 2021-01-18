--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Svalbard_Special_Dragonfyre/Logic.lua
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

local SvalbardDragonfyreSpecial = Class(MagicWeapon)

function SvalbardDragonfyreSpecial:perform(peep, target)
	local roll = self:rollDamage(peep, Weapon.PURPOSE_KILL, target)
	roll:setMinHit(math.floor(roll:getMaxHit() / 2 + 0.5))

	local ray, range = Utility.Peep.getTargetLineOfSight(peep, target)
	local hits = Utility.Peep.getPeepsAlongRay(peep, ray, range)

	local hitTarget = false
	for i = 1, #hits do
		local _, _, _, tile = Utility.Peep.getTile(hits[i])
		if tile:hasFlag('impassable') then
			Log.info("Dragonfyre blocked!")
			break
		else
			local attack = AttackPoke({
				attackType = self:getBonusForStance(peep):lower(),
				weaponType = self:getWeaponType(),
				damage = roll:roll(),
				aggressor = peep
			})

			Log.info("'%s' was incinerated by Dragonfyre!", hits[i]:getName())
			hits[i]:poke('receiveAttack', attack)
			peep:poke('initiateAttack', attack)

			if target == hits[i] then
				hitTarget = true
			end
		end
	end

	if not hitTarget then
		local attack = AttackPoke({
			attackType = self:getBonusForStance(peep):lower(),
			weaponType = self:getWeaponType(),
			damage = 0,
			aggressor = peep
		})

		target:poke('receiveAttack', attack)
		peep:poke('initiateAttack', attack)

		Log.info("Missed primary target.")
	end

	Log.info("All secondary targets hit by Dragonfyre.")
	self:applyCooldown(peep)
end

function SvalbardDragonfyreSpecial:getBonusForStance(peep)
	return Weapon.BONUS_MAGIC
end

function SvalbardDragonfyreSpecial:getAttackRange()
	return 32
end

function SvalbardDragonfyreSpecial:onEquip(peep)
	peep:poke('equipSpecialWeapon', self, "Special (Dragonfyre)")
end

function SvalbardDragonfyreSpecial:getWeaponType()
	return 'unarmed'
end

function SvalbardDragonfyreSpecial:getCooldown(peep)
	return 3
end

function SvalbardDragonfyreSpecial:getProjectile()
	return nil
end

return SvalbardDragonfyreSpecial
