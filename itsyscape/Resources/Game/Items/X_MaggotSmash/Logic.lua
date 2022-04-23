--------------------------------------------------------------------------------
-- Resources/Game/Items/X_MaggotSmash/Logic.lua
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

local MaggotSmash = Class(MeleeWeapon)

function MaggotSmash:getAttackRange(peep)
	return 4
end

function MaggotSmash:getBonusForStance(peep)
	return Weapon.BONUS_CRUSH
end

function MaggotSmash:getCooldown()
	return 3
end

return MaggotSmash
