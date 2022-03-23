--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/LeatherArmor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local FABRICS = {
	["BlueCotton"] = {
		name = "Blue cotton",
		tier = 1,
		weight = 0.5,
		thread = "PlainThread",
		rune = "AirRune"
	},

	["CottonCloth"] = {
		name = "White cotton",
		tier = 10,
		weight = 0,
		thread = "PlainThread",
		rune = "AirRune",

		["Slippers"] = {
			niceName = "%s socks",
			slot = "Slippers",
			fabric = 1
		}
	}
}

local SHIELDS = {
	["BlueCotton"] = {
		name = "Blue book",
		logs = "CommonLogs",
		fabric = 3
	},

	["CottonCloth"] = {
		name = "Boo book",
		logs = "CommonLogs",
		fabric = 3
	}
}

local ITEMS = {
	["Gloves"] = {
		niceName = "%s gloves",
		slot = "Gloves",
		fabric = 1
	},

	["Slippers"] = {
		niceName = "%s slippers",
		slot = "Slippers",
		fabric = 1
	},

	["Hat"] = {
		niceName = "%s hat",
		slot = "Hat",
		fabric = 2
	},

	["Robe"] = {
		niceName = "%s robe",
		slot = "Robe",
		fabric = 5
	},
}

for name, fabric in pairs(FABRICS) do
	for itemName, itemProps in pairs(ITEMS) do
		local ItemName = string.format("%s%s", name, itemName)
		local Item = ItsyScape.Resource.Item(ItemName)

		itemProps = fabric[itemName] or itemProps

		local EquipAction = ItsyScape.Action.Equip() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Defense",
				Count = ItsyScape.Utility.xpForLevel(fabric.tier)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Magic",
				Count = ItsyScape.Utility.xpForLevel(fabric.tier)
			}
		}

		local DequipAction = ItsyScape.Action.Dequip()

		local CraftAction = ItsyScape.Action.Craft()
		CraftAction {
			Input {
				Resource = ItsyScape.Resource.Item(name),
				Count = itemProps.fabric
			},

			Input {
				Resource = ItsyScape.Resource.Item(fabric.thread),
				Count = math.floor(itemProps.fabric * 1.5)
			},

			Input {
				Resource = ItsyScape.Resource.Item(fabric.rune),
				Count = math.floor(itemProps.fabric * 2)
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Needle",
				Count = 1
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(math.max(fabric.tier + itemProps.fabric, 1))
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Magic",
				Count = ItsyScape.Utility.xpForLevel(math.max(fabric.tier + itemProps.fabric, 1))
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(math.max(fabric.tier + itemProps.fabric + 2, 1)) * itemProps.fabric
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Magic",
				Count = ItsyScape.Utility.xpForResource(math.max(fabric.tier + itemProps.fabric + 2, 1)) * itemProps.fabric
			},

			Output {
				Resource = Item,
				Count = 1
			}
		}

		ItsyScape.Meta.Item {
			Value = ItsyScape.Utility.valueForItem(fabric.tier + itemProps.fabric + 2) * itemProps.fabric,
			Weight = fabric.weight * itemProps.fabric,
			Resource = Item
		}

		ItsyScape.Meta.ResourceName {
			Value = string.format(itemProps.niceName, fabric.name),
			Language = "en-US",
			Resource = Item
		}

		ItsyScape.Meta.EquipmentModel {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = string.format("Resources/Game/Skins/%s/%s.lua", name, itemProps.slot),
			Resource = Item
		}

		ItsyScape.Meta.ResourceCategory {
			Key = "Fabric",
			Value = name,
			Resource = Item
		}

		Item {
			EquipAction,
			DequipAction,
			CraftAction
		}

		ItsyScape.Utility.tag(Item, "magic")
	end
end

for name, itemProps in pairs(SHIELDS) do
	local fabric = FABRICS[name]
	local ItemName = string.format("%sShield", name)
	local Item = ItsyScape.Resource.Item(ItemName)

	local EquipAction = ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(fabric.tier)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(fabric.tier)
		}
	}

	local DequipAction = ItsyScape.Action.Dequip()

	local CraftAction = ItsyScape.Action.Craft()
	CraftAction {
		Input {
			Resource = ItsyScape.Resource.Item(name),
			Count = itemProps.fabric
		},

		Input {
			Resource = ItsyScape.Resource.Item(fabric.thread),
			Count = math.floor(itemProps.fabric * 1.5)
		},

		Input {
			Resource = ItsyScape.Resource.Item(fabric.rune),
			Count = math.floor(itemProps.fabric * 2)
		},

		Input {
			Resource = ItsyScape.Resource.Item(itemProps.logs),
			Count = 1
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Needle",
			Count = 1
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForLevel(math.max(fabric.tier + itemProps.fabric + 1, 1))
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(math.max(fabric.tier + itemProps.fabric + 1, 1))
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForResource(math.max(fabric.tier + itemProps.fabric + 3, 1)) * itemProps.fabric
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForResource(math.max(fabric.tier + itemProps.fabric + 3, 1)) * itemProps.fabric
		},

		Output {
			Resource = Item,
			Count = 1
		}
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(fabric.tier + itemProps.fabric + 3) * 3,
		Weight = fabric.weight * itemProps.fabric,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = itemProps.name,
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = string.format("Resources/Game/Skins/%s/%s.lua", name, "Shield"),
		Resource = Item
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Fabric",
		Value = name,
		Resource = Item
	}

	Item {
		EquipAction,
		DequipAction,
		CraftAction
	}
end

-- Blue cotton
do
	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(2, 0.5),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(2, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(2, 0.2),
		DefenseRanged = 0,
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(2, 0.5),
		AccuracyMagic = ItsyScape.Utility.styleBonusForItem(5, 0.1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "BlueCottonGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Not very blue.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlueCottonGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(1, 0.6),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(1, 0.8),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(1, 0.4),
		DefenseRanged = 0,
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(2, 0.5),
		AccuracyMagic = ItsyScape.Utility.styleBonusForItem(5, 0.2),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "BlueCottonSlippers"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "For when you need to kill a demon then hit the hay.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlueCottonSlippers"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(2, 0.7),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(2, 0.7),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(2, 0.7),
		DefenseRanged = 0,
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(2, 0.4),
		AccuracyMagic = ItsyScape.Utility.styleBonusForItem(5, 0.3),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(3, 0.25),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "BlueCottonHat"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "You know what they say about big hats...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlueCottonHat"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(3, 0.6),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(3, 0.6),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(3, 0.7),
		DefenseRanged = 0,
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(3, 0.5),
		AccuracyMagic = ItsyScape.Utility.styleBonusForItem(5, 0.4),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "BlueCottonRobe"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "When you need to be that fumbling old grandpa.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlueCottonRobe"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(10, 0.5),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(10, 1.0),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(10, 0.6),
		DefenseRanged = 0,
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(10, 0.5),
		AccuracyMagic = ItsyScape.Utility.styleBonusForItem(10, 0.3),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND,
		Resource = ItsyScape.Resource.Item "BlueCottonShield"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A glorified picture book. Might as well use it as a shield.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlueCottonShield"
	}
end

-- Cotton cloth
do
	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(13, 0.5),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(13, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(13, 0.2),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(5, 0.1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(13, 0.5),
		AccuracyMagic = ItsyScape.Utility.styleBonusForItem(15, 0.1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "CottonClothGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Are these made out of socks...?",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CottonClothGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(11, 0.6),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(11, 0.8),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(11, 0.4),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(5, 0.1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(12, 0.5),
		AccuracyMagic = ItsyScape.Utility.styleBonusForItem(15, 0.2),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "CottonClothSlippers"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "...socks? Really?",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CottonClothSlippers"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(12, 0.7),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(12, 0.7),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(12, 0.7),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(5, 0.3),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(12, 0.4),
		AccuracyMagic = ItsyScape.Utility.styleBonusForItem(15, 0.3),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(13, 0.3),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "CottonClothHat"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Stinks.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CottonClothHat"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(13, 0.6),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(13, 0.6),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(13, 0.7),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(5, 0.5),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(13, 0.5),
		AccuracyMagic = ItsyScape.Utility.styleBonusForItem(15, 0.4),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "CottonClothRobe"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "This is just made out of a bunch of socks patched together...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CottonClothRobe"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(20, 0.5),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(20, 1.0),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(20, 0.6),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(5, 1.0),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(20, 0.5),
		AccuracyMagic = ItsyScape.Utility.styleBonusForItem(20, 0.3),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND,
		Resource = ItsyScape.Resource.Item "CottonClothShield"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Wow, what a scary book.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CottonClothShield"
	}
end

