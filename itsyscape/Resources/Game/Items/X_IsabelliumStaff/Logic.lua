--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Isabellium/Logic.lua
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

local IsabelliumStaff = Class(Staff)

function IsabelliumStaff:getCooldown(peep)
	return 4
end

function IsabelliumStaff:getID()
	return 'X_IsabelliumStaff'
end

function IsabelliumStaff:getProjectile(peep)
	return "IsabelleStrike"
end

return IsabelliumStaff
