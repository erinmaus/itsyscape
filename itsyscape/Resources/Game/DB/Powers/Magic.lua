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

ItsyScape.Meta.PowerSpec {
	IsQuick = 1,
	IsInstant = 1,
	Resource = ItsyScape.Resource.Power "Confuse"
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

ItsyScape.Meta.PowerSpec {
	IsQuick = 1,
	IsInstant = 1,
	Resource = ItsyScape.Resource.Power "Weaken"
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

ItsyScape.Meta.PowerSpec {
	IsQuick = 1,
	IsInstant = 1,
	Resource = ItsyScape.Resource.Power "Curse"
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

ItsyScape.Meta.PowerSpec {
	IsQuick = 1,
	IsInstant = 1,
	NoTarget = 1,
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

ItsyScape.Resource.Power "Hexagram" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(20)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForResource(20)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Wisdom",
			Count = ItsyScape.Utility.xpForResource(20)
		}
	}
}

ItsyScape.Meta.PowerSpec {
	IsQuick = 1,
	IsInstant = 1,
	Resource = ItsyScape.Resource.Power "Hexagram"
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 60,
	MaxReduction = 20,
	MinLevel = 20,
	MaxLevel = 60,
	Skill = ItsyScape.Resource.Skill "Magic",
	Resource = ItsyScape.Resource.Power "Hexagram"
}

ItsyScape.Resource.Effect "Power_Hexagram" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Hexagram",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Hexagram"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Prevents you from escaping the hexagram.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_Hexagram"
}

ItsyScape.Meta.ResourceName {
	Value = "Hexagram",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Hexagram"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Binds the foe to a hexagram, preventing them from moving outside of it.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Hexagram"
}

ItsyScape.Resource.Power "IceBarrage" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(30)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForResource(21)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Wisdom",
			Count = ItsyScape.Utility.xpForResource(21)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 90,
	MaxReduction = 30,
	MinLevel = 30,
	MaxLevel = 70,
	Skill = ItsyScape.Resource.Skill "Magic",
	Resource = ItsyScape.Resource.Power "IceBarrage"
}

ItsyScape.Resource.Effect "Power_IceBarrage" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Ice Barrage",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_IceBarrage"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Slows your movement speed by 50%.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Power_IceBarrage"
}

ItsyScape.Meta.ResourceName {
	Value = "Ice Barrage",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "IceBarrage"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Unleash a damaging elemental attack, slowing the foe by 50% for 30 to 60 seconds based on Wisdom level. Deals 100% - 300% damage.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "IceBarrage"
}

ItsyScape.Resource.Power "Gravity" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(40)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForResource(22)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Wisdom",
			Count = ItsyScape.Utility.xpForResource(22)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 150,
	MaxReduction = 30,
	MinLevel = 40,
	MaxLevel = 90,
	Skill = ItsyScape.Resource.Skill "Magic",
	Resource = ItsyScape.Resource.Power "Gravity"
}

ItsyScape.Meta.ResourceName {
	Value = "Gravity",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Gravity"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Deals up to 300% damage. Applies a 10% to 20% debuff directly to the Constitution stat based on damage dealt.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "Gravity"
}

ItsyScape.Resource.Power "BindShadow" {
	ItsyScape.Action.Activate() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(50)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForResource(23)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Wisdom",
			Count = ItsyScape.Utility.xpForResource(23)
		}
	}
}

ItsyScape.Meta.CombatPowerCoolDown {
	BaseCoolDown = 120,
	MaxReduction = 60,
	MinLevel = 50,
	MaxLevel = 90,
	Skill = ItsyScape.Resource.Skill "Magic",
	Resource = ItsyScape.Resource.Power "BindShadow"
}

ItsyScape.Meta.ResourceName {
	Value = "Bind Shadow",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "BindShadow"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Bind the shadow of the opponent to attack, dealing 200% of your opponent's damage against itself.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Power "BindShadow"
}

