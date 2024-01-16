--------------------------------------------------------------------------------
-- Resources/Game/Items/X_ExperimentX_Attack_Melee/Logic.lua
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

local ExperimentXMeleeAttack = Class(MeleeWeapon)

function ExperimentXMeleeAttack:getAttackRange()
	return 8
end

function ExperimentXMeleeAttack:getCooldown(peep)
	return 3
end

return ExperimentXMeleeAttack
