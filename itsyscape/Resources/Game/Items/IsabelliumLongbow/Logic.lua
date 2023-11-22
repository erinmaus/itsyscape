--------------------------------------------------------------------------------
-- Resources/Game/Items/IsabelliumLongbow/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Longbow = require "Resources.Game.Items.Common.Longbow"
local Isabellium = require "Resources.Game.Items.Common.Isabellium"

local IsabelliumLongbow = Class(Longbow)
IsabelliumLongbow.AMMO = Longbow.AMMO_NONE
IsabelliumLongbow.AMMO_SLOT = Equipment.PLAYER_SLOT_RIGHT_HAND

function IsabelliumLongbow:onEquip(peep, item)
	local _i, isabellium = self:getCalculatedBonuses(peep, item)
	isabellium:attach(peep)
end

function IsabelliumLongbow:getCalculatedBonuses(peep, item)
	local isabellium = Isabellium(item, Equipment.PLAYER_SLOT_TWO_HANDED, "IsabelliumLongbow")

	isabellium:linkSkill("Archery")
	isabellium:linkSkill("Dexterity")
	isabellium:linkSkill("Faith")

	isabellium:setBonusMultiplier("AccuracyRanged", 0.9, Utility.styleBonusForWeapon, -5)
	isabellium:setBonusMultiplier("StrengthRanged", 1.0, Utility.strengthBonusForWeapon, -5)

	return isabellium:getStats(peep), isabellium
end

function IsabelliumLongbow:getProjectile(peep)
	return "IsabelliumArrow"
end

return IsabelliumLongbow
