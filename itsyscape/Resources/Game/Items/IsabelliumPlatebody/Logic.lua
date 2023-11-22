--------------------------------------------------------------------------------
-- Resources/Game/Items/IsabelliumPlatebody/Logic.lua
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
local Weapon = require "ItsyScape.Game.Weapon"
local Isabellium = require "Resources.Game.Items.Common.Isabellium"

local IsabelliumPlatebody = Class(Equipment)

function IsabelliumPlatebody:onEquip(peep, item)
	local _, isabellium = self:getCalculatedBonuses(peep, item)
	isabellium:attach(peep)
end

function IsabelliumPlatebody:getCalculatedBonuses(peep, item)
	local isabellium = Isabellium(item, Equipment.PLAYER_SLOT_BODY, "IsabelliumPlatebody")

	isabellium:linkSkill("Attack")
	isabellium:linkSkill("Strength")
	isabellium:linkSkill("Defense")
	isabellium:linkSkill("Faith")

	local WEIGHT = 42 / 100 * 0.8

	isabellium:setBonusMultiplier("DefenseSlash", WEIGHT, Utility.styleBonusForItem, -5)
	isabellium:setBonusMultiplier("DefenseStab", WEIGHT, Utility.styleBonusForItem, -4)
	isabellium:setBonusMultiplier("DefenseCrush", WEIGHT, Utility.styleBonusForItem, -4)
	isabellium:setBonusMultiplier("DefenseMagic", WEIGHT, Utility.styleBonusForItem, -20)
	isabellium:setBonusMultiplier("DefenseRanged", WEIGHT, Utility.styleBonusForItem, -10)

	return isabellium:getStats(peep), isabellium
end

return IsabelliumPlatebody
