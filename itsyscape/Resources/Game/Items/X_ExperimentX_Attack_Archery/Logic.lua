--------------------------------------------------------------------------------
-- Resources/Game/Items/X_ExperimentX_Attack_Archery/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local RangedWeapon = require "ItsyScape.Game.RangedWeapon"

local ExperimentXArcheryAttack = Class(RangedWeapon)
ExperimentXArcheryAttack.AMMO = RangedWeapon.AMMO_NONE

function ExperimentXArcheryAttack:getAttackRange()
	return 8
end

function ExperimentXArcheryAttack:getCooldown(peep)
	return 3
end

function ExperimentXArcheryAttack:getProjectile()
	return "ItsyArrow_ExperimentX"
end

return ExperimentXArcheryAttack
