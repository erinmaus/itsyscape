--------------------------------------------------------------------------------
-- Resources/Game/DB/Init.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "ErrinTheHeathensHat" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(10)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	-- TODO
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensHat"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/ErrinTheHeathen/Helmet.lua",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensHat"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(120),
	Weight = 0,
	Untradeable = 1,
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensHat"
}

ItsyScape.Meta.ResourceName {
	Value = "Errin the Heathen's Hat",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensHat"
}

ItsyScape.Resource.Item "ErrinTheHeathensBoots" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(10)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	-- TODO
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensBoots"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/ErrinTheHeathen/Boots.lua",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensBoots"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(120),
	Weight = 0,
	Untradeable = 1,
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensBoots"
}

ItsyScape.Meta.ResourceName {
	Value = "Errin the Heathen's Boots",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensBoots"
}

ItsyScape.Resource.Item "ErrinTheHeathensGloves" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(10)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	-- TODO
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensGloves"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/ErrinTheHeathen/Gloves.lua",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensGloves"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(120),
	Weight = 0,
	Untradeable = 1,
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensGloves"
}

ItsyScape.Meta.ResourceName {
	Value = "Errin the Heathen's Gloves",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensGloves"
}

ItsyScape.Resource.Item "ErrinTheHeathensCoat" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(10)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	-- TODO
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensCoat"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/ErrinTheHeathen/Body.lua",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensCoat"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(120),
	Weight = 0,
	Untradeable = 1,
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensCoat"
}

ItsyScape.Meta.ResourceName {
	Value = "Errin the Heathen's Coat",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensCoat"
}

ItsyScape.Resource.Item "ErrinTheHeathensStaff" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(10)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	-- TODO
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensStaff"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/ErrinTheHeathen/Staff.lua",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensStaff"
}

ItsyScape.Meta.ResourceName {
	Value = "Errin the Heathen's Staff",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ErrinTheHeathensStaff"
}

ItsyScape.Utility.tag(ItsyScape.Resource.Item "ErrinTheHeathensHat", "x_debug")
ItsyScape.Utility.tag(ItsyScape.Resource.Item "ErrinTheHeathensCoat", "x_debug")
ItsyScape.Utility.tag(ItsyScape.Resource.Item "ErrinTheHeathensGloves", "x_debug")
ItsyScape.Utility.tag(ItsyScape.Resource.Item "ErrinTheHeathensBoots", "x_debug")
ItsyScape.Utility.tag(ItsyScape.Resource.Item "ErrinTheHeathensStaff", "x_debug")
