--------------------------------------------------------------------------------
-- Resources/Game/Items/X_YendorianSwordfish/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local MeleeWeapon = require "ItsyScape.Game.MeleeWeapon"

local YendorianSwordfish = Class(MeleeWeapon)

function YendorianSwordfish:getAttackRange(peep)
	return 3.5
end

function YendorianSwordfish:getBonusForStance(peep)
	return Weapon.BONUS_SLASH
end

function YendorianSwordfish:getCooldown()
	return 1.8
end

return YendorianSwordfish
