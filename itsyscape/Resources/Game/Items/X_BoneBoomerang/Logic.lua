--------------------------------------------------------------------------------
-- Resources/Game/Items/X_BoneBoomerang/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Boomerang = require "Resources.Game.Items.Common.Boomerang"

local IsabelliumBoomerang = Class(Boomerang)
IsabelliumBoomerang.AMMO = Equipment.AMMO_NONE

function IsabelliumBoomerang:getAttackRange()
	return 8
end

function IsabelliumBoomerang:getID()
	return 'X_BoneBoomerang'
end

function IsabelliumBoomerang:getProjectile()
	return 'BoneBoomerang'
end

return IsabelliumBoomerang
