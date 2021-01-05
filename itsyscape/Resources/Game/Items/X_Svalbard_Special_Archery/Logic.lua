--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Svalbard_Special_Archery/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local RangedWeapon = require "ItsyScape.Game.RangedWeapon"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"

local SvalbardArcherySpecial = Class(RangedWeapon)
SvalbardArcherySpecial.AMMO = Equipment.AMMO_NONE

function SvalbardArcherySpecial:perform(peep, target)
	RangedWeapon.perform(self, peep, target)
	self:hitSurroundingPeeps(peep, target)
end

function SvalbardArcherySpecial:hitSurroundingPeeps(peep, target)
	local range = self:getAttackRange(peep) / 2
	local sourcePosition = Utility.Peep.getAbsolutePosition(peep)

	local hits = peep:getDirector():probe(peep:getLayerName(), function(p)
		if peep == p or target == p then
			return false
		end

		local targetPosition = Utility.Peep.getAbsolutePosition(p)
		return (targetPosition - sourcePosition):getLength() <= range
	end)

	for i = 1, #hits do
		RangedWeapon.perform(self, peep, hits[i])
	end
end

function SvalbardArcherySpecial:getBonusForStance(peep)
	return Weapon.BONUS_MAGIC
end

function SvalbardArcherySpecial:getAttackRange()
	return 32
end

function SvalbardArcherySpecial:onEquip(peep)
	peep:poke('land')
	peep:poke('equipSpecialWeapon', self, "Special (Archery)")
end

function SvalbardArcherySpecial:getWeaponType()
	return 'unarmed'
end

function SvalbardArcherySpecial:getCooldown(peep)
	return 3
end

function SvalbardArcherySpecial:getProjectile()
	return nil
end

return SvalbardArcherySpecial
