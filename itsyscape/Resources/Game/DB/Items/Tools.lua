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

