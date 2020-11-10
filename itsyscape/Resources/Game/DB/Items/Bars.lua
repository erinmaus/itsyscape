--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Bars.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local BARS = {
	["Bronze"] = {
		tier = 1,
		weight = 6.4,
		{ name = "CopperOre", count = 1 },
		{ name = "TinOre", count = 1 }
	},

	["Copper"] = {
		tier = 0,
		weight = 6.5,
		{ name = "CopperOre", count = 1 }
	},

	["Tin"] = {
		tier = 0,
		weight = 5.1,
		{ name = "TinOre", count = 1 }
	},

	["Iron"] = {
		tier = 10,
		weight = 8,
		{ name = "IronOre", count = 1 }
	},

	["Adamant"] = {
		tier = 40,
		weight = 25,
		{ name = "AdamantOre", count = 1 }
	},

	["Gold"] = {
		tier = 55,
		weight = 12,
		{ name = "GoldOre", count = 1 }
	}
}

for name, bar in pairs(BARS) do
	local ItemName = string.format("%sBar", name)
	local Bar = ItsyScape.Resource.Item(ItemName)

	local SmeltAction = ItsyScape.Action.Smelt()
	for i = 1, #bar do
		SmeltAction {
			Input {
				Resource = ItsyScape.Resource.Item(bar[i].name),
				Count = bar.count
			}
		}
	end

	SmeltAction {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(math.max(bar.tier, 1))
		},

		Output {
			Resource = Bar,
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForResource(math.max(bar.tier, 1)) * #bar
		}
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(bar.tier + 1),
		Weight = bar.weight,
		Resource = Bar
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = name,
		Resource = Bar
	}

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s bar", name),
		Language = "en-US",
		Resource = Bar
	}

	Bar {
		SmeltAction
	}
end

ItsyScape.Meta.ResourceDescription {
	Value = "Almost completely useless!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "CopperBar"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Almost completely useless!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "TinBar"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Useful for making bronze weapons and armor.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BronzeBar"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Useful for making iron weapons and armor.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronBar"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Useful for making adamant weapons and armor.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AdamantBar"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Useful for making jewelry and other trinkets.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GoldBar"
}
