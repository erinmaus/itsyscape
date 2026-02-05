--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Dragon_Dragonfyre/Logic.lua
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

local Dragonfyre = Class(MagicWeapon)

function Dragonfyre:getBonusForStance(peep)
	return Weapon.BONUS_MAGIC
end

function Dragonfyre:getAttackRange()
	return 6
end

function Dragonfyre:onEquip(peep)
	Utility.Peep.Creep.addAnimation(peep, "animation-attack", "Dragon_Attack_Dragonfyre")
end

function Dragonfyre:getWeaponType()
	return 'dragonfyre'
end

function Dragonfyre:getCooldown(peep)
	return 4
end

return Dragonfyre
