--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Isabellium.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local ITEMS = {
	["Gloves"] = {
		niceName = "%s gloves",
		slot = "Gloves",
		count = 15
	},

	["Boots"] = {
		niceName = "%s boots",
		slot = "Boots",
		count = 15
	},

	["Helmet"] = {
		skills = { "Defense", "Strength" },
		niceName = "%s open-face helmet",
		slot = "Helmet",
		count = 20
	},

	["Platebody"] = {
		niceName = "%s platebody",
		slot = "Body",
		count = 50
	}
}

for itemName, itemProps in spairs(ITEMS) do
	local ItemName = string.format("Isabellium%s", itemName)
	local Item = ItsyScape.Resource.Item(ItemName)

	local EquipAction = ItsyScape.Action.Equip()
	EquipAction {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Strength",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(10)
		}
	}

	local DequipAction = ItsyScape.Action.Dequip()

	local TrimAction = ItsyScape.Action.Craft() {
		Requirement {
			Resource = ItsyScape.Resource.Item "Hammer",
			Count = 1
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Requirement {
			Resource = ItsyScape.Resource.Quest "CalmBeforeTheStorm",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item(string.format("Bronze%s", itemName)),
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "IsabelliumShard",
			Count = itemProps.count
		},

		Output {
			Resource = Item,
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForResource(10) * itemProps.count,
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForResource(10) * itemProps.count,
		}
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Trim",
		XProgressive = "Trimming",
		Language = "en-US",
		Action = TrimAction
	}

	ItsyScape.Meta.Item {
		Value = (ItsyScape.Utility.valueForItem(50) / 10) * itemProps.count,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = string.format(itemProps.niceName, "Isabellium"),
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = string.format("Resources/Game/Skins/Isabellium/%s.lua", itemName),
		Resource = Item
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = "Isabellium",
		Resource = Item
	}

	ItsyScape.Meta.LootCategory {
		Item = Item,
		Category = ItsyScape.Resource.LootCategory "Legendary"
	}

	Item {
		EquipAction,
		DequipAction,
		TrimAction
	}

	ItsyScape.Utility.tag(Item, "melee")
end

do
	ItsyScape.Meta.Equipment {
		Prayer = 3,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "IsabelliumGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "These gloves resemble the kind Isabelle crafted years ago for her masterwork set of armor.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IsabelliumGloves"
	}

	ItsyScape.Meta.Equipment {
		Prayer = 3,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "IsabelliumBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Will definitely protect your feet if you stub your toe.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IsabelliumBoots"
	}

	ItsyScape.Meta.Equipment {
		Prayer = 5,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "IsabelliumHelmet"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A cool open face helmet!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IsabelliumHelmet"
	}

	ItsyScape.Meta.Equipment {
		Prayer = 7,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "IsabelliumPlatebody"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Has a handy sheathe for your sword. But Isabelle's zweihander definitely couldn't fit in that!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IsabelliumPlatebody"
	}
end

do
	ItsyScape.Resource.Item "IsabelliumShard" {
		-- Nothing.
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(50) / 10,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "IsabelliumShard"
	}

	local CraftAction = ItsyScape.Action.OpenInventoryCraftWindow()

	ItsyScape.Meta.ActionVerb {
		Value = "Trim",
		XProgressive = "Trimming",
		Language = "en-US",
		Action = CraftAction
	}

	ItsyScape.Meta.DelegatedActionTarget {
		CategoryKey = "Metal",
		CategoryValue = "Isabellium",
		ActionType = "Craft",
		Action = CraftAction
	}

	ItsyScape.Resource.Item "IsabelliumShard" {
		CraftAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Isabellium shard",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IsabelliumShard"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A shard of the mysterious alloy Isabelle invented. Shines with potential.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IsabelliumShard"
	}

	ItsyScape.Meta.LootCategory {
		Item = ItsyScape.Resource.Item "IsabelliumShard",
		Category = ItsyScape.Resource.LootCategory "Special"
	}
end

do
	ItsyScape.Resource.Item "IsabellesLootBag" {
		ItsyScape.Action.Craft() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = 1
			},

			Requirement {
				Resource = ItsyScape.Resource.Quest "CalmBeforeTheStorm",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "IsabelliumShard",
				Count = 100
			},

			Output {
				Resource = ItsyScape.Resource.Item "IsabellesLootBag",
				Count = 1
			}
		},

		ItsyScape.Action.LootBag() {
			Requirement {
				Resource = ItsyScape.Resource.Quest "CalmBeforeTheStorm",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.DropTable "Isabelle_LootBag",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Isabelle's loot bag",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IsabellesLootBag"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Contains a legendary item from fighting Isabelle...!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IsabellesLootBag"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = "Isabellium",
		Resource = ItsyScape.Resource.Item "IsabellesLootBag"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(51) * 10,
		Resource = ItsyScape.Resource.Item "IsabellesLootBag"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IsabelliumZweihander",
		Weight = 100,
		Count = 1,
		Resource = ItsyScape.Resource.DropTable "Isabelle_LootBag"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IsabelliumLongbow",
		Weight = 100,
		Count = 1,
		Resource = ItsyScape.Resource.DropTable "Isabelle_LootBag"
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IsabelliumStaff",
		Weight = 100,
		Count = 1,
		Resource = ItsyScape.Resource.DropTable "Isabelle_LootBag"
	}
end

do
	ItsyScape.Resource.Item "IsabelliumZweihander" {
		ItsyScape.Action.Equip() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Attack",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Strength",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Faith",
				Count = ItsyScape.Utility.xpForLevel(10)
			}
		},

		ItsyScape.Action.Dequip()
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(51) * 10,
		Resource = ItsyScape.Resource.Item "IsabelliumZweihander"
	}

	ItsyScape.Meta.Equipment {
		Prayer = 5,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "IsabelliumZweihander"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/Isabellium/IsabelliumZweihander.lua",
		Resource = ItsyScape.Resource.Item "IsabelliumZweihander"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Isabelle's zweihander",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IsabelliumZweihander"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A zweihander with infinite potential; too bad Isabelle wasted all her's.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IsabelliumZweihander"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = "Isabellium",
		Resource = ItsyScape.Resource.Item "IsabelliumZweihander"
	}

	ItsyScape.Meta.LootCategory {
		Item = ItsyScape.Resource.Item "IsabelliumZweihander",
		Category = ItsyScape.Resource.LootCategory "Legendary"
	}
end

do
	ItsyScape.Resource.Item "IsabelliumLongbow" {
		ItsyScape.Action.Equip() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Archery",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Dexterity",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Faith",
				Count = ItsyScape.Utility.xpForLevel(10)
			}
		},

		ItsyScape.Action.Dequip()
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(51) * 10,
		Resource = ItsyScape.Resource.Item "IsabelliumLongbow"
	}

	ItsyScape.Meta.Equipment {
		Prayer = 5,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "IsabelliumLongbow"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/Isabellium/IsabelliumLongbow.lua",
		Resource = ItsyScape.Resource.Item "IsabelliumLongbow"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Isabelle's longbow",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IsabelliumLongbow"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The power of this longbow scales with your innate strength.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IsabelliumLongbow"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = "Isabellium",
		Resource = ItsyScape.Resource.Item "IsabelliumLongbow"
	}

	ItsyScape.Meta.LootCategory {
		Item = ItsyScape.Resource.Item "IsabelliumLongbow",
		Category = ItsyScape.Resource.LootCategory "Legendary"
	}
end

do
	ItsyScape.Resource.Item "IsabelliumStaff" {
		ItsyScape.Action.Equip() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Magic",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Wisdom",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Faith",
				Count = ItsyScape.Utility.xpForLevel(10)
			}
		},

		ItsyScape.Action.Dequip()
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(50) * 10,
		Resource = ItsyScape.Resource.Item "IsabelliumStaff"
	}

	ItsyScape.Meta.Equipment {
		Prayer = 5,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
		Resource = ItsyScape.Resource.Item "IsabelliumStaff"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/Isabellium/IsabelliumStaff.lua",
		Resource = ItsyScape.Resource.Item "IsabelliumStaff"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Isabelle's two-handed staff",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IsabelliumStaff"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Requires both hands to wield. Isabelle crafted this staff from the ancient driftwood splinters and her own unique alloy and is evidence of humanity's ingenuity.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "IsabelliumStaff"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = "Isabellium",
		Resource = ItsyScape.Resource.Item "IsabelliumStaff"
	}

	ItsyScape.Meta.LootCategory {
		Item = ItsyScape.Resource.Item "IsabelliumStaff",
		Category = ItsyScape.Resource.LootCategory "Legendary"
	}
end
