--------------------------------------------------------------------------------
-- Resources/Game/DB/Powers/Defense.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Power "Prepare" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}
}

ItsyScape.Meta.PowerSpec {
	IsInstant = 1,
	IsQuick = 1,
	NoTarget = 1,
	Resource = ItsyScape.Resource.Power "Prepare"
}

ItsyScape.Meta.CombatPowerTier {
	Tier = 1,
	Resource = ItsyScape.Resource.Power "Prepare"
}

ItsyScape.Meta.CombatPowerZealCost {
	MinLevel = 1,
	MaxLevel = 50,
	Skill = ItsyScape.Resource.Skill "Defense",
	Resource = ItsyScape.Resource.Power "Prepare"
}

ItsyScape.Resource.Effect "Power_Prepare" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Prepare",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Prepare"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Prepare to dodge the next attack, negating 50%-100% of the damage depending on your Defense level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Prepare"
}

ItsyScape.Meta.ResourceName {
	Value = "Prepare",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Prepare"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Prepare to dodge the next attack, negating 50%-100% of the damage depending on your Defense level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Prepare"
}

ItsyScape.Resource.Power "Absorb" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}
}

ItsyScape.Meta.PowerSpec {
	IsInstant = 1,
	IsQuick = 1,
	NoTarget = 1,
	Resource = ItsyScape.Resource.Power "Absorb"
}

ItsyScape.Meta.CombatPowerTier {
	Tier = 1,
	Resource = ItsyScape.Resource.Power "Absorb"
}

ItsyScape.Meta.CombatPowerZealCost {
	MinLevel = 1,
	MaxLevel = 50,
	Skill = ItsyScape.Resource.Skill "Defense",
	Resource = ItsyScape.Resource.Power "Absorb"
}

ItsyScape.Resource.Effect "Power_Absorb" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Absorb",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Absorb"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Absorb damage, healing 150-300% of damage received after the effect ends.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Absorb"
}

ItsyScape.Meta.ResourceName {
	Value = "Absorb",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Absorb"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Absorb damage, healing 150-300% of damage received based on your defense level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Absorb"
}

ItsyScape.Resource.Power "IronSkin" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}
}

ItsyScape.Meta.PowerSpec {
	IsInstant = 1,
	IsQuick = 1,
	NoTarget = 1,
	Resource = ItsyScape.Resource.Power "IronSkin"
}

ItsyScape.Meta.CombatPowerTier {
	Tier = 2,
	Resource = ItsyScape.Resource.Power "IronSkin"
}

ItsyScape.Meta.CombatPowerZealCost {
	MinLevel = 1,
	MaxLevel = 50,
	Skill = ItsyScape.Resource.Skill "Defense",
	Resource = ItsyScape.Resource.Power "IronSkin"
}

ItsyScape.Resource.Effect "Power_IronSkin" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Iron Skin",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_IronSkin"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Block all incoming damage, but reduces damage dealt by 100%-50%.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_IronSkin"
}

ItsyScape.Meta.ResourceName {
	Value = "Iron Skin",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "IronSkin"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Block all incoming damage, but reduce damage dealt by 100%-50% based on your Defense level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "IronSkin"
}

ItsyScape.Resource.Power "Freedom" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForResource(10)
		}
	}
}

ItsyScape.Meta.PowerSpec {
	IsInstant = 1,
	IsQuick = 1,
	NoTarget = 1,
	Resource = ItsyScape.Resource.Power "Freedom"
}

ItsyScape.Meta.CombatPowerTier {
	Tier = 1,
	Resource = ItsyScape.Resource.Power "Freedom"
}

ItsyScape.Meta.CombatPowerZealCost {
	MinLevel = 5,
	MaxLevel = 55,
	Skill = ItsyScape.Resource.Skill "Defense",
	Resource = ItsyScape.Resource.Power "Freedom"
}

ItsyScape.Meta.ResourceName {
	Value = "Freedom",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Freedom"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Removes one negative effect at random.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Freedom"
}

ItsyScape.Resource.Power "Bash" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForResource(15)
		}
	}
}

ItsyScape.Meta.CombatPowerTier {
	Tier = 2,
	Resource = ItsyScape.Resource.Power "Bash"
}

ItsyScape.Meta.CombatPowerZealCost {
	MinLevel = 10,
	MaxLevel = 60,
	Skill = ItsyScape.Resource.Skill "Defense",
	Resource = ItsyScape.Resource.Power "Bash"
}

ItsyScape.Meta.ResourceName {
	Value = "Bash",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Bash"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Bash opponent with your shield, stunning them for 10-20 seconds based on your Defense level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Bash"
}

ItsyScape.Resource.Power "Deflect" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(20)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForResource(20)
		}
	}
}

ItsyScape.Meta.PowerSpec {
	IsInstant = 1,
	IsQuick = 1,
	NoTarget = 1,
	Resource = ItsyScape.Resource.Power "Deflect"
}

ItsyScape.Meta.CombatPowerTier {
	Tier = 3,
	Resource = ItsyScape.Resource.Power "Deflect"
}

ItsyScape.Meta.CombatPowerZealCost {
	MinLevel = 1,
	MaxLevel = 50,
	Skill = ItsyScape.Resource.Skill "Defense",
	Resource = ItsyScape.Resource.Power "Deflect"
}

ItsyScape.Resource.Effect "Power_Deflect" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Deflect",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Deflect"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Deflect 50% of all damage received back on the attacker.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Deflect"
}

ItsyScape.Meta.ResourceName {
	Value = "Deflect",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Deflect"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Deflect 50% of all damage received back on the attacker for 20 - 30 seconds, based on defense level. Immediately is lost if shield is dequipped.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Deflect"
}

ItsyScape.Resource.Power "Fury" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(30)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForResource(21)
		}
	}
}

ItsyScape.Meta.PowerSpec {
	IsInstant = 1,
	IsQuick = 1,
	NoTarget = 1,
	Resource = ItsyScape.Resource.Power "Fury"
}

ItsyScape.Meta.CombatPowerTier {
	Tier = 3,
	Resource = ItsyScape.Resource.Power "Fury"
}

ItsyScape.Meta.CombatPowerZealCost {
	MinLevel = 30,
	MaxLevel = 99,
	Skill = ItsyScape.Resource.Skill "Defense",
	Resource = ItsyScape.Resource.Power "Fury"
}

ItsyScape.Resource.Effect "Power_Fury" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Fury",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Fury"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Every successful hit against you increases your minimum and maximum damage from 5% to 10% depending of defense level up to 100%, If no damaging hits are received in 10 - 20 seconds (based on defense level), then the effect is lost.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Fury"
}

ItsyScape.Meta.ResourceName {
	Value = "Fury",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Fury"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Channel your fury, increasing your minimum and maximum damage after every damaging hit.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Fury"
}

ItsyScape.Resource.Power "Meditate" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(40)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForResource(22)
		}
	}
}

ItsyScape.Meta.PowerSpec {
	IsInstant = 1,
	IsQuick = 1,
	NoTarget = 1,
	Resource = ItsyScape.Resource.Power "Meditate"
}

ItsyScape.Meta.CombatPowerTier {
	Tier = 2,
	Resource = ItsyScape.Resource.Power "Meditate"
}

ItsyScape.Meta.CombatPowerZealCost {
	MinLevel = 40,
	MaxLevel = 70,
	Skill = ItsyScape.Resource.Skill "Defense",
	Resource = ItsyScape.Resource.Power "Meditate"
}

ItsyScape.Meta.ResourceName {
	Value = "Meditate",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Meditate"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Clears attack cooldown instantly and removes all movement debuffs.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Meditate"
}

