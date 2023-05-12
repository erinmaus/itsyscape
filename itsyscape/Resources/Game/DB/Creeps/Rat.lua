do
	local Rat = ItsyScape.Resource.Peep "Rat"

	ItsyScape.Resource.Peep "Rat" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Rat.BaseRat",
		Resource = Rat
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rat",
		Language = "en-US",
		Resource = Rat
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "I hope it doesn't have fleas...",
		Language = "en-US",
		Resource = Rat
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(25),
		Resource = Rat
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(25),
		Resource = Rat
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(30),
		Resource = Rat
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(75),
		Resource = Rat
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(30, 1),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(25, 1.1),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(25, 1.1),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(25, 1.1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(20, 1.2),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(30, 0.9),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(30),
		Resource = Rat
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/Rat/Rat_IdleLogic.lua",
		IsDefault = 1,
		Resource = Rat
	}
end

do
	local SkeletalRat = ItsyScape.Resource.Peep "SkeletalRat"

	ItsyScape.Resource.Peep "SkeletalRat" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Rat.SkeletalRat",
		Resource = SkeletalRat
	}

	ItsyScape.Meta.ResourceName {
		Value = "Skeletal rat",
		Language = "en-US",
		Resource = SkeletalRat
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "How is a skeletal rat stronger than a living rat?! Nothing makes sense!",
		Language = "en-US",
		Resource = SkeletalRat
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(35),
		Resource = SkeletalRat
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(35),
		Resource = SkeletalRat
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(40),
		Resource = SkeletalRat
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(75),
		Resource = SkeletalRat
	}

	ItsyScape.Meta.Equipment {
		AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(40, 1),
		DefenseStab = ItsyScape.Utility.styleBonusForItem(35, 1.1),
		DefenseSlash = ItsyScape.Utility.styleBonusForItem(35, 1.1),
		DefenseCrush = ItsyScape.Utility.styleBonusForItem(35, 1.1),
		DefenseMagic = ItsyScape.Utility.styleBonusForItem(30, 1.2),
		DefenseRanged = ItsyScape.Utility.styleBonusForItem(35, 0.9),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(40),
		Resource = SkeletalRat
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/Rat/Rat_IdleLogic.lua",
		IsDefault = 1,
		Resource = SkeletalRat
	}
end
