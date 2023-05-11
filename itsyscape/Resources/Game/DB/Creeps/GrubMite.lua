ItsyScape.Resource.Peep "GrubMite" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Arachnid.GrubMite",
	Resource = ItsyScape.Resource.Peep "GrubMite"
}

ItsyScape.Meta.ResourceName {
	Value = "Grub mite",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "GrubMite"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Eats grub.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "GrubMite"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(75),
	Resource = ItsyScape.Resource.Peep "GrubMite"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(25),
	Resource = ItsyScape.Resource.Peep "GrubMite"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(25),
	Resource = ItsyScape.Resource.Peep "GrubMite"
}

ItsyScape.Meta.Equipment {
	AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(30, 1),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(15, 1.1),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(15, 1.1),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(15, 1.1),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(10, 1.2),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(20, 0.9),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(21),
	Resource = ItsyScape.Resource.Peep "GrubMite"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Arachnid/GrubMite_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "GrubMite"
}
