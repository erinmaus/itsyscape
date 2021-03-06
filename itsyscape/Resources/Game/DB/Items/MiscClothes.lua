--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/MiscClothes.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "BrownApron" {
	ItsyScape.Action.Equip(),
	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Brown apron",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BrownApron"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Keeps your clothes clean when crafting.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BrownApron"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(2) / 2,
	Weight = 2,
	Resource = ItsyScape.Resource.Item "BrownApron"
}

ItsyScape.Meta.Equipment {
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
	Resource = ItsyScape.Resource.Item "BrownApron"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/Apron/Apron_Brown.lua",
	Resource = ItsyScape.Resource.Item "BrownApron"
}

ItsyScape.Resource.Item "WhiteApron" {
	ItsyScape.Action.Equip(),
	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "White apron",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "WhiteApron"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Can't tell if there's flour on it or not...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "WhiteApron"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(2) / 2,
	Weight = 2,
	Resource = ItsyScape.Resource.Item "WhiteApron"
}

ItsyScape.Meta.Equipment {
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
	Resource = ItsyScape.Resource.Item "WhiteApron"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/Apron/Apron_White.lua",
	Resource = ItsyScape.Resource.Item "WhiteApron"
}

ItsyScape.Resource.Item "GreenApron" {
	ItsyScape.Action.Equip(),
	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Green apron",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GreenApron"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Smells like coffee...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GreenApron"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(2) / 2,
	Weight = 2,
	Resource = ItsyScape.Resource.Item "GreenApron"
}

ItsyScape.Meta.Equipment {
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
	Resource = ItsyScape.Resource.Item "GreenApron"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/Apron/Apron_Green.lua",
	Resource = ItsyScape.Resource.Item "GreenApron"
}

ItsyScape.Resource.Item "ChefsHat" {
	ItsyScape.Action.Equip(),
	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Chefs hat",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ChefsHat"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Gives you the air of confidence, even if you're not really good at cooking.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ChefsHat"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(2) / 2,
	Weight = 2,
	Resource = ItsyScape.Resource.Item "ChefsHat"
}

ItsyScape.Meta.Equipment {
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
	Resource = ItsyScape.Resource.Item "ChefsHat"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/ChefsHat/ChefsHat.lua",
	Resource = ItsyScape.Resource.Item "ChefsHat"
}

ItsyScape.Resource.Item "SailorsHat" {
	ItsyScape.Action.Equip(),
	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Sailor's hat",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "SailorsHat"
}

ItsyScape.Meta.ResourceDescription {
	Value = "How do you know if someone's a sailor? They'll tell you.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "SailorsHat"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(20),
	Weight = -1,
	Resource = ItsyScape.Resource.Item "SailorsHat"
}

ItsyScape.Meta.Equipment {
	Prayer = 4,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
	Resource = ItsyScape.Resource.Item "SailorsHat"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/SailorsHat/SailorsHat.lua",
	Resource = ItsyScape.Resource.Item "SailorsHat"
}

ItsyScape.Resource.Item "FishermansHat" {
	ItsyScape.Action.Equip(),
	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Fisherman's hat",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FishermansHat"
}

ItsyScape.Resource.Item "StrawHat" {
	ItsyScape.Action.Equip(),
	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Straw hat",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "StrawHat"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Keeps the sun out of your eyes.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "StrawHat"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(50),
	Resource = ItsyScape.Resource.Item "StrawHat"
}

ItsyScape.Meta.Equipment {
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
	Resource = ItsyScape.Resource.Item "StrawHat"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/StrawHat/StrawHat.lua",
	Resource = ItsyScape.Resource.Item "StrawHat"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Also makes you look like a ruin plunderin' adventurer.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FishermansHat"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(30),
	Weight = -2,
	Resource = ItsyScape.Resource.Item "FishermansHat"
}

ItsyScape.Meta.Equipment {
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
	Resource = ItsyScape.Resource.Item "FishermansHat"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/FishermansHat/FishermansHat.lua",
	Resource = ItsyScape.Resource.Item "FishermansHat"
}

ItsyScape.Resource.Item "PiratesHat" {
	ItsyScape.Action.Equip() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(10),
			Resource = ItsyScape.Resource.Skill "Sailing"
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Pirate's hat",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "PiratesHat"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Just missing the eye patch.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "PiratesHat"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(25),
	Weight = -4,
	Resource = ItsyScape.Resource.Item "PiratesHat"
}

ItsyScape.Meta.Equipment {
	Prayer = -8,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
	Resource = ItsyScape.Resource.Item "PiratesHat"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/PiratesHat/PiratesHat.lua",
	Resource = ItsyScape.Resource.Item "PiratesHat"
}

ItsyScape.Resource.Item "PiratesHatWithBeard" {
	ItsyScape.Action.Equip() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(15),
			Resource = ItsyScape.Resource.Skill "Sailing"
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Pirate's hat with fake beard",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "PiratesHatWithBeard"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Fake beard, made with real hair.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "PiratesHatWithBeard"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(30) * 1.5,
	Resource = ItsyScape.Resource.Item "PiratesHatWithBeard"
}

ItsyScape.Meta.Equipment {
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
	Resource = ItsyScape.Resource.Item "PiratesHatWithBeard"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/PiratesHat/PiratesHatWithBeard.lua",
	Resource = ItsyScape.Resource.Item "PiratesHatWithBeard"
}
