--------------------------------------------------------------------------------
-- Resources/Game/DB/Spells/ModernCombat.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Meta.ResourceName {
	Value = "Fire Strike",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "FireStrike"
}

ItsyScape.Resource.Spell "FireStrike" {
	ItsyScape.Action.Cast() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(8)
		},

		Input {
			Resource = ItsyScape.Resource.Item "AirRune",
			Count = 5
		},

		Input {
			Resource = ItsyScape.Resource.Item "FireRune",
			Count = 5
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = 20
		}
	}
}

ItsyScape.Meta.CombatSpell {
	Strength = 8,
	Resource = ItsyScape.Resource.Spell "FireStrike"
}

ItsyScape.Utility.tag(ItsyScape.Resource.Spell "FireStrike", "magic")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "FireStrike", "magic_modern_spell")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "FireStrike", "magic_combat_spell")

ItsyScape.Meta.ResourceName {
	Value = "Water Strike",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "WaterStrike"
}

ItsyScape.Resource.Spell "WaterStrike" {
	ItsyScape.Action.Cast() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(6)
		},

		Input {
			Resource = ItsyScape.Resource.Item "AirRune",
			Count = 5
		},

		Input {
			Resource = ItsyScape.Resource.Item "WaterRune",
			Count = 5
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = 15
		}
	}
}

ItsyScape.Meta.CombatSpell {
	Strength = 6,
	Resource = ItsyScape.Resource.Spell "WaterStrike"
}

ItsyScape.Utility.tag(ItsyScape.Resource.Spell "WaterStrike", "magic")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "WaterStrike", "magic_modern_spell")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "WaterStrike", "magic_combat_spell")

ItsyScape.Meta.ResourceName {
	Value = "Earth Strike",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "EarthStrike"
}

ItsyScape.Resource.Spell "EarthStrike" {
	ItsyScape.Action.Cast() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(4)
		},

		Input {
			Resource = ItsyScape.Resource.Item "AirRune",
			Count = 5
		},

		Input {
			Resource = ItsyScape.Resource.Item "EarthRune",
			Count = 5
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = 10
		}
	}
}

ItsyScape.Utility.tag(ItsyScape.Resource.Spell "EarthStrike", "magic")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "EarthStrike", "magic_modern_spell")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "EarthStrike", "magic_combat_spell")

ItsyScape.Meta.CombatSpell {
	Strength = 4,
	Resource = ItsyScape.Resource.Spell "EarthStrike"
}

ItsyScape.Meta.ResourceName {
	Value = "Air Strike",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "AirStrike"
}

ItsyScape.Resource.Spell "AirStrike" {
	ItsyScape.Action.Cast() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Input {
			Resource = ItsyScape.Resource.Item "AirRune",
			Count = 5
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = 5
		}
	}
}

ItsyScape.Meta.CombatSpell {
	Strength = 2,
	Resource = ItsyScape.Resource.Spell "AirStrike"
}

ItsyScape.Utility.tag(ItsyScape.Resource.Spell "AirStrike", "magic")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "AirStrike", "magic_modern_spell")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "AirStrike", "magic_combat_spell")

ItsyScape.Meta.ResourceName {
	Value = "Fire Blast",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "FireBlast"
}

ItsyScape.Resource.Spell "FireBlast" {
	ItsyScape.Action.Cast() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(52)
		},

		Input {
			Resource = ItsyScape.Resource.Item "AirRune",
			Count = 10
		},

		Input {
			Resource = ItsyScape.Resource.Item "FireRune",
			Count = 10
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = 100
		}
	}
}

ItsyScape.Meta.CombatSpell {
	Strength = 64,
	Resource = ItsyScape.Resource.Spell "FireBlast"
}

ItsyScape.Utility.tag(ItsyScape.Resource.Spell "FireBlast", "magic")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "FireBlast", "magic_modern_spell")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "FireBlast", "magic_combat_spell")

ItsyScape.Meta.ResourceName {
	Value = "Water Blast",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "WaterBlast"
}

ItsyScape.Resource.Spell "WaterBlast" {
	ItsyScape.Action.Cast() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(48)
		},

		Input {
			Resource = ItsyScape.Resource.Item "AirRune",
			Count = 10
		},

		Input {
			Resource = ItsyScape.Resource.Item "WaterRune",
			Count = 10
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = 90
		}
	}
}

ItsyScape.Meta.CombatSpell {
	Strength = 56,
	Resource = ItsyScape.Resource.Spell "WaterBlast"
}

ItsyScape.Utility.tag(ItsyScape.Resource.Spell "WaterBlast", "magic")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "WaterBlast", "magic_modern_spell")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "WaterBlast", "magic_combat_spell")

ItsyScape.Meta.ResourceName {
	Value = "Earth Blast",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "EarthBlast"
}

ItsyScape.Resource.Spell "EarthBlast" {
	ItsyScape.Action.Cast() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(44)
		},

		Input {
			Resource = ItsyScape.Resource.Item "AirRune",
			Count = 10
		},

		Input {
			Resource = ItsyScape.Resource.Item "EarthRune",
			Count = 10
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = 70
		}
	}
}

ItsyScape.Utility.tag(ItsyScape.Resource.Spell "EarthBlast", "magic")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "EarthBlast", "magic_modern_spell")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "EarthBlast", "magic_combat_spell")

ItsyScape.Meta.CombatSpell {
	Strength = 48,
	Resource = ItsyScape.Resource.Spell "EarthBlast"
}

ItsyScape.Meta.ResourceName {
	Value = "Air Blast",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "AirBlast"
}

ItsyScape.Resource.Spell "AirBlast" {
	ItsyScape.Action.Cast() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(40)
		},

		Input {
			Resource = ItsyScape.Resource.Item "AirRune",
			Count = 10
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = 60
		}
	}
}

ItsyScape.Meta.CombatSpell {
	Strength = 40,
	Resource = ItsyScape.Resource.Spell "AirBlast"
}

ItsyScape.Utility.tag(ItsyScape.Resource.Spell "AirBlast", "magic")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "AirBlast", "magic_modern_spell")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "AirBlast", "magic_combat_spell")
