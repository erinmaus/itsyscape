--------------------------------------------------------------------------------
-- Resources/Game/DB/Powers/Magic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Power "Confuse" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForResource(5)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Wisdom",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 60,
	MaxReduction = 20,
	MinLevel = 1,
	MaxLevel = 50,
	Skill = ItsyScape.Resource.Skill "Magic",
	Resource = ItsyScape.Resource.Power "Confuse"
}

ItsyScape.Resource.Effect "Power_Confuse" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Confuse",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Confuse"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Lowers your accuracy by 10-30% depending on the opponent's Wisdom level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Confuse"
}

ItsyScape.Meta.ResourceName {
	Value = "Confuse",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Confuse"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Lowers your opponent's accuracy by 10-30% depending on your Wisdom level for 30 seconds.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Confuse"
}

ItsyScape.Resource.Power "Weaken" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForResource(5)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Wisdom",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 60,
	MaxReduction = 20,
	MinLevel = 1,
	MaxLevel = 50,
	Skill = ItsyScape.Resource.Skill "Magic",
	Resource = ItsyScape.Resource.Power "Weaken"
}

ItsyScape.Resource.Effect "Power_Weaken" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Weaken",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Weaken"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Lowers your damage by 10-30% depending on the opponent's Wisdom level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Weaken"
}

ItsyScape.Meta.ResourceName {
	Value = "Weaken",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Weaken"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Lowers your opponent's damage by 10-30% depending on your Wisdom level for 30 seconds.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Weaken"
}

ItsyScape.Resource.Power "Curse" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForResource(5)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Wisdom",
			Count = ItsyScape.Utility.xpForResource(5)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 60,
	MaxReduction = 20,
	MinLevel = 1,
	MaxLevel = 50,
	Skill = ItsyScape.Resource.Skill "Magic",
	Resource = ItsyScape.Resource.Power "Curse"
}

ItsyScape.Resource.Effect "Power_Curse" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Curse",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Curse"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Lowers your defense by 10-30% depending on the opponent's Wisdom level.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Curse"
}

ItsyScape.Meta.ResourceName {
	Value = "Curse",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Curse"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Lowers your opponent's defense by 10-30% depending on your Wisdom level for 30 seconds.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Curse"
}

ItsyScape.Resource.Power "Corrupt" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForResource(10)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Wisdom",
			Count = ItsyScape.Utility.xpForResource(10)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 30,
	MaxReduction = 10,
	MinLevel = 5,
	MaxLevel = 35,
	Skill = ItsyScape.Resource.Skill "Magic",
	Resource = ItsyScape.Resource.Power "Corrupt"
}

ItsyScape.Resource.Effect "Power_Corrupt" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Corrupt",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Corrupt"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Inflicts a corrupting influence on you, dealing 100%-300% damage over time.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Corrupt"
}

ItsyScape.Meta.ResourceName {
	Value = "Corrupt",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Corrupt"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Inflicts a corrupting influence on your opponent, dealing 100%-300% damage (based on your Wisdom level) over 10 seconds.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Corrupt"
}
ItsyScape.Resource.Power "Nirvana" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForResource(15)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Wisdom",
			Count = ItsyScape.Utility.xpForResource(15)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 300,
	MaxReduction = 150,
	MinLevel = 10,
	MaxLevel = 100,
	Skill = ItsyScape.Resource.Skill "Magic",
	Resource = ItsyScape.Resource.Power "Nirvana"
}

ItsyScape.Resource.Effect "Power_Nirvana" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Nirvana",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Nirvana"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Channel the power of Prisium, the Great Intelligence, and cast spells without runes.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Nirvana"
}

ItsyScape.Meta.ResourceName {
	Value = "Nirvana",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Nirvana"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Channel the power of Prisium, the Great Intelligence, and eliminate the need of runes for 30 seconds.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Nirvana"
}
