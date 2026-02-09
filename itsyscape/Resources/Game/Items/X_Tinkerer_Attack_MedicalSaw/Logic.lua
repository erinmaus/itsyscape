--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Tinkerer_Attack_MedicalSaw/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local MeleeWeapon = require "ItsyScape.Game.MeleeWeapon"

local MedicalSaw = Class(MeleeWeapon)

function MedicalSaw:getAttackRange()
	return 4
end

function MedicalSaw:getBonusForStance(peep)
	return Weapon.BONUS_SLASH
end

function MedicalSaw:getWeaponType()
	return 'saw'
end

function MedicalSaw:getCooldown(peep)
	return 2.5
end

return MedicalSaw
