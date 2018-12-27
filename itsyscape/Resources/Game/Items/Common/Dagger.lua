--------------------------------------------------------------------------------
-- Resources/Game/Items/Common/Dagger.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Weapon = require "ItsyScape.Game.Weapon"
local MeleeWeapon = require "ItsyScape.Game.MeleeWeapon"

local Dagger = Class(MeleeWeapon)

function Dagger:getBonusForStance(peep)
	return Weapon.BONUS_STAB
end

function Dagger:getWeaponType()
	return 'dagger'
end

function Dagger:getCooldown(peep)
	return 1.2
end

return Dagger
