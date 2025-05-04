--------------------------------------------------------------------------------
-- Resources/Game/DB/Powers/Melee.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Power "Parry" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForResource(5)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Strength",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}
}

ItsyScape.Meta.PowerSpec {
	Resource = ItsyScape.Resource.Power "Parry"
}

ItsyScape.Meta.CombatPowerTier {
	Tier = 2,
	Resource = ItsyScape.Resource.Power "Parry"
}

ItsyScape.Meta.CombatPowerZealCost {
	MinLevel = 1,
	MaxLevel = 50,
	Skill = ItsyScape.Resource.Skill "Attack",
	Resource = ItsyScape.Resource.Power "Parry"
}

ItsyScape.Meta.ResourceName {
	Value = "Parry",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Parry"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Parries your foe's next attack, preventing damage. As well, prevents the foe's next special attack.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Parry"
}

ItsyScape.Resource.Effect "Power_Parry" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Parry",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Parry"
}

ItsyScape.Meta.ResourceDescription {
	Value = "You are ready to parry the next attack.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Parry"
}

ItsyScape.Resource.Power "Backstab" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForResource(5)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Strength",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}
}

ItsyScape.Meta.CombatPowerTier {
	Tier = 1,
	Resource = ItsyScape.Resource.Power "Backstab"
}

ItsyScape.Meta.CombatPowerZealCost {
	MinLevel = 1,
	MaxLevel = 50,
	Skill = ItsyScape.Resource.Skill "Attack",
	Resource = ItsyScape.Resource.Power "Backstab"
}

ItsyScape.Meta.ResourceName {
	Value = "Backstab",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Backstab"
}

ItsyScape.Meta.ResourceDescription {
	Value = "If the target is not attacking you, deals increased damage.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Backstab"
}

ItsyScape.Resource.Power "Taunt" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForResource(5)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Strength",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}
}

ItsyScape.Meta.CombatPowerTier {
	Tier = 1,
	Resource = ItsyScape.Resource.Power "Taunt"
}

ItsyScape.Meta.CombatPowerZealCost {
	MinLevel = 1,
	MaxLevel = 50,
	Skill = ItsyScape.Resource.Skill "Attack",
	Resource = ItsyScape.Resource.Power "Taunt"
}

ItsyScape.Meta.ResourceName {
	Value = "Taunt",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Taunt"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Enrages the opponent, halving their attack roll. Also draws the attention of mobs focused on other peeps.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Taunt"
}

ItsyScape.Resource.Effect "Power_Taunt" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Taunt",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Taunt"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Enraged, your attack roll is halved.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Taunt"
}

ItsyScape.Resource.Power "Tornado" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForResource(10)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Strength",
			Count = ItsyScape.Utility.xpForResource(10)
		}
	}
}

ItsyScape.Meta.CombatPowerTier {
	Tier = 2,
	Resource = ItsyScape.Resource.Power "Tornado"
}

ItsyScape.Meta.CombatPowerZealCost {
	MinLevel = 5,
	MaxLevel = 55,
	Skill = ItsyScape.Resource.Skill "Attack",
	Resource = ItsyScape.Resource.Power "Tornado"
}

ItsyScape.Meta.ResourceName {
	Value = "Tornado",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Tornado"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Spin around, hitting surrounding enemies once and your target twice.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Tornado"
}

ItsyScape.Resource.Power "Decapitate" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForResource(10)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Strength",
			Count = ItsyScape.Utility.xpForResource(10)
		}
	}
}

ItsyScape.Meta.CombatPowerTier {
	Tier = 3,
	Resource = ItsyScape.Resource.Power "Decapitate"
}

ItsyScape.Meta.CombatPowerZealCost {
	MinLevel = 10,
	MaxLevel = 50,
	Skill = ItsyScape.Resource.Skill "Attack",
	Resource = ItsyScape.Resource.Power "Decapitate"
}

ItsyScape.Meta.ResourceName {
	Value = "Decapitate",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Decapitate"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Attempt to cut off the foe's head. Less accurate attack, but can deal massive damage. Increased effectiveness against the undead.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Decapitate"
}

ItsyScape.Resource.Power "Riposte" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(20)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForResource(20)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Strength",
			Count = ItsyScape.Utility.xpForResource(20)
		}
	}
}

ItsyScape.Meta.PowerSpec {
	IsInstant = 1,
	IsQuick = 1,
	NoTarget = 1,
	Resource = ItsyScape.Resource.Power "Riposte"
}

ItsyScape.Meta.CombatPowerTier {
	Tier = 2,
	Resource = ItsyScape.Resource.Power "Riposte"
}

ItsyScape.Meta.CombatPowerZealCost {
	MinLevel = 20,
	MaxLevel = 50,
	Skill = ItsyScape.Resource.Skill "Attack",
	Resource = ItsyScape.Resource.Power "Riposte"
}

ItsyScape.Meta.ResourceName {
	Value = "Riposte",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Riposte"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Counter the next attack, reflecting some of the damage to your foe. As well, uses your foe's next special attack against them if timed correctly.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Riposte"
}

ItsyScape.Resource.Effect "Power_Riposte" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Riposte",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Riposte"
}

ItsyScape.Meta.ResourceDescription {
	Value = "You are ready to counter the next attack.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Riposte"
}

ItsyScape.Resource.Power "Earthquake" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(30)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForResource(21)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Strength",
			Count = ItsyScape.Utility.xpForResource(21)
		}
	}
}

ItsyScape.Meta.CombatPowerTier {
	Tier = 3,
	Resource = ItsyScape.Resource.Power "Earthquake"
}

ItsyScape.Meta.CombatPowerZealCost {
	MinLevel = 30,
	MaxLevel = 60,
	Skill = ItsyScape.Resource.Skill "Attack",
	Resource = ItsyScape.Resource.Power "Earthquake"
}

ItsyScape.Meta.ResourceName {
	Value = "Earthquake",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Earthquake"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Smash the ground, causing an earthquake around the target. The larger the target, the bigger the earthquake. Damages enemies near the target.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Earthquake"
}

ItsyScape.Resource.Power "Counter" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(40)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForResource(22)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Strength",
			Count = ItsyScape.Utility.xpForResource(22)
		}
	}
}

ItsyScape.Meta.PowerSpec {
	IsInstant = 1,
	IsQuick = 1,
	NoTarget = 1,
	Resource = ItsyScape.Resource.Power "Counter"
}

ItsyScape.Meta.CombatPowerTier {
	Tier = 2,
	Resource = ItsyScape.Resource.Power "Counter"
}

ItsyScape.Meta.CombatPowerZealCost {
	MinLevel = 40,
	MaxLevel = 80,
	Skill = ItsyScape.Resource.Skill "Attack",
	Resource = ItsyScape.Resource.Power "Counter"
}

ItsyScape.Meta.ResourceName {
	Value = "Counter",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Counter"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Wait for an opening to counter the enemy's attack. The next opponent's next successful attack will result in punishing them. Pierces most defenses and buffs.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Counter"
}

ItsyScape.Resource.Effect "Power_Counter" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Counter",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Counter"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The next attack the opponent lands will be countered for up to 400% damage, based on Strength level. Pierces most defenses and buffs.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Counter"
}

