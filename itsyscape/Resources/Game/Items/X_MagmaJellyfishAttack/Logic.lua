--------------------------------------------------------------------------------
-- Resources/Game/Items/X_MagmaJellyfishAttack/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local MagicWeapon = require "ItsyScape.Game.MagicWeapon"

local MagmaJellyfishAttack = Class(MagicWeapon)
MagmaJellyfishAttack.AMMO = Equipment.AMMO_NONE

function MagmaJellyfishAttack:perform(peep, target)
	local position = Utility.Peep.getPosition(target)
	local p = Utility.spawnPropAtPosition(
		peep,
		"MagmaJellyfishRock",
		position.x,
		position.y,
		position.z,
		0.0)

	self:applyCooldown(peep, target)

	return true
end

function MagmaJellyfishAttack:getAttackRange()
	return 8
end

function MagmaJellyfishAttack:getProjectile()
	return 'MagmaJellyfishRock'
end

function MagmaJellyfishAttack:getCooldown()
	return 1.8
end

return MagmaJellyfishAttack
