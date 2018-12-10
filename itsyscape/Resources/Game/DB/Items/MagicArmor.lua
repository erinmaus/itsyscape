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
	end
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
end
