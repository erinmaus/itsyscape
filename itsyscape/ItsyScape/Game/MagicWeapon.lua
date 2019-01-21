--------------------------------------------------------------------------------
-- ItsyScape/Game/ItemManager.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local CombatSpell = require "ItsyScape.Game.CombatSpell"
local ActiveSpellBehavior = require "ItsyScape.Peep.Behaviors.ActiveSpellBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

local MagicWeapon = Class(Weapon)

function MagicWeapon:getFarAttackRange(peep)
	return 8
end

function MagicWeapon:getNearAttackRange(peep)
	return 1
end

function MagicWeapon:getSpell(peep)
	local stance = peep:getBehavior(StanceBehavior)
	if stance and stance.useSpell then
		local activeSpell = peep:getBehavior(ActiveSpellBehavior)
		if activeSpell
		   and activeSpell.spell
		   and activeSpell.spell:isCompatibleType(CombatSpell)
		   and activeSpell.spell:canCast(peep):good()
		then
			return activeSpell.spell
		end
	end

	return nil
end

function MagicWeapon:rollDamage(peep, purpose, target)
	local spell = self:getSpell(peep)

	local roll = Weapon.rollDamage(self, peep, purpose, target)
	if target == Weapon.PURPOSE_KILL then
		roll:setBonus(roll:getBonus() + spell:getStrengthBonus())
	end

	return roll
end

function MagicWeapon:perform(peep, target)
	local success = Weapon.perform(self, peep, target)
	local spell = self:getSpell(peep)
	if spell then
		spell:cast(peep, target)
	end

	return success
end

function MagicWeapon:getAttackRange(peep)
	local spell = self:getSpell(peep)
	if spell then
		return self:getFarAttackRange(peep)
	else
		return self:getNearAttackRange(peep)
	end
end

function MagicWeapon:getStyle()
	return Weapon.STYLE_MAGIC
end

function MagicWeapon:getProjectile(peep)
	local spell = self:getSpell(peep)

	if spell then
		return spell.id
	end

	return nil
end


return MagicWeapon
