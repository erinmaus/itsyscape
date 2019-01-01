--------------------------------------------------------------------------------
-- Resources/Game/Items/Common/Zweihander.lua
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

local Zweihander = Class(MeleeWeapon)

function Zweihander:getAttackRange()
	return 2
end

function Zweihander:getBonusForStance(peep)
	return Weapon.BONUS_SLASH
end

function Zweihander:getWeaponType()
	return 'zweihander'
end

function Zweihander:getCooldown(peep)
	return 3.6
end

return Zweihander
