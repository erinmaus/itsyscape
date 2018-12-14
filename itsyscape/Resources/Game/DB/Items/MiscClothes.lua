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
	Filename = "Resources/Game/Skins/BrownApron/BrownApron.lua",
	Resource = ItsyScape.Resource.Item "BrownApron"
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
