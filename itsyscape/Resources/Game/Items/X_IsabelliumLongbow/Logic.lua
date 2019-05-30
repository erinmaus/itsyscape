--------------------------------------------------------------------------------
-- Resources/Game/Items/X_IsabelliumLongbow/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Longbow = require "Resources.Game.Items.Common.Longbow"

local IsabelliumLongbow = Class(Longbow)
IsabelliumLongbow.AMMO = Equipment.AMMO_NONE

function IsabelliumLongbow:getCooldown(peep)
	return 4
end

function IsabelliumLongbow:getID()
	return 'X_IsabelliumLongbow'
end

function IsabelliumLongbow:getProjectile()
	return 'BronzeArrow'
end

return IsabelliumLongbow
