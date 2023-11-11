--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Hellhound_Attack/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Weapon = require "ItsyScape.Game.Weapon"
local MagicWeapon = require "ItsyScape.Game.MagicWeapon"

local HellhoundAttack = Class(MagicWeapon)

function HellhoundAttack:getBonusForStance(peep)
	return Weapon.BONUS_MAGIC
end

function HellhoundAttack:getWeaponType()
	return 'unarmed'
end

function HellhoundAttack:getCooldown(peep)
	return 1.8
end

function HellhoundAttack:getProjectile()
	return "FireStrike"
end

return HellhoundAttack
