--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/FishingRods.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local LOGS = {
	["Common"] = {
		tier = 1,
		style = "Puny",
		metal = "Bronze",
		description = "A bit better than that useless wimpy fishing rod you can find in stores."
	},

	["Willow"] = {
		tier = 10,
		style = "Bendy",
		metal = "Iron",
		description = "Has a nice bend when reeling in fish."
	},

	["Oak"] = {
		tier = 20,
		style = "Petty",
		metal = "BlackenedIron",
		description = "Better than using your hands to fish!"
	},

	["Maple"] = {
		tier = 30,
		style = "Shaky",
		metal = "Mithril",
		description = "Suprisingly attracts fish a bit better."
	},

	["Yew"] = {
		tier = 40,
		style = "Spindly",
		metal = "Adamant",
		description = "A strong fishing rod that beats the will to live out of a fish."
	},

	["PetrifiedSpider"] = {
		tier = 50,
		style = "Terrifying",
		metal = "Itsy",
		description = "Used a petrified spider's leg to fish..? Heck, why not?!"
	},
}

for name, log in spairs(LOGS) do
	do
		local HookName = string.format("%sFishHook", log.metal)
		local HookItem = ItsyScape.Resource.Item(HookName) {
			ItsyScape.Action.Smith() {
				Requirement {
					Resource = ItsyScape.Resource.Skill "Smithing",
					Count = ItsyScape.Utility.xpForLevel(log.tier)
				},

				Input {
					Resource = ItsyScape.Resource.Item(string.format("%sBar", log.metal)),
					Count = 1
				},

				Output {
					Resource = ItsyScape.Resource.Item(HookName),
					Count = 1,
				},

				Output {
					Resource = ItsyScape.Resource.Skill "Smithing",
					Count = ItsyScape.Utility.xpForResource(log.tier + 0.5)
				}
			}
		}

		ItsyScape.Meta.ResourceCategory {
			Key = "Metal",
			Value = log.metal,
			Resource = HookItem
		}

		ItsyScape.Meta.ResourceName {
			Value = string.format("%s fish hook", log.metal),
			Language = "en-US",
			Resource = HookItem
		}

		ItsyScape.Meta.Item {
			Value = ItsyScape.Utility.valueForItem(log.tier + 0.5),
			Resource = HookItem
		}

		ItsyScape.Meta.ResourceDescription {
			Value = string.format("You can make a %s fishing rod with this fish hook.", log.style:lower()),
			Language = "en-US",
			Resource = HookItem
		}
	end

	local ItemName = string.format("%sFishingRod", log.style)
	local Item = ItsyScape.Resource.Item(ItemName)

	local EquipAction = ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Fishing",
			Count = ItsyScape.Utility.xpForLevel(log.tier)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForLevel(math.max(log.tier - 5, 1))
		}
	}

	local DequipAction = ItsyScape.Action.Dequip()

	local FletchAction = ItsyScape.Action.Fletch() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = ItsyScape.Utility.xpForLevel(math.max(log.tier, 1))
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Fishing",
			Count = ItsyScape.Utility.xpForLevel(math.max(log.tier - 5, 1))
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Knife",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item(string.format("%sLogs", name)),
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item(string.format("%sFishHook", log.metal)),
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "FlaxFishingLine",
			Count = 1
		},

		Output {
			Resource = Item,
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = ItsyScape.Utility.xpForResource(log.tier)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Fishing",
			Count = ItsyScape.Utility.xpForResource(math.max(log.tier - 5, 1))
		}
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(log.tier + 1) * 2,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s fishing rod", log.style),
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = log.description,
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Wood",
		Value = name,
		Resource = Item
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(log.tier + 5),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(log.tier + 6),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = Item
	}

	ItsyScape.Utility.tag(Item, "tool")

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = string.format("Resources/Game/Skins/FishingRod/%s.lua", log.style),
		Resource = Item
	}

	Item {
		EquipAction,
		DequipAction,
		FletchAction
	}
end

-- Flax fishing line
do
	ItsyScape.Resource.Item "FlaxFishingLine" {
		ItsyScape.Action.Craft() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Flax",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "FlaxFishingLine",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(3)
			}
		}
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Fiber",
		Value = "Flax",
		Resource = ItsyScape.Resource.Item "FlaxFishingLine"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(2),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "FlaxFishingLine"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Flax fishing line",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "FlaxFishingLine"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Useful when making fishing rods.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "FlaxFishingLine"
	}
end
