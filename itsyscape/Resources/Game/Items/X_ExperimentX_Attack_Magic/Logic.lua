--------------------------------------------------------------------------------
-- Resources/Game/Items/X_ExperimentX_Attack_Magic/Logic.lua
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

local ExperimentXMagicAttack = Class(MagicWeapon)

function ExperimentXMagicAttack:getAttackRange()
	return 8
end

function ExperimentXMagicAttack:getBonusForStance(peep)
	return Weapon.BONUS_MAGIC
end

function ExperimentXMagicAttack:getCooldown(peep)
	return 3
end

function ExperimentXMagicAttack:getProjectile()
	return "FireBlast_ExperimentX"
end

return ExperimentXMagicAttack
