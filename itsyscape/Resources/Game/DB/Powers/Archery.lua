--------------------------------------------------------------------------------
-- Resources/Game/DB/Powers/Archery.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Power "Shockwave" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForResource(5)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 60,
	MaxReduction = 30,
	MinLevel = 1,
	MaxLevel = 50,
	Skill = ItsyScape.Resource.Skill "Archery",
	Resource = ItsyScape.Resource.Power "Shockwave"
}

ItsyScape.Meta.ResourceName {
	Value = "Shockwave",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Shockwave"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Stuns your opponent for 5-10 seconds and deals 50%-150% damage depending on your Dexterity level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Shockwave"
}

ItsyScape.Resource.Power "DoubleTake" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForResource(5)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 40,
	MaxReduction = 20,
	MinLevel = 1,
	MaxLevel = 50,
	Skill = ItsyScape.Resource.Skill "Archery",
	Resource = ItsyScape.Resource.Power "DoubleTake"
}

ItsyScape.Meta.ResourceName {
	Value = "Double Take",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "DoubleTake"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Shoot two arrows. Should the first hit, the second will also. However, should the first miss, so will the second.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "DoubleTake"
}

ItsyScape.Resource.Power "PiercingShot" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForResource(5)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 60,
	MaxReduction = 20,
	MinLevel = 1,
	MaxLevel = 50,
	Skill = ItsyScape.Resource.Skill "Archery",
	Resource = ItsyScape.Resource.Power "PiercingShot"
}

ItsyScape.Meta.ResourceName {
	Value = "Piercing Shot",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "PiercingShot"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Shoot a piercing shot that hurts all enemies along projectile's path. Target gets deal 50%-200% damage based on Dexterity level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "PiercingShot"
}

ItsyScape.Resource.Power "Boom" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Dynamite",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForResource(10)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForResource(10)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 120,
	MaxReduction = 60,
	MinLevel = 5,
	MaxLevel = 55,
	Skill = ItsyScape.Resource.Skill "Archery",
	Resource = ItsyScape.Resource.Power "Boom"
}

ItsyScape.Meta.ResourceName {
	Value = "Boom!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Boom"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Using a stick of dynamite, drop a bomb at the feet of the target, causing a timed explosion resulting in 100%-300% damage in the immediate area.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Boom"
}

ItsyScape.Resource.Prop "Power_Bomb_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicBomb",
	Resource = ItsyScape.Resource.Prop "Power_Bomb_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Bomb",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Power_Bomb_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Run! Escape! It's gonna blow!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Power_Bomb_Default"
}

ItsyScape.Meta.GatherableProp {
	Health = 4,
	SpawnTime = 1,
	Resource = ItsyScape.Resource.Prop "Power_Bomb_Default"
}

ItsyScape.Resource.Power "Snipe" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForResource(15)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForResource(15)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 60,
	MaxReduction = 30,
	MinLevel = 10,
	MaxLevel = 50,
	Skill = ItsyScape.Resource.Skill "Archery",
	Resource = ItsyScape.Resource.Power "Snipe"
}

ItsyScape.Meta.ResourceName {
	Value = "Snipe",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Snipe"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Carefully aim to always hit the target. Damage scales from 90%-180% based on Dexterity level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Snipe"
}

ItsyScape.Resource.Power "TrickShot" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(20)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForResource(20)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForResource(20)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 60,
	MaxReduction = 30,
	MinLevel = 20,
	MaxLevel = 70,
	Skill = ItsyScape.Resource.Skill "Archery",
	Resource = ItsyScape.Resource.Power "TrickShot"
}

ItsyScape.Resource.Effect "Power_TrickShotDaze" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Daze",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_TrickShotDaze"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Lowers your accuracy and damage by 10%.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_TrickShotDaze"
}

ItsyScape.Meta.ResourceName {
	Value = "Trick Shot",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "TrickShot"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Take a trick shot, dazing the enemy. Always hits, dealing up to 200% damage, but accuracy affects damage. A dazed enemy will have 10% reduced accuracy and damage for 30 seconds.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "TrickShot"
}

ItsyScape.Resource.Power "SoulStrike" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(30)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForResource(21)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForResource(21)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 120,
	MaxReduction = 60,
	MinLevel = 30,
	MaxLevel = 80,
	Skill = ItsyScape.Resource.Skill "Archery",
	Resource = ItsyScape.Resource.Power "SoulStrike"
}

ItsyScape.Meta.ResourceName {
	Value = "Soul Strike",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "SoulStrike"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Debuffs offensive stats and defense directly by 10% their current value. Deals 200%-400%, depending on the strength of the debuffs.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "SoulStrike"
}

ItsyScape.Resource.Power "Headshot" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(40)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForResource(22)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForResource(22)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 90,
	MaxReduction = 30,
	MinLevel = 40,
	MaxLevel = 70,
	Skill = ItsyScape.Resource.Skill "Archery",
	Resource = ItsyScape.Resource.Power "Headshot"
}

ItsyScape.Meta.ResourceName {
	Value = "Headshot",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Headshot"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Aim for the head. Less accurate shot, but damage ranges from 200% - 400% upon a successful hit. This attack deals an extra 100% damage to undead.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Headshot"
}

ItsyScape.Resource.Power "Hesitate" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(50)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForResource(23)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForResource(23)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 60,
	MaxReduction = 20,
	MinLevel = 50,
	MaxLevel = 80,
	Skill = ItsyScape.Resource.Skill "Archery",
	Resource = ItsyScape.Resource.Power "Hesitate"
}

ItsyScape.Meta.ResourceName {
	Value = "Hesitate",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Hesitate"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Take your time before your next shot. Damage is delayed, but accuracy is greatly increased. Deals upwards of 100% damage, ignoring most defenses, buffs, and debuffs.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Hesitate"
}

ItsyScape.Resource.Power "Nuke" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForLevel(60)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Dynamite",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Archery",
			Count = ItsyScape.Utility.xpForResource(25)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForResource(25)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 300,
	MaxReduction = 60,
	MinLevel = 60,
	MaxLevel = 90,
	Skill = ItsyScape.Resource.Skill "Archery",
	Resource = ItsyScape.Resource.Power "Nuke"
}

ItsyScape.Meta.ResourceName {
	Value = "Nuke!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Nuke"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Using a stick of radioactive dynamite, cause a nuclear explosion at the feet of your target, damaging anyone within the blast with up to 500% damage. Afflicted targets will become radioactive for 60 seconds.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Nuke"
}

ItsyScape.Resource.Effect "Radioactive" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Radioactive",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Radioactive"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Increases damage and accuracy by 20%. Can spread to others within melee distance.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Radioactive"
}

