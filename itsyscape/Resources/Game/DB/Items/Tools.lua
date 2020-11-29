--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Tools.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "Tinderbox" {
	-- Nothing.
}

ItsyScape.Meta.Item {
	Value = 1,
	Weight = 0.1,
	Resource = ItsyScape.Resource.Item "Tinderbox"
}

ItsyScape.Meta.ResourceName {
	Value = "Tinderbox",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Tinderbox"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Won't get you any dates.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Tinderbox"
}

ItsyScape.Utility.tag(ItsyScape.Resource.Item "Tinderbox", "tool")

ItsyScape.Resource.Item "Hammer" {
	-- Nothing.
}

ItsyScape.Meta.Item {
	Value = 1,
	Weight = 1.5,
	Resource = ItsyScape.Resource.Item "Hammer"
}

ItsyScape.Meta.ResourceName {
	Value = "Hammer",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Hammer"
}

ItsyScape.Meta.ResourceDescription {
	Value = "If all you have is a hammer, everything looks like a nail.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Hammer"
}

ItsyScape.Utility.tag(ItsyScape.Resource.Item "Hammer", "tool")

ItsyScape.Resource.Item "Needle" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Needle",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Needle"
}

ItsyScape.Meta.Item {
	Value = 1,
	Weight = 0,
	Resource = ItsyScape.Resource.Item "Needle"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Pokey!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Needle"
}

ItsyScape.Utility.tag(ItsyScape.Resource.Item "Needle", "tool")

ItsyScape.Resource.Item "Knife" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Knife",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Knife"
}

ItsyScape.Meta.Item {
	Value = 1,
	Weight = 0,
	Resource = ItsyScape.Resource.Item "Knife"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Stabby!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Knife"
}

ItsyScape.Utility.tag(ItsyScape.Resource.Item "Knife", "tool")

ItsyScape.Resource.Item "WimpyFishingRod" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Fishing",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Utility.tag(ItsyScape.Resource.Item "WimpyFishingRod", "tool")

ItsyScape.Meta.ResourceCategory {
	Key = "WeaponType",
	Value = "fishing-rod",
	Resource = ItsyScape.Resource.Item "WimpyFishingRod"
}

ItsyScape.Meta.Equipment {
	AccuracyCrush  = ItsyScape.Utility.styleBonusForWeapon(2),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(5),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
	Resource = ItsyScape.Resource.Item "WimpyFishingRod"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/WimpyFishingRod/WimpyFishingRod.lua",
	Resource = ItsyScape.Resource.Item "WimpyFishingRod"
}

ItsyScape.Meta.ResourceName {
	Value = "Wimpy fishing rod",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "WimpyFishingRod"
}

ItsyScape.Meta.ResourceDescription {
	Value = "It's for fishing, not phishing!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "WimpyFishingRod"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(5),
	Weight = 5.4,
	Resource = ItsyScape.Resource.Item "WimpyFishingRod"
}

ItsyScape.Resource.Item "Dynamite" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Dynamite",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Dynamite"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(5),
	Weight = 0,
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "Dynamite"
}

ItsyScape.Meta.ResourceDescription {
	Value = "BOOM!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Dynamite"
}

ItsyScape.Resource.Item "IronBlowpipe" {
	ItsyScape.Action.Smith() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(12),
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForLevel(10),
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Hammer",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "IronBar",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "IronBlowpipe",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForResource(12)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForResource(10)
		}
	}
}

ItsyScape.Meta.ResourceCategory {
	Key = "Metal",
	Value = "Iron",
	Resource = ItsyScape.Resource.Item "IronBlowpipe"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(15),
	Weight = 1.6,
	Resource = ItsyScape.Resource.Item "IronBlowpipe"
}

ItsyScape.Meta.ResourceName {
	Value = "Iron glassblowing pipe",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronBlowpipe"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Look at this sucker! Wait, you probably don't wanna do that...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronBlowpipe"
}

ItsyScape.Utility.tag(ItsyScape.Resource.Item "IronBlowpipe", "tool")

ItsyScape.Resource.Item "IronShovel" {
	ItsyScape.Action.Dig(),

	ItsyScape.Action.Smith() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(11),
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Hammer",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "IronBar",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "IronShovel",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForResource(11)
		}
	}
}

ItsyScape.Meta.ResourceCategory {
	Key = "Metal",
	Value = "Iron",
	Resource = ItsyScape.Resource.Item "IronShovel"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(11),
	Weight = 3,
	Resource = ItsyScape.Resource.Item "IronShovel"
}

ItsyScape.Meta.ResourceName {
	Value = "Iron shovel",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronShovel"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Let's dig up some fossils!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronShovel"
}

ItsyScape.Utility.tag(ItsyScape.Resource.Item "IronShovel", "tool")
