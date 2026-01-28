--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Dragon_ChargedDragonfyre/Logic.lua
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

local ChargedDragonfyre = Class(MagicWeapon)
ChargedDragonfyre.DELAY = 1

function ChargedDragonfyre:perform(peep, target)
	local position = Utility.Peep.getPosition(peep)

	local fireball = Utility.spawnPropAtPosition(peep, "DragonFireball", position:get())
	if not fireball then
		return MagicWeapon.perform(peep, target)
	end

	fireball:getPeep():pushPoke(
		self.DELAY,
		"shoot",
		{
			dragon = peep,
			peep = target,
			weapon = Utility.Peep.getXWeapon(peep:getDirector():getGameInstance(), "Dragon_ChargedDragonfyreHit")
		})

	local attack = self:getMissAttackPoke(peep, target)
	self:pokeInitiateAttack(peep, target, attack)

	self:applyCooldown(peep, target)

	return true
end

function ChargedDragonfyre:getBonusForStance(peep)
	return Weapon.BONUS_MAGIC
end

function ChargedDragonfyre:getAttackRange()
	return 24
end

function ChargedDragonfyre:onEquip(peep)
	Utility.Peep.Creep.addAnimation(peep, "animation-attack", "Dragon_Roar")
end

function ChargedDragonfyre:getWeaponType()
	return 'dragonfyre'
end

function ChargedDragonfyre:getCooldown(peep)
	return 4
end

return ChargedDragonfyre
