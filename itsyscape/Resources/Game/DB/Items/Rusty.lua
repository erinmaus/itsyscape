ItsyScape.Resource.Item "RustyHelmet" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	},
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
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	},
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
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	},
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
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	},
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
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	},
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
	DefenseStab = ItsyScape.Utility.styleBonusForHands(1),
	DefenseCrush = ItsyScape.Utility.styleBonusForHands(1),
	DefenseSlash = ItsyScape.Utility.styleBonusForHands(1),
	DefenseRanged = ItsyScape.Utility.styleBonusForHands(1),
	DefenseMagic = -ItsyScape.Utility.styleBonusForHands(1),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
	Resource = ItsyScape.Resource.Item "RustyGloves"
}

ItsyScape.Meta.ResourceDescription {
	Value = "At least you can't get tetanus from it...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "RustyGloves"
}

ItsyScape.Meta.Equipment {
	DefenseStab = ItsyScape.Utility.styleBonusForFeet(1),
	DefenseCrush = ItsyScape.Utility.styleBonusForFeet(1),
	DefenseSlash = ItsyScape.Utility.styleBonusForFeet(1),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(1),
	DefenseRanged = ItsyScape.Utility.styleBonusForFeet(1),
	DefenseMagic = -ItsyScape.Utility.styleBonusForFeet(1),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
	Resource = ItsyScape.Resource.Item "RustyBoots"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Rusty boots to protect you from rusty nails buried in the ground.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "RustyBoots"
}

ItsyScape.Meta.Equipment {
	DefenseStab = ItsyScape.Utility.styleBonusForHead(1),
	DefenseCrush = ItsyScape.Utility.styleBonusForHead(1),
	DefenseSlash = ItsyScape.Utility.styleBonusForHead(1),
	DefenseRanged = ItsyScape.Utility.styleBonusForHead(1),
	DefenseMagic = -ItsyScape.Utility.styleBonusForHead(1),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
	Resource = ItsyScape.Resource.Item "RustyHelmet"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Doesn't cure dandruff.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "RustyHelmet"
}

ItsyScape.Meta.Equipment {
	DefenseStab = ItsyScape.Utility.styleBonusForBody(1),
	DefenseCrush = ItsyScape.Utility.styleBonusForBody(1),
	DefenseSlash = ItsyScape.Utility.styleBonusForBody(1),
	DefenseRanged = ItsyScape.Utility.styleBonusForBody(1),
	DefenseMagic = -ItsyScape.Utility.styleBonusForBody(1),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
	Resource = ItsyScape.Resource.Item "RustyPlatebody"
}

ItsyScape.Meta.ResourceDescription {
	Value = "It's probably the worst piece of armor you've ever seen.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "RustyPlatebody"
}

ItsyScape.Meta.Equipment {
	AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(1),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(3),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_RIGHT_HAND,
	Resource = ItsyScape.Resource.Item "RustyDagger"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Do you want a health code violation? Because this is how you get a health code violation.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "RustyDagger"
}
