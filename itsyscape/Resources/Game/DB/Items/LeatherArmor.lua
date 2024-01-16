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
		tier = 0,
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
	},

	["WhiteWolfHide"] = {
		name = "White wolf hide",
		tier = 30,
		weight = 1.7,
		thread = "PlainThread"
	},

	["AncientKaradon"] = {
		name = "Ancient karadon scale",
		tier = 40,
		weight = 3,
		thread = "PlainThread"
	},

	["GreenDragonhide"] = {
		name = "Green dragonhide",
		tier = 50,
		weight = 3,
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
		name = "Chocoroach chitin buckler",
		hides = 3,
		logs = "WillowLogs"
	},

	["RobinFeather"] = {
		name = "Robin feather buckler",
		hides = 3,
		logs = "OakLogs"
	},

	["WhiteWolfHide"] = {
		name = "White wolf hide buckler",
		hides = 3,
		logs = "MapleLogs"
	},

	["AncientKaradon"] = {
		name = "Ancient karadon scale buckler",
		hides = 3,
		logs = "YewLogs"
	},

	["GreenDragonhide"] = {
		name = "Green dragonhide buckler",
		hides = 3,
		logs = "PetrifiedSpiderLogs"
	}
}

for name, leather in spairs(LEATHERS) do
	for itemName, itemProps in spairs(ITEMS) do
		local ItemName = string.format("%s%s", name, itemName)
		local Item = ItsyScape.Resource.Item(ItemName)

		local EquipAction = ItsyScape.Action.Equip() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Defense",
				Count = ItsyScape.Utility.xpForLevel(math.max(leather.tier, 1))
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Dexterity",
				Count = ItsyScape.Utility.xpForLevel(math.max(leather.tier, 1))
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
			Count = ItsyScape.Utility.xpForLevel(math.max(leather.tier, 1))
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForLevel(math.max(leather.tier, 1))
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
			Count = ItsyScape.Utility.xpForResource(math.max(math.max(leather.tier, 1) + itemProps.hides + 3, 1)) * itemProps.hides
		},

		Output {
			Resource = Item,
			Count = 1
		}
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(math.max(leather.tier, 1) + itemProps.hides + 3) * 3,
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
		DefenseStab = ItsyScape.Utility.styleBonusForHands(2),
		DefenseCrush = ItsyScape.Utility.styleBonusForHands(4),
		DefenseSlash = ItsyScape.Utility.styleBonusForHands(3),
		DefenseRanged = ItsyScape.Utility.styleBonusForHands(3.5),
		DefenseMagic = ItsyScape.Utility.styleBonusForHands(5),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "MooishLeatherGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Moo.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MooishLeatherGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForFeet(1),
		DefenseCrush = ItsyScape.Utility.styleBonusForFeet(2),
		DefenseSlash = ItsyScape.Utility.styleBonusForFeet(2.5),
		DefenseRanged = ItsyScape.Utility.styleBonusForFeet(1.5),
		DefenseMagic = ItsyScape.Utility.styleBonusForFeet(5.5),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "MooishLeatherBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Moo?",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MooishLeatherBoots"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHead(3),
		DefenseCrush = ItsyScape.Utility.styleBonusForHead(3.5),
		DefenseSlash = ItsyScape.Utility.styleBonusForHead(4.75),
		DefenseRanged = ItsyScape.Utility.styleBonusForHead(2.5),
		DefenseMagic = ItsyScape.Utility.styleBonusForHead(6),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "MooishLeatherCoif"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Moo!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MooishLeatherCoif"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForBody(6),
		DefenseCrush = ItsyScape.Utility.styleBonusForBody(5.75),
		DefenseSlash = ItsyScape.Utility.styleBonusForBody(5.5),
		DefenseRanged = ItsyScape.Utility.styleBonusForBody(3),
		DefenseMagic = ItsyScape.Utility.styleBonusForBody(6.5),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "MooishLeatherBody"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Big moo.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MooishLeatherBody"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForShield(5),
		DefenseCrush = ItsyScape.Utility.styleBonusForShield(5),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(5),
		DefenseRanged = ItsyScape.Utility.styleBonusForShield(2),
		DefenseMagic = ItsyScape.Utility.styleBonusForShield(10),
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
		DefenseStab = ItsyScape.Utility.styleBonusForHands(11),
		DefenseCrush = ItsyScape.Utility.styleBonusForHands(12),
		DefenseSlash = ItsyScape.Utility.styleBonusForHands(9),
		DefenseRanged = ItsyScape.Utility.styleBonusForHands(10),
		DefenseMagic = ItsyScape.Utility.styleBonusForHands(15),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "BugGutsGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Made 100% out of organic bug slime.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BugGutsGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForFeet(10),
		DefenseCrush = ItsyScape.Utility.styleBonusForFeet(12),
		DefenseSlash = ItsyScape.Utility.styleBonusForFeet(9),
		DefenseRanged = ItsyScape.Utility.styleBonusForFeet(10),
		DefenseMagic = ItsyScape.Utility.styleBonusForFeet(15.5),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "BugGutsBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Sounds like stepping on chocoroaches! *shiver*",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BugGutsBoots"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHead(12),
		DefenseCrush = ItsyScape.Utility.styleBonusForHead(13),
		DefenseSlash = ItsyScape.Utility.styleBonusForHead(11),
		DefenseRanged = ItsyScape.Utility.styleBonusForHead(12.5),
		DefenseMagic = ItsyScape.Utility.styleBonusForHead(14),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "BugGutsCoif"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Lets you see your opponents a dozen ways to Tuesday.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BugGutsCoif"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForBody(12),
		DefenseCrush = ItsyScape.Utility.styleBonusForBody(12),
		DefenseSlash = ItsyScape.Utility.styleBonusForBody(9),
		DefenseRanged = ItsyScape.Utility.styleBonusForBody(13),
		DefenseMagic = ItsyScape.Utility.styleBonusForBody(11.5),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "BugGutsBody"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Comes with wings, but won't let you fly.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BugGutsBody"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForShield(14),
		DefenseCrush = ItsyScape.Utility.styleBonusForShield(14),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(13),
		DefenseRanged = ItsyScape.Utility.styleBonusForShield(14),
		DefenseMagic = ItsyScape.Utility.styleBonusForShield(12),
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
		DefenseStab = ItsyScape.Utility.styleBonusForHands(19),
		DefenseCrush = ItsyScape.Utility.styleBonusForHands(22.5),
		DefenseSlash = ItsyScape.Utility.styleBonusForHands(23),
		DefenseRanged = ItsyScape.Utility.styleBonusForHands(22),
		DefenseMagic = ItsyScape.Utility.styleBonusForHands(25),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "RobinFeatherGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Light and breathable!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RobinFeatherGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForFeet(21),
		DefenseCrush = ItsyScape.Utility.styleBonusForFeet(23),
		DefenseSlash = ItsyScape.Utility.styleBonusForFeet(18),
		DefenseRanged = ItsyScape.Utility.styleBonusForFeet(22),
		DefenseMagic = ItsyScape.Utility.styleBonusForFeet(25),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "RobinFeatherBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Gives you a little pep in your step.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RobinFeatherBoots"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHead(22),
		DefenseCrush = ItsyScape.Utility.styleBonusForHead(23.5),
		DefenseSlash = ItsyScape.Utility.styleBonusForHead(22.75),
		DefenseRanged = ItsyScape.Utility.styleBonusForHead(25),
		DefenseMagic = ItsyScape.Utility.styleBonusForHead(26),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "RobinFeatherCoif"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Poor birdy.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RobinFeatherCoif"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForBody(25),
		DefenseCrush = ItsyScape.Utility.styleBonusForBody(25.5),
		DefenseSlash = ItsyScape.Utility.styleBonusForBody(25.75),
		DefenseRanged = ItsyScape.Utility.styleBonusForBody(22),
		DefenseMagic = ItsyScape.Utility.styleBonusForBody(27),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "RobinFeatherBody"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Wings are for angels, not mortals, according to Bastiel's followers.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RobinFeatherBody"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForShield(25),
		DefenseCrush = ItsyScape.Utility.styleBonusForShield(24),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(27.5),
		DefenseRanged = ItsyScape.Utility.styleBonusForShield(25),
		DefenseMagic = ItsyScape.Utility.styleBonusForShield(28),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND,
		Resource = ItsyScape.Resource.Item "RobinFeatherBuckler"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Not sure how feathers can protected you...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RobinFeatherBuckler"
	}
end

-- White wolf hide
do
	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHands(30),
		DefenseCrush = ItsyScape.Utility.styleBonusForHands(32),
		DefenseSlash = ItsyScape.Utility.styleBonusForHands(35),
		DefenseRanged = ItsyScape.Utility.styleBonusForHands(31),
		DefenseMagic = ItsyScape.Utility.styleBonusForHands(35.75),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "WhiteWolfHideGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Keeps your fingers toasty.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "WhiteWolfHideGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForFeet(29),
		DefenseCrush = ItsyScape.Utility.styleBonusForFeet(27),
		DefenseSlash = ItsyScape.Utility.styleBonusForFeet(33),
		DefenseRanged = ItsyScape.Utility.styleBonusForFeet(31),
		DefenseMagic = ItsyScape.Utility.styleBonusForFeet(35),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "WhiteWolfHideBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Keeps your toes toasty.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "WhiteWolfHideBoots"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHead(32),
		DefenseCrush = ItsyScape.Utility.styleBonusForHead(33),
		DefenseSlash = ItsyScape.Utility.styleBonusForHead(37),
		DefenseRanged = ItsyScape.Utility.styleBonusForHead(35),
		DefenseMagic = ItsyScape.Utility.styleBonusForHead(38),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "WhiteWolfHideCoif"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Unlike the rest of the armor, this doesn't keep your head toasty.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "WhiteWolfHideCoif"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForBody(39),
		DefenseCrush = ItsyScape.Utility.styleBonusForBody(38),
		DefenseSlash = ItsyScape.Utility.styleBonusForBody(33),
		DefenseRanged = ItsyScape.Utility.styleBonusForBody(35),
		DefenseMagic = ItsyScape.Utility.styleBonusForBody(39.5),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "WhiteWolfHideBody"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Might be too toasty for the most of the Realm...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "WhiteWolfHideBody"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForShield(36),
		DefenseCrush = ItsyScape.Utility.styleBonusForShield(40),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(32),
		DefenseRanged = ItsyScape.Utility.styleBonusForShield(36),
		DefenseMagic = ItsyScape.Utility.styleBonusForShield(34),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND,
		Resource = ItsyScape.Resource.Item "WhiteWolfHideBuckler"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A decent bucker offering good protection, especially against crushing blows.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "WhiteWolfHideBuckler"
	}
end

-- Ancient karadon scales
do
	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHands(39),
		DefenseCrush = ItsyScape.Utility.styleBonusForHands(42),
		DefenseSlash = ItsyScape.Utility.styleBonusForHands(45),
		DefenseRanged = ItsyScape.Utility.styleBonusForHands(43),
		DefenseMagic = ItsyScape.Utility.styleBonusForHands(46),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "AncientKaradonGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Slimy!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AncientKaradonGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForFeet(39),
		DefenseCrush = ItsyScape.Utility.styleBonusForFeet(41),
		DefenseSlash = ItsyScape.Utility.styleBonusForFeet(40),
		DefenseRanged = ItsyScape.Utility.styleBonusForFeet(42),
		DefenseMagic = ItsyScape.Utility.styleBonusForFeet(45),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "AncientKaradonBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Slippery when wet. Or dry.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AncientKaradonBoots"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHead(44),
		DefenseCrush = ItsyScape.Utility.styleBonusForHead(43),
		DefenseSlash = ItsyScape.Utility.styleBonusForHead(42),
		DefenseRanged = ItsyScape.Utility.styleBonusForHead(45),
		DefenseMagic = ItsyScape.Utility.styleBonusForHead(46),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "AncientKaradonCoif"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Smells fishy.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AncientKaradonCoif"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForBody(41.25),
		DefenseCrush = ItsyScape.Utility.styleBonusForBody(41.75),
		DefenseSlash = ItsyScape.Utility.styleBonusForBody(40),
		DefenseRanged = ItsyScape.Utility.styleBonusForBody(39),
		DefenseMagic = ItsyScape.Utility.styleBonusForBody(43),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "AncientKaradonBody"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Not just wizards can wear robes!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AncientKaradonBody"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForShield(46),
		DefenseCrush = ItsyScape.Utility.styleBonusForShield(43),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(44),
		DefenseRanged = ItsyScape.Utility.styleBonusForShield(44.5),
		DefenseMagic = ItsyScape.Utility.styleBonusForShield(50),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND,
		Resource = ItsyScape.Resource.Item "AncientKaradonBuckler"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Weapons, spells, and projectiles just slide off this buckler. Because it's made of slimy fish scales. Get it?",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AncientKaradonBuckler"
	}
end

-- Green dragonhide
do
	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHands(50),
		DefenseCrush = ItsyScape.Utility.styleBonusForHands(55),
		DefenseSlash = ItsyScape.Utility.styleBonusForHands(57.5),
		DefenseRanged = ItsyScape.Utility.styleBonusForHands(53),
		DefenseMagic = ItsyScape.Utility.styleBonusForHands(60),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Resource = ItsyScape.Resource.Item "GreenDragonhideGloves"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Those are some pretty tough gloves!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GreenDragonhideGloves"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForFeet(50),
		DefenseCrush = ItsyScape.Utility.styleBonusForFeet(51.5),
		DefenseSlash = ItsyScape.Utility.styleBonusForFeet(53),
		DefenseRanged = ItsyScape.Utility.styleBonusForFeet(51),
		DefenseMagic = ItsyScape.Utility.styleBonusForFeet(60),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Resource = ItsyScape.Resource.Item "GreenDragonhideBoots"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The finest dragon leather boots this side of the Realm.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GreenDragonhideBoots"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForHead(54),
		DefenseCrush = ItsyScape.Utility.styleBonusForHead(53),
		DefenseSlash = ItsyScape.Utility.styleBonusForHead(52),
		DefenseRanged = ItsyScape.Utility.styleBonusForHead(55),
		DefenseMagic = ItsyScape.Utility.styleBonusForHead(60),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Resource = ItsyScape.Resource.Item "GreenDragonhideCoif"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Aerodynamic.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GreenDragonhideCoif"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForBody(50),
		DefenseCrush = ItsyScape.Utility.styleBonusForBody(55),
		DefenseSlash = ItsyScape.Utility.styleBonusForBody(57),
		DefenseRanged = ItsyScape.Utility.styleBonusForBody(49),
		DefenseMagic = ItsyScape.Utility.styleBonusForBody(61),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Resource = ItsyScape.Resource.Item "GreenDragonhideBody"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Provides the protection of dragon leather, granting amazing defenses against magic.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GreenDragonhideBody"
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = ItsyScape.Utility.styleBonusForShield(56),
		DefenseCrush = ItsyScape.Utility.styleBonusForShield(56),
		DefenseSlash = ItsyScape.Utility.styleBonusForShield(50),
		DefenseRanged = ItsyScape.Utility.styleBonusForShield(53),
		DefenseMagic = ItsyScape.Utility.styleBonusForShield(62),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_LEFT_HAND,
		Resource = ItsyScape.Resource.Item "GreenDragonhideBuckler"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Some say those skilled enough can bounce spells off this buckler toward the foe... But don't believe everything you hear!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "GreenDragonhideBuckler"
	}
end
