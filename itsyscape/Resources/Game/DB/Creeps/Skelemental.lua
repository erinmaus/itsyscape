--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Skelemental.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

include "Resources/Game/DB/Creeps/Skelementals/Copper.lua"
include "Resources/Game/DB/Creeps/Skelementals/Tin.lua"

local BARS = {
	["Copper"] = {
		tier = 1,
		{ name = "CopperFlake", count = 5 }
	},

	["Tin"] = {
		tier = 1,
		{ name = "TinFlake", count = 5 }
	},

	["Bronze"] = {
		tier = 1,
		{ name = "CopperFlake", count = 5 },
		{ name = "TinFlake", count = 5 }
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
				Count = bar[i].count
			}
		}
	end

	SmeltAction {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(math.max(bar.tier, 1))
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForResource(math.max(bar.tier, 1)) * #bar
		},

		Output {
			Resource = Bar,
			Count = 1
		}
	}

	Bar {
		SmeltAction
	}
end

-- Tin can. Since there's no tin armor...
do
	ItsyScape.Resource.Item "TinCan" {
		ItsyScape.Action.Equip(),
		ItsyScape.Action.Dequip(),
		ItsyScape.Action.Smith() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Hammer",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "TinBar",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForResource(2)
			},

			Output {
				Resource = ItsyScape.Resource.Item "TinCan",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Tin can",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "TinCan"
	}

	ItsyScape.Meta.Item {
		Value = 14,
		Weight = 0.0,
		Resource = ItsyScape.Resource.Item "TinCan"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = "Tin",
		Resource = ItsyScape.Resource.Item "TinCan"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Not to scale.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "TinCan"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/TinCan/TinCan.lua",
		Resource = ItsyScape.Resource.Item "TinCan"
	}

	-- No bonuses. Such is life.
	ItsyScape.Meta.Equipment {
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "TinCan"
	}
end

-- Copper badge. Since there's no copper armor...
do
	ItsyScape.Resource.Item "CopperBadge" {
		ItsyScape.Action.Equip(),
		ItsyScape.Action.Dequip(),
		ItsyScape.Action.Smith() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Hammer",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "CopperBar",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForResource(2)
			},

			Output {
				Resource = ItsyScape.Resource.Item "CopperBadge",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Copper badge",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CopperBadge"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Stop in the name of the law!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CopperBadge"
	}

	ItsyScape.Meta.Item {
		Value = 14,
		Weight = 0.0,
		Resource = ItsyScape.Resource.Item "CopperBadge"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = "Copper",
		Resource = ItsyScape.Resource.Item "CopperBadge"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/CopperBadge/CopperBadge.lua",
		Resource = ItsyScape.Resource.Item "CopperBadge"
	}

	ItsyScape.Meta.Equipment {
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(1, 0.5),
		Prayer = 1,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_NECK,
		Resource = ItsyScape.Resource.Item "CopperBadge"
	}
end