--------------------------------------------------------------------------------
-- Resources/Game/Items/X_AncientKaradon_Archery/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local RangedWeapon = require "ItsyScape.Game.RangedWeapon"
local Utility = require "ItsyScape.Game.Utility"

local ArcheryAttack = Class(RangedWeapon)
ArcheryAttack.AMMO = RangedWeapon.AMMO_NONE

function ArcheryAttack:getCooldown(peep)
	return 2.4
end

function ArcheryAttack:getAttackRange(peep)
	return 16
end

function ArcheryAttack:getProjectile(peep)
	return "AncientKaradonZap"
end

return ArcheryAttack
