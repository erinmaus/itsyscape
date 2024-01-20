--------------------------------------------------------------------------------
-- Resources/Game/Items/X_TheEmptyKing_FullyRealized_Zweihander/Logic.lua
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

local AncientZweihander = Class(MeleeWeapon)

function AncientZweihander:getAttackRange()
	return 4
end

function AncientZweihander:getCooldown(peep)
	return 1.8
end

function AncientZweihander:getProjectile()
	return "TheEmptyKing_FullyRealized_Zweihander"
end

return AncientZweihander
