ItsyScape.Resource.Item "CreepyDoll" {
	ItsyScape.Action.Equip(),
	ItsyScape.Action.Dequip(),
	ItsyScape.Action.Craft() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForLevel(77)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(55)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Necromancy",
			Count = ItsyScape.Utility.xpForLevel(50)
		},

		Input {
			Resource = ItsyScape.Resource.Item "UnholySacrificialKnife",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "RottenLogs",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "EldritchMyrrh",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "CreepyDoll",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForResource(77)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForResource(77)
		}
	}
}

ItsyScape.Meta.ResourceCategory {
	Key = "Wood",
	Value = "Rotten",
	Resource = ItsyScape.Resource.Item "CreepyDoll"
}

ItsyScape.Meta.Equipment {
	Prayer = 7,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_POCKET,
	Resource = ItsyScape.Resource.Item "CreepyDoll"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(111) * 3,
	Weight = 0,
	Resource = ItsyScape.Resource.Item "CreepyDoll"
}

ItsyScape.Meta.ResourceName {
	Value = "Creepy doll",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "CreepyDoll"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The doll... It whispers terrible things in the dark...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "CreepyDoll"
}
