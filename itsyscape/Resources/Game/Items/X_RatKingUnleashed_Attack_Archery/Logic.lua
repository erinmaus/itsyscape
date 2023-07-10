--------------------------------------------------------------------------------
-- Resources/Game/Items/X_RatKingUnleashed_Attack_Archery/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local RangedWeapon = require "ItsyScape.Game.RangedWeapon"

local RatKingUnleashedBoneAttack = Class(RangedWeapon)
RatKingUnleashedBoneAttack.AMMO = Weapon.AMMO_NONE

function RatKingUnleashedBoneAttack:getAttackRange()
	return 8
end

function RatKingUnleashedBoneAttack:getCooldown()
	return 3
end

function RatKingUnleashedBoneAttack:getProjectile()
	return nil
end

function RatKingUnleashedBoneAttack:perform(peep, target)
	RangedWeapon.perform(self, peep, target)

	self:hitOnPath(peep, target)
end

function RatKingUnleashedBoneAttack:hitOnPath(peep, target)
	local ray, range = Utility.Peep.getTargetLineOfSight(peep, target)
	local hits = Utility.Peep.getPeepsAlongRay(peep, ray, range)

	for i = 1, #hits do
		local hit = hits[i]
		if hit ~= peep and hit ~= target and Utility.Peep.isAttackable(hit) then
			RangedWeapon.perform(self, peep, target)
		end
	end
end

return RatKingUnleashedBoneAttack
