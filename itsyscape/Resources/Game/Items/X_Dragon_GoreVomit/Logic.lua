--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Dragon_GoreVomit/Logic.lua
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
local SpecialAttackBehavior = require "ItsyScape.Peep.Behaviors.SpecialAttackBehavior"

local GoreVomit = Class(MagicWeapon)

function GoreVomit:getBonusForStance(peep)
	return Weapon.BONUS_MAGIC
end

function GoreVomit:getAttackRange()
	return 6
end

function GoreVomit:onEquip(peep)
	Utility.Peep.Creep.addAnimation(peep, "animation-attack", "Dragon_Attack_GoreVomit")
end

function GoreVomit:getWeaponType()
	return 'dragonfyre'
end

function GoreVomit:getCooldown(peep)
	return 5
end

return GoreVomit
