ItsyScape.Resource.Item "RustyHelmet" {
	ItsyScape.Action.Equip(),
	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Rusty helmet",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "RustyHelmet"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/Rusty/Helmet.lua",
	Resource = ItsyScape.Resource.Item "RustyHelmet"
}

ItsyScape.Meta.ResourceCategory {
	Key = "Metal",
	Value = "Rusty",
	Resource = ItsyScape.Resource.Item "RustyHelmet"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(1) * 2,
	Weight = 0,
	Resource = ItsyScape.Resource.Item "RustyHelmet"
}

ItsyScape.Resource.Item "RustyPlatebody" {
	ItsyScape.Action.Equip(),
	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Rusty platebody",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "RustyPlatebody"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/Rusty/Body.lua",
	Resource = ItsyScape.Resource.Item "RustyPlatebody"
}

ItsyScape.Meta.ResourceCategory {
	Key = "Metal",
	Value = "Rusty",
	Resource = ItsyScape.Resource.Item "RustyPlatebody"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(1) * 5,
	Weight = 0,
	Resource = ItsyScape.Resource.Item "RustyPlatebody"
}

ItsyScape.Resource.Item "RustyGloves" {
	ItsyScape.Action.Equip(),
	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Rusty gloves",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "RustyGloves"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/Rusty/Gloves.lua",
	Resource = ItsyScape.Resource.Item "RustyGloves"
}

ItsyScape.Meta.ResourceCategory {
	Key = "Metal",
	Value = "Rusty",
	Resource = ItsyScape.Resource.Item "RustyGloves"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(1),
	Weight = 0,
	Resource = ItsyScape.Resource.Item "RustyGloves"
}

ItsyScape.Resource.Item "RustyBoots" {
	ItsyScape.Action.Equip(),
	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Rusty boots",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "RustyBoots"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/Rusty/Boots.lua",
	Resource = ItsyScape.Resource.Item "RustyBoots"
}

ItsyScape.Meta.ResourceCategory {
	Key = "Metal",
	Value = "Rusty",
	Resource = ItsyScape.Resource.Item "RustyBoots"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(1),
	Weight = 0,
	Resource = ItsyScape.Resource.Item "RustyBoots"
}

ItsyScape.Resource.Item "RustyDagger" {
	ItsyScape.Action.Equip(),
	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Rusty dagger",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "RustyDagger"
}

ItsyScape.Meta.ResourceCategory {
	Key = "Metal",
	Value = "Rusty",
	Resource = ItsyScape.Resource.Item "RustyDagger"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/Rusty/Dagger.lua",
	Resource = ItsyScape.Resource.Item "RustyDagger"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(1),
	Weight = 0,
	Resource = ItsyScape.Resource.Item "RustyDagger"
}

ItsyScape.Meta.Equipment {
	DefenseStab = ItsyScape.Utility.styleBonusForItem(1, 0.5),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(1, 0.3),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(1, 0.2),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(1, 1),
	DefenseMagic = -ItsyScape.Utility.styleBonusForItem(1, 1),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
	Resource = ItsyScape.Resource.Item "RustyGloves"
}

ItsyScape.Meta.ResourceDescription {
	Value = "At least you can't get tetanus from it...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "RustyGloves"
}

ItsyScape.Meta.Equipment {
	DefenseStab = ItsyScape.Utility.styleBonusForItem(1, 0.3),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(1, 0.5),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(1, 0.2),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(1),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(1, 1),
	DefenseMagic = -ItsyScape.Utility.styleBonusForItem(1, 1),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
	Resource = ItsyScape.Resource.Item "RustyBoots"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Rusty boots to protect you from rusty nails buried in the ground.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "RustyBoots"
}

ItsyScape.Meta.Equipment {
	DefenseStab = ItsyScape.Utility.styleBonusForItem(3, 0.4),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(3, 0.3),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(3, 0.3),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(3, 1),
	DefenseMagic = -ItsyScape.Utility.styleBonusForItem(3, 1),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
	Resource = ItsyScape.Resource.Item "RustyHelmet"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Doesn't cure dandruff.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "RustyHelmet"
}

ItsyScape.Meta.Equipment {
	DefenseStab = ItsyScape.Utility.styleBonusForItem(4, 0.3),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(4, 0.3),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(4, 0.4),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(4, 1),
	DefenseMagic = -ItsyScape.Utility.styleBonusForItem(4, 1),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
	Resource = ItsyScape.Resource.Item "RustyPlatebody"
}

ItsyScape.Meta.ResourceDescription {
	Value = "It's probably the worst piece of armor you've ever seen.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "RustyPlatebody"
}

ItsyScape.Meta.Equipment {
	AccuracyStab = ItsyScape.Utility.styleBonusForItem(4, 1.0),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(2),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
	Resource = ItsyScape.Resource.Item "RustyDagger"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Do you want a health code violation? Because this is how you get a health code violation.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "RustyDagger"
}
