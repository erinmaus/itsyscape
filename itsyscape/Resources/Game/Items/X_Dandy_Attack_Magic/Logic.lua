--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Dandy_Attack_Magic/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local MagicWeapon = require "ItsyScape.Game.MagicWeapon"

local DandyMagicAttack = Class(MagicWeapon)

function DandyMagicAttack:getAttackRange()
	return 2
end

function DandyMagicAttack:getWeaponType()
	return 'unarmed'
end

function DandyMagicAttack:getCooldown(peep)
	return 3
end

function DandyMagicAttack:getProjectile()
	return "DandelionPuff"
end

return DandyMagicAttack
