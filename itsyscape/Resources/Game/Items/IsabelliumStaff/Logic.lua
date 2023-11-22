--------------------------------------------------------------------------------
-- Resources/Game/Items/IsabelliumStaff/Logic.lua
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
local Staff = require "Resources.Game.Items.Common.Staff"
local Isabellium = require "Resources.Game.Items.Common.Isabellium"

local IsabelliumStaff = Class(Staff)

function IsabelliumStaff:getNearAttackRange(peep)
	return self:getFarAttackRange(peep)
end

function IsabelliumStaff:onEquip(peep, item)
	local _, isabellium = self:getCalculatedBonuses(peep, item)
	isabellium:attach(peep)
end

function IsabelliumStaff:getCalculatedBonuses(peep, item)
	local isabellium = Isabellium(item, Equipment.PLAYER_SLOT_TWO_HANDED, "IsabelliumStaff")

	isabellium:linkSkill("Magic")
	isabellium:linkSkill("Wisdom")
	isabellium:linkSkill("Faith")

	isabellium:setBonusMultiplier("AccuracyMagic", 0.9, Utility.styleBonusForWeapon, -5)
	isabellium:setBonusMultiplier("StrengthMagic", 1.0, Utility.strengthBonusForWeapon, -5)

	return isabellium:getStats(peep), isabellium
end

function IsabelliumStaff:getProjectile(peep)
	return Staff.getProjectile(self, peep) or "IsabelleStrike"
end

return IsabelliumStaff
