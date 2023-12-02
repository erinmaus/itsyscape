do
	local Rat = ItsyScape.Resource.Peep "Rat"

	ItsyScape.Resource.Peep "Rat" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Rat_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Rat_Secondary",
				Count = 1
			}
		}
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

	ItsyScape.Meta.ResourceTag {
		Value = "Rat",
		Resource = Rat
	}
end

do
	local SkeletalRat = ItsyScape.Resource.Peep "SkeletalRat"

	ItsyScape.Resource.Peep "SkeletalRat" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Rat_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Rat_Secondary",
				Count = 1
			}
		}
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

	ItsyScape.Meta.ResourceTag {
		Value = "Rat",
		Resource = SkeletalRat
	}

	ItsyScape.Meta.ResourceTag {
		Value = "Undead",
		Resource = SkeletalRat
	}
end

do
	local DropTable = ItsyScape.Resource.DropTable "Rat_Primary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "AdamantTrim",
		Weight = 5,
		Count = 2,
		Range = 1,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Bait",
		Weight = 50,
		Count = 100,
		Range = 50,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Coins",
		Weight = 100,
		Count = 5000,
		Range = 2500,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "TinCan",
		Weight = 50,
		Count = 1,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BlueTableSalt",
		Weight = 10,
		Count = 5,
		Range = 3,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "OldBoot",
		Weight = 50,
		Count = 5,
		Range = 3,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "FishEggs",
		Weight = 50,
		Count = 5,
		Range = 3,
		Resource = DropTable
	}
end

do
	local DropTable = ItsyScape.Resource.DropTable "Rat_Secondary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Bones",
		Weight = 100,
		Count = 2,
		Range = 1,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "RatPaw",
		Weight = 200,
		Count = 1,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "RatKingTooth",
		Weight = 5,
		Count = 1,
		Resource = DropTable
	}
end

do
	local Paw = ItsyScape.Resource.Item "RatPaw" {
		ItsyScape.Action.Bury() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Faith",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Input {
				Resource = ItsyScape.Resource.Item "RatPaw",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Faith",
				Count = ItsyScape.Utility.xpForResource(30)
			}
		},

		BoneCraftAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Bones",
		Value = "Rat",
		Resource = ItsyScape.Resource.Item "RatPaw"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rat paw",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RatPaw"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(25) / 3,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "RatPaw"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Better than a monkey's paw! Better bury it, the thing is still twitching!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RatPaw"
	}
end
