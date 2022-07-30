--------------------------------------------------------------------------------
-- Resources/Game/DB/Powers/Melee.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

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

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 45,
	MaxReduction = 25,
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
	Value = "If the opponent is not in combat, deals 100-300% damage based on your Strength level.",
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

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 60,
	MaxReduction = 20,
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
	Value = "Enrages the opponent, halving their attack roll but increasing their damage by 50%. Also draws the attention of mobs focused on other peeps.",
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
	Value = "Enraged, your attack roll is halved but your damage is increased by 50%.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Taunt"
}

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
	IsInstant = 1,
	IsQuick = 1,
	NoTarget = 1,
	Resource = ItsyScape.Resource.Power "Parry"
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 120,
	MaxReduction = 30,
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
	Value = "Parries the next melee attack.",
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
	Value = "You are ready to parry the next melee attack.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Parry"
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

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 60,
	MaxReduction = 30,
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

ItsyScape.Resource.Power "Riposte" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForResource(15)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Strength",
			Count = ItsyScape.Utility.xpForResource(15)
		}
	}
}

ItsyScape.Meta.PowerSpec {
	IsInstant = 1,
	IsQuick = 1,
	NoTarget = 1,
	Resource = ItsyScape.Resource.Power "Riposte"
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 120,
	MaxReduction = 30,
	MinLevel = 10,
	MaxLevel = 60,
	Skill = ItsyScape.Resource.Skill "Attack",
	Resource = ItsyScape.Resource.Power "Riposte"
}

ItsyScape.Meta.ResourceName {
	Value = "Riposte",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Riposte"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Counter the next melee attack.",
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
	Value = "You are ready to counter the next melee attack.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Riposte"
}
