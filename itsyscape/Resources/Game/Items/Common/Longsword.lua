--------------------------------------------------------------------------------
-- Resources/Game/Items/Common/Longsword.lua
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

local Longsword = Class(MeleeWeapon)

function Longsword:getBonusForStance(peep)
	return Weapon.BONUS_SLASH
end

function Longsword:getWeaponType()
	return 'longsword'
end

function Longsword:getCooldown(peep)
	return 2.4
end

return Longsword
