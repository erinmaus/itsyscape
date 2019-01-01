--------------------------------------------------------------------------------
-- Resources/Game/Maps/HighChambersYendor_Floor1West/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"
local ChestMimicCommon = require "Resources.Game.Peeps.ChestMimic.Common"

local HighChambersYendor = Class(Map)

HighChambersYendor.MIMIC_ANCHOR = "Anchor_Mimic"
HighChambersYendor.MIMICS = {
	{ peep = "Mimic_Angry", chance = 3 / 4 }
}
HighChambersYendor.MIMIC_CHANCE = 0.5

function HighChambersYendor:new(resource, name, ...)
	Map.new(self, resource, name or 'HighChambersYendor_Floor1West', ...)
end

function HighChambersYendor:onFinalize(...)
	ChestMimicCommon.spawn(
		self,
		"Anchor_MimicSpawn",
		"Anchor_AliceSpawn",
		self.MIMICS,
		self.MIMIC_CHANCE)
end

function HighChambersYendor:onSquidEnraged()
	self.squidRageStat.currentValue = math.min(
		self.squidRageStat.currentValue + 1,
		self.squidRageStat.maxValue)
end

return HighChambersYendor
