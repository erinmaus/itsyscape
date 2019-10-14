ItsyScape.Resource.Peep "FungalDimension_PanickedCitizen" {
	ItsyScape.Action.Loot() {
		Output {
			Resource = ItsyScape.Resource.DropTable "FungalDimension_PanickedCitizen_Secondary",
			Count = 1
		}
	}
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.FungalDimension.PanickedCitizen",
	Resource = ItsyScape.Resource.Peep "FungalDimension_PanickedCitizen"
}

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge Citizen",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "FungalDimension_PanickedCitizen"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Madness has taken him!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "FungalDimension_PanickedCitizen"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/FungalDimension/PanickedCitizen_RunLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "FungalDimension_PanickedCitizen"
}

ItsyScape.Meta.DropTableEntry {
	Item = ItsyScape.Resource.Item "Bones",
	Weight = 1,
	Count = 1,
	Resource = ItsyScape.Resource.DropTable "FungalDimension_PanickedCitizen_Secondary"	
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "FungalDimension_PanickedCitizen"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "FungalDimension_PanickedCitizen"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "FungalDimension_PanickedCitizen"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "FungalDimension_PanickedCitizen"
}
