--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/LeatherArmor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local LEATHERS = {
	["MooishLeather"] = {
		name = "Mooish leather",
		tier = 1,
		weight = 2,
		thread = "PlainThread"
	},

	["BugGuts"] = {
		name = "Chocoroach chitin",
		tier = 10,
		weight = 1.5,
		thread = "PlainThread"
	},

	["RobinFeather"] = {
		name = "Robin feather",
		tier = 20,
		weight = 0.25,
		thread = "PlainThread"
	}
}

local ITEMS = {
	["Gloves"] = {
		niceName = "%s gloves",
		slot = "Gloves",
		hides = 1
	},

	["Boots"] = {
		niceName = "%s boots",
		slot = "Boots",
		hides = 1
	},

	["Coif"] = {
		niceName = "%s coif",
		slot = "Coif",
		hides = 2
	},

	["Body"] = {
		niceName = "%s body",
		slot = "Body",
		hides = 5
	},
}

local SHIELDS = {
	["MooishLeather"] = {
		name = "Mooish buckler",
		hides = 3,
		logs = "CommonLogs"
	},

	["BugGuts"] = {
		name = "Chocoroach chitin",
		hides = 3,
		logs = "WillowLogs"
	}
}

for name, leather in spairs(LEATHERS) do
	for itemName, itemProps in spairs(ITEMS) do
		local ItemName = string.format("%s%s", name, itemName)
		local Item = ItsyScape.Resource.Item(ItemName)

		local EquipAction = ItsyScape.Action.Equip() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Defense",
				Count = ItsyScape.Utility.xpForLevel(leather.tier)
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Dexterity",
				Count = ItsyScape.Utility.xpForLevel(leather.tier)
			}
		}

		local DequipAction = ItsyScape.Action.Dequip()

		local CraftAction = ItsyScape.Action.Craft()
		CraftAction {
			Input {
				Resource = ItsyScape.Resource.Item(string.format("%sHide", name)),
				Count = itemProps.hides
			},

			Input {
				Resource = ItsyScape.Resource.Item(leather.thread),
				Count = math.floor(itemProps.hides * 1.5)
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Needle",
				Count = 1
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(math.max(leather.tier + itemProps.hides, 1))
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(math.max(leather.tier + itemProps.hides + 2, 1)) * itemProps.hides
			},

			Output {
				Resource = Item,
				Count = 1
			}
		}

		ItsyScape.Meta.Item {
			Value = ItsyScape.Utility.valueForItem(leather.tier + itemProps.hides + 2) * itemProps.hides,
			Weight = leather.weight * itemProps.hides,
			Resource = Item
		}

		ItsyScape.Meta.ResourceName {
			Value = string.format(itemProps.niceName, leather.name),
			Language = "en-US",
			Resource = Item
		}

		ItsyScape.Meta.EquipmentModel {
			Type = "ItsyScape.Game.Skin.ModelSkin",
			Filename = string.format("Resources/Game/Skins/%s/%s.lua", name, itemProps.slot),
			Resource = Item
		}

		ItsyScape.Meta.ResourceCategory {
			Key = "Leather",
			Value = name,
			Resource = Item
		}

		Item {
			EquipAction,
			DequipAction,
			CraftAction
		}

		ItsyScape.Utility.tag(Item, "archery armor")
	end
end

for name, itemProps in spairs(SHIELDS) do
	local leather = LEATHERS[name]
	local ItemName = string.format("%sBuckler", name)
	local Item = ItsyScape.Resource.Item(ItemName)

	local EquipAction = ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(leather.tier)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForLevel(leather.tier)
		}
	}

	local DequipAction = ItsyScape.Action.Dequip()

	local CraftAction = ItsyScape.Action.Craft()
	CraftAction {
		Input {
			Resource = ItsyScape.Resource.Item(string.format("%sHide", name)),
			Count = itemProps.hides
		},

		Input {
			Resource = ItsyScape.Resource.Item(leather.thread),
			Count = math.floor(itemProps.hides * 1.5)
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
			Count = ItsyScape.Utility.xpForLevel(math.max(leather.tier + itemProps.hides + 1, 1))
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForResource(math.max(leather.tier + itemProps.hides + 3, 1)) * itemProps.hides
		},

		Output {
			Resource = Item,
			Count = 1
		}
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(leather.tier + itemProps.hides + 3) * 3,
		Weight = leather.weight * itemProps.hides,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = itemProps.name,
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = string.format("Resources/Game/Skins/%s/%s.lua", name, "Buckler"),
		Resource = Item
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Leather",
		Value = name,
		Resource = Item
	}

	Item {
		EquipAction,
		DequipAction,
		CraftAction
	}
end

-- Leather
do
	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(1, 0.5),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(1, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(1, 0.2),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(1, 1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(2, 1),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(3),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "MooishLeatherGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Moo.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MooishLeatherGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(1, 0.3),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(1, 0.5),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(1, 0.2),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(1, 1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(2, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "MooishLeatherBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Moo?",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MooishLeatherBoots"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(2, 0.4),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(2, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(2, 0.3),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(4, 1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(2, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "MooishLeatherCoif"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Moo!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MooishLeatherCoif"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(3, 0.3),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(3, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(3, 0.4),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(7, 1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(3, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "MooishLeatherBody"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Big moo.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MooishLeatherBody"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(5, 0.2),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(5, 0.2),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(5, 0.3),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(2, 1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(10, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND,
		Resource = ItsyScape.Resource.Item "MooishLeatherBuckler"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Passive aggressive moo.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MooishLeatherBuckler"
	}
end

-- Chocoroach chitin
do
	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(11, 0.1),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(11, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(11, 0.2),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(10, 0.1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(15, 0.3),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(5),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "BugGutsGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Made 100% out of organic bug slime.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BugGutsGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(11, 0.2),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(11, 0.2),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(10, 0.2),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(11, 0.1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(15, 0.2),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "BugGutsBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Sounds like stepping on chocoroaches! *shiver*",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BugGutsBoots"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(12, 0.4),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(13, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(13, 0.3),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(15, 0.3),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(16, 0.4),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "BugGutsCoif"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Lets you see your opponents a dozen ways to Tuesday.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BugGutsCoif"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(1, 1),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(13, 0.3),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(13, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(13, 0.4),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(13, 0.3),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(17, 0.5),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "BugGutsBody"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Comes with wings, but won't let you fly.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BugGutsBody"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(15, 0.3),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(15, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(15, 0.3),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(15, 0.4),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(12, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND,
		Resource = ItsyScape.Resource.Item "BugGutsBuckler"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "At least the leg doesn't twitch anymore...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BugGutsBuckler"
	}
end

-- Robin feather
do
	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(21, 0.1),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(21, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(21, 0.2),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(20, 0.1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(25, 0.3),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(5),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "RobinFeatherGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Light and breathable!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RobinFeatherGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(21, 0.2),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(21, 0.2),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(20, 0.2),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(21, 0.1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(25, 0.2),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "RobinFeatherBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Gives you a little pep in your step.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RobinFeatherBoots"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(22, 0.4),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(23, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(23, 0.3),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(25, 0.3),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(26, 0.4),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "RobinFeatherCoif"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Poor birdy.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RobinFeatherCoif"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(1, 1),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(23, 0.3),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(23, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(23, 0.4),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(23, 0.3),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(27, 0.5),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "RobinFeatherBody"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Wings are for angels, not mortals, according to Bastiel's followers.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RobinFeatherBody"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForItem(25, 0.3),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(25, 0.3),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(25, 0.3),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(25, 0.4),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(22, 1),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND,
		Resource = ItsyScape.Resource.Item "RobinFeatherBuckler"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Not sure how feathers can protected you...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RobinFeatherBuckler"
	}
end
