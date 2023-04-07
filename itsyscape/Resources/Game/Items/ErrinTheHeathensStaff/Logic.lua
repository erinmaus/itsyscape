--------------------------------------------------------------------------------
-- Resources/Game/Items/ErrinTheHeathensStaff/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Staff = require "Resources.Game.Items.Common.Staff"

local ErrinTheHeathensStaff = Class(Staff)

function ErrinTheHeathensStaff:getFarAttackRange(peep)
	return 14
end

function ErrinTheHeathensStaff:getNearAttackRange(peep)
	return 2
end

function ErrinTheHeathensStaff:getStyle()
	return Weapon.STYLE_MAGIC
end

function ErrinTheHeathensStaff:getCooldown()
	return 1.8
end

return ErrinTheHeathensStaff
