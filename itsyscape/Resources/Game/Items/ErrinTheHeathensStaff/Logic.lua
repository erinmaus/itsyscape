--------------------------------------------------------------------------------
-- ItsyScape/Game/ItemManager.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"

local ErrinTheHeathensStaff = Class(Weapon)

function ErrinTheHeathensStaff:getAttackRange(peep)
	-- TODO: Take into account spell; range with spell is 10
	return 1
end

function ErrinTheHeathensStaff:getBonusForStance(peep)
	-- TODO: Take into account spell
	return Weapon.BONUS_CRUSH
end

function ErrinTheHeathensStaff:getWeaponType()
	return 'staff'
end

function ErrinTheHeathensStaff:getStyle()
	return Weapon.STYLE_MAGIC
end

return ErrinTheHeathensStaff
