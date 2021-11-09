ItsyScape.Resource.Item "IronFlamethrowerTank" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(10)
		},
		Requirement {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForLevel(10)
		}
	},
	ItsyScape.Action.Dequip(),
	ItsyScape.Action.Smith() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(20)
		},

		Input {
			Resource = ItsyScape.Resource.Item "IronBar",
			Count = 5
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForResource(20) * 5
		},

		Output {
			Resource = ItsyScape.Resource.Item "IronFlamethrowerTank",
			Count = 1
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Iron flamethrower tank",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronFlamethrowerTank"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Handle with care or the results could be explosive!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronFlamethrowerTank"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(21) * 5,
	HasUserdata = 1,
	Resource = ItsyScape.Resource.Item "IronFlamethrowerTank"
}

ItsyScape.Meta.ResourceCategory {
	Key = "Metal",
	Value = "Iron",
	Resource = ItsyScape.Resource.Item "IronFlamethrowerTank"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/IronFlamethrower/IronFlamethrowerTank.lua",
	Resource = ItsyScape.Resource.Item "IronFlamethrowerTank"
}

ItsyScape.Meta.Equipment {
	DefenseMagic = -ItsyScape.Utility.styleBonusForItem(5),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_QUIVER,
	Resource = ItsyScape.Resource.Item "IronFlamethrowerTank"
}

ItsyScape.Resource.Item "IronFlamethrowerGun" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(10)
		},
		Requirement {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForLevel(10)
		}
	},
	ItsyScape.Action.Dequip(),
	ItsyScape.Action.Smith() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(20)
		},

		Input {
			Resource = ItsyScape.Resource.Item "IronBar",
			Count = 5
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForResource(20) * 5
		},

		Output {
			Resource = ItsyScape.Resource.Item "IronFlamethrowerGun",
			Count = 1
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Iron flamethrower",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronFlamethrowerGun"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Useful to clear fields or exterminate moths.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronFlamethrowerGun"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(21) * 5,
	Resource = ItsyScape.Resource.Item "IronFlamethrowerGun"
}

ItsyScape.Meta.ResourceCategory {
	Key = "Metal",
	Value = "Iron",
	Resource = ItsyScape.Resource.Item "IronFlamethrowerGun"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/IronFlamethrower/IronFlamethrowerGun.lua",
	Resource = ItsyScape.Resource.Item "IronFlamethrowerGun"
}

ItsyScape.Meta.Equipment {
	AccuracyRanged = ItsyScape.Utility.styleBonusForItem(30),
	StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(25, 1.5),
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
	Resource = ItsyScape.Resource.Item "IronFlamethrowerGun"
}
