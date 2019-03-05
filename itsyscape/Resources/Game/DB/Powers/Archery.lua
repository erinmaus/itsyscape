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
