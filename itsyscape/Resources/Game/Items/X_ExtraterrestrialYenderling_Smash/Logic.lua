--------------------------------------------------------------------------------
-- Resources/Game/Items/X_ExtraterrestrialYenderling_Smash/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local MeleeWeapon = require "ItsyScape.Game.MeleeWeapon"

local ExtraterrestrialYenderling = Class(MeleeWeapon)

function ExtraterrestrialYenderling:getAttackRange(peep)
	return 2
end

function ExtraterrestrialYenderling:getDelay()
	return 0.75
end

function ExtraterrestrialYenderling:getCooldown()
	return 4
end

return ExtraterrestrialYenderling
