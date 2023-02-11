--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Veggies.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "YellowOnion" {
	ItsyScape.Action.Pick() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = ItsyScape.Utility.xpForLevel(5),
		},

		Output {
			Resource = ItsyScape.Resource.Item "YellowOnion",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Yellow onion",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "YellowOnion"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Yum!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "YellowOnion"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Veggies.BaseVeggieProp",
	Resource = ItsyScape.Resource.Prop "YellowOnion"
}

ItsyScape.Resource.Peep "YellowOnion" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Veggies.YellowOnion",
	Resource = ItsyScape.Resource.Peep "YellowOnion"
}

ItsyScape.Meta.ResourceName {
	Value = "Yellow onion",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "YellowOnion"
}

ItsyScape.Meta.ResourceDescription {
	Value = "An angry yellow onion, good for some extra tasty soups!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "YellowOnion"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "YellowOnion"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(20),
	Resource = ItsyScape.Resource.Peep "YellowOnion"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(25),
	Resource = ItsyScape.Resource.Peep "YellowOnion"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(25),
	Resource = ItsyScape.Resource.Peep "YellowOnion"
}

ItsyScape.Meta.Equipment {
	AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(25),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(20, 0.9),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(20, 1),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(20, 1),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(25, 1.3),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(15, 0.5),
	StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(28),
	Resource = ItsyScape.Resource.Peep "YellowOnion"
}

ItsyScape.Resource.Prop "Celery" {
	ItsyScape.Action.Pick() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = ItsyScape.Utility.xpForLevel(5),
		},

		Output {
			Resource = ItsyScape.Resource.Item "Celery",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Celery",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Celery"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Yum!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Celery"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Veggies.BaseVeggieProp",
	Resource = ItsyScape.Resource.Prop "Celery"
}

ItsyScape.Resource.Peep "Celery" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Veggies.Celery",
	Resource = ItsyScape.Resource.Peep "Celery"
}

ItsyScape.Meta.ResourceName {
	Value = "Celery",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Celery"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Ew, who knew celery had ugly roots?!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Celery"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "Celery"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(20),
	Resource = ItsyScape.Resource.Peep "Celery"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(25),
	Resource = ItsyScape.Resource.Peep "Celery"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(25),
	Resource = ItsyScape.Resource.Peep "Celery"
}

ItsyScape.Meta.Equipment {
	AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(25),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(20, 0.9),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(20, 1),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(20, 1),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(10, 0.5),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(25, 1.3),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(30),
	Resource = ItsyScape.Resource.Peep "Celery"
}

ItsyScape.Resource.Prop "Carrot" {
	ItsyScape.Action.Pick() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = ItsyScape.Utility.xpForLevel(5),
		},

		Output {
			Resource = ItsyScape.Resource.Item "Carrot",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Carrot",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Carrot"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Yum!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Carrot"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Veggies.BaseVeggieProp",
	Resource = ItsyScape.Resource.Prop "Carrot"
}

ItsyScape.Resource.Peep "Carrot" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Veggies.Carrot",
	Resource = ItsyScape.Resource.Peep "Carrot"
}

ItsyScape.Meta.ResourceName {
	Value = "Carrot",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Carrot"
}

ItsyScape.Meta.ResourceDescription {
	Value = "This carrot will poke your eyes out!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Carrot"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "Carrot"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(20),
	Resource = ItsyScape.Resource.Peep "Carrot"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(25),
	Resource = ItsyScape.Resource.Peep "Carrot"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(25),
	Resource = ItsyScape.Resource.Peep "Carrot"
}

ItsyScape.Meta.Equipment {
	AccuracyStab = ItsyScape.Utility.styleBonusForWeapon(25),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(20, 0.9),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(20, 1),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(20, 1),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(10, 0.5),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(25, 1.3),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(30),
	Resource = ItsyScape.Resource.Peep "Carrot"
}

ItsyScape.Resource.Prop "GreenPepper" {
	ItsyScape.Action.Pick() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = ItsyScape.Utility.xpForLevel(5),
		},

		Output {
			Resource = ItsyScape.Resource.Item "GreenPepper",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Green pepper",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "GreenPepper"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Yum!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "GreenPepper"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Veggies.BaseVeggieProp",
	Resource = ItsyScape.Resource.Prop "GreenPepper"
}

ItsyScape.Resource.Peep "GreenPepper" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Veggies.GreenPepper",
	Resource = ItsyScape.Resource.Peep "GreenPepper"
}

ItsyScape.Meta.ResourceName {
	Value = "Green pepper",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "GreenPepper"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A hot-headed green pepper!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "GreenPepper"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "GreenPepper"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(20),
	Resource = ItsyScape.Resource.Peep "GreenPepper"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(25),
	Resource = ItsyScape.Resource.Peep "GreenPepper"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(25),
	Resource = ItsyScape.Resource.Peep "GreenPepper"
}

ItsyScape.Meta.Equipment {
	AccuracyCrush = ItsyScape.Utility.styleBonusForWeapon(25),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(20, 0.9),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(20, 1),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(20, 1),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(15, 0.6),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(25, 1.2),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(35),
	Resource = ItsyScape.Resource.Peep "GreenPepper"
}

ItsyScape.Resource.Prop "GreenOnion" {
	ItsyScape.Action.Pick() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = ItsyScape.Utility.xpForLevel(1),
		},

		Output {
			Resource = ItsyScape.Resource.Item "GreenOnion",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = ItsyScape.Utility.xpForResource(1)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Green onion",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "GreenOnion"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Yum!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "GreenOnion"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Veggies.BaseVeggieProp",
	Resource = ItsyScape.Resource.Prop "GreenOnion"
}

ItsyScape.Resource.Peep "GreenOnion" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Veggies.GreenOnion",
	Resource = ItsyScape.Resource.Peep "GreenOnion"
}

ItsyScape.Meta.ResourceName {
	Value = "Green onion",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "GreenOnion"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Such a cute lil' angry creature!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "GreenOnion"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(25),
	Resource = ItsyScape.Resource.Peep "GreenOnion"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(15),
	Resource = ItsyScape.Resource.Peep "GreenOnion"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Magic",
	Value = ItsyScape.Utility.xpForLevel(15),
	Resource = ItsyScape.Resource.Peep "GreenOnion"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Wisdom",
	Value = ItsyScape.Utility.xpForLevel(15),
	Resource = ItsyScape.Resource.Peep "GreenOnion"
}

ItsyScape.Meta.Equipment {
	AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(15),
	DefenseStab = ItsyScape.Utility.styleBonusForItem(10, 0.9),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(10, 1),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(10, 1),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(15, 1.3),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(15, 0.6),
	StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(20),
	Resource = ItsyScape.Resource.Peep "GreenOnion"
}
