--------------------------------------------------------------------------------
-- Resources/Game/Items/IsabelliumZweihander/Logic.lua
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
local Zweihander = require "Resources.Game.Items.Common.Zweihander"
local Isabellium = require "Resources.Game.Items.Common.Isabellium"

local IsabelliumZweihander = Class(Zweihander)

function IsabelliumZweihander:onEquip(peep, item)
	local _, isabellium = self:getCalculatedBonuses(peep, item)
	isabellium:attach(peep)
end

function IsabelliumZweihander:getCalculatedBonuses(peep, item)
	local isabellium = Isabellium(item, Equipment.PLAYER_SLOT_TWO_HANDED, "IsabelliumZweihander")

	isabellium:linkSkill("Attack")
	isabellium:linkSkill("Strength")
	isabellium:linkSkill("Faith")

	isabellium:setBonusMultiplier("AccuracySlash", 0.9, Utility.styleBonusForWeapon, -5)
	isabellium:setBonusMultiplier("StrengthMelee", 1.0, Utility.strengthBonusForWeapon, -5)

	return isabellium:getStats(peep), isabellium
end

return IsabelliumZweihander
