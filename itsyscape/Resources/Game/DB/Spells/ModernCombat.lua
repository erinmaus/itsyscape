--------------------------------------------------------------------------------
-- Resources/Game/DB/Spells/ModernCombat.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Effect "FireStrike" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Fire Strike",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "FireStrike"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Increases damage received.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "FireStrike"
}

ItsyScape.Meta.ResourceName {
	Value = "Fire Strike",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "FireStrike"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Strike the foe with fire. Applies a 10% damage-received debuff to opponent for 5 seconds.",
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
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "FireRune",
			Count = 1
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

ItsyScape.Resource.Effect "WaterStrike" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Water Strike",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "WaterStrike"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Lowers defense roll.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "WaterStrike"
}

ItsyScape.Meta.ResourceName {
	Value = "Water Strike",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "WaterStrike"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Strike the foe with water. Applies a 10% defense debuff to the opponent for 5 seconds.",
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
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "WaterRune",
			Count = 1
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

ItsyScape.Resource.Effect "EarthStrike" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Earth Strike",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "EarthStrike"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Lowers accuracy roll.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "EarthStrike"
}

ItsyScape.Meta.ResourceName {
	Value = "Earth Strike",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "EarthStrike"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Strike the foe with earth. Applies a 10% accuracy debuff to opponent for 5 seconds.",
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
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "EarthRune",
			Count = 1
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

ItsyScape.Resource.Effect "AirStrike" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Air Strike",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "AirStrike"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Pushes your foe away.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "AirStrike"
}

ItsyScape.Meta.ResourceName {
	Value = "Air Strike",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "AirStrike"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Strike the foe with air. Also knocks the foe back a tiny bit.",
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
			Count = 1
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

ItsyScape.Meta.ResourceDescription {
	Value = "Blast the foe with fire. Applies a 20% damage-received debuff to opponent for 10 seconds.",
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
			Count = 5
		},

		Input {
			Resource = ItsyScape.Resource.Item "FireRune",
			Count = 5
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

ItsyScape.Meta.ResourceDescription {
	Value = "Blast the foe with water. Applies a 20% defense debuff to the opponent for 10 seconds.",
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
			Count = 5
		},

		Input {
			Resource = ItsyScape.Resource.Item "WaterRune",
			Count = 5
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

ItsyScape.Meta.ResourceDescription {
	Value = "Blast the foe with earth. Applies a 20% accuracy debuff to opponent for 10 seconds.",
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
			Count = 5
		},

		Input {
			Resource = ItsyScape.Resource.Item "EarthRune",
			Count = 5
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

ItsyScape.Meta.ResourceDescription {
	Value = "Blast the foe with air. Also knocks the foe back a bit.",
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
			Count = 5
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

ItsyScape.Meta.ResourceName {
	Value = "Lightning",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "Lightning"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Summons lightning to strike your foe. Yendorians claim this spell was given to the world by Yendor. They use it to smite heathens.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "Lightning"
}

ItsyScape.Resource.Spell "Lightning" {
	ItsyScape.Action.Cast() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(70)
		},

		Input {
			Resource = ItsyScape.Resource.Item "AirRune",
			Count = 10
		},

		Input {
			Resource = ItsyScape.Resource.Item "WaterRune",
			Count = 10
		},

		Input {
			Resource = ItsyScape.Resource.Item "CosmicRune",
			Count = 5
		}
	}
}

ItsyScape.Meta.CombatSpell {
	Strength = 100,
	Resource = ItsyScape.Resource.Spell "Lightning"
}

ItsyScape.Utility.tag(ItsyScape.Resource.Spell "Lightning", "magic")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "Lightning", "magic_modern_spell")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "Lightning", "magic_combat_spell")

ItsyScape.Meta.ResourceName {
	Value = "Infest",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "Infest"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Infest your foe with shadow mites that pierce defense. The higher your wisdom level, the more mites infest your foe.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "Infest"
}

ItsyScape.Resource.Spell "Infest" {
	ItsyScape.Action.Cast() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(40)
		},

		Input {
			Resource = ItsyScape.Resource.Item "EarthRune",
			Count = 4
		},

		Input {
			Resource = ItsyScape.Resource.Item "FireRune",
			Count = 2
		}
	}
}

ItsyScape.Meta.CombatSpell {
	Strength = -16,
	Resource = ItsyScape.Resource.Spell "Infest"
}

ItsyScape.Utility.tag(ItsyScape.Resource.Spell "Infest", "magic")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "Infest", "magic_modern_spell")
ItsyScape.Utility.tag(ItsyScape.Resource.Spell "Infest", "magic_combat_spell")

ItsyScape.Resource.Peep "ShadowMite" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Arachnid.ShadowMite",
	Resource = ItsyScape.Resource.Peep "ShadowMite"
}

ItsyScape.Meta.ResourceName {
	Value = "Shadow mite",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "ShadowMite"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A mite molted in magic.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "ShadowMite"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Constitution",
	Value = ItsyScape.Utility.xpForLevel(1),
	Resource = ItsyScape.Resource.Peep "ShadowMite"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(50),
	Resource = ItsyScape.Resource.Peep "ShadowMite"
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(100),
	Resource = ItsyScape.Resource.Peep "ShadowMite"
}

ItsyScape.Meta.Equipment {
	AccuracyCrush = ItsyScape.Utility.styleBonusForItem(200, 1.5),
	StrengthCrush = ItsyScape.Utility.strengthBonusForWeapon(50, 1),
	Resource = ItsyScape.Resource.Peep "ShadowMite"
}

ItsyScape.Meta.ResourceName {
	Value = "Summon goo",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "SummonGoo"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Surround your foe in goo, reducing their speed by up to 50% for 60 seconds.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "SummonGoo"
}

ItsyScape.Resource.Spell "SummonGoo" {
	ItsyScape.Action.Cast() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(20)
		},

		Input {
			Resource = ItsyScape.Resource.Item "EarthRune",
			Count = 2
		},

		Input {
			Resource = ItsyScape.Resource.Item "WaterRune",
			Count = 2
		},

		Input {
			Resource = ItsyScape.Resource.Item "FireRune",
			Count = 1
		}
	}
}

ItsyScape.Meta.CombatSpell {
	Strength = 24,
	Resource = ItsyScape.Resource.Spell "SummonGoo"
}

ItsyScape.Resource.Effect "SummonGoo" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Sticky Goo",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "SummonGoo"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Slows your movement speed from 10% to 50% for 60 seconds.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "SummonGoo"
}

ItsyScape.Meta.ResourceName {
	Value = "Psychic",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "Psychic"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Pulls your opponent towards you.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "Psychic"
}

ItsyScape.Resource.Spell "Psychic" {
	ItsyScape.Action.Cast() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(35)
		},

		Input {
			Resource = ItsyScape.Resource.Item "AirRune",
			Count = 2
		},

		Input {
			Resource = ItsyScape.Resource.Item "CosmicRune",
			Count = 1
		}
	}
}

ItsyScape.Resource.Peep "MiasmaSkeleton" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Skeleton.MiasmaSkeleton",
	Resource = ItsyScape.Resource.Peep "MiasmaSkeleton"
}

ItsyScape.Meta.ResourceName {
	Value = "Miasma skeleton",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "MiasmaSkeleton"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A horrible agent of death.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "MiasmaSkeleton"
}

ItsyScape.Meta.CombatSpell {
	Strength = 30,
	Resource = ItsyScape.Resource.Spell "Psychic"
}

ItsyScape.Resource.Effect "Psychic" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Telepathic pull",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Psychic"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Pulls your opponent closer.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Psychic"
}

ItsyScape.Meta.ResourceName {
	Value = "Icicle",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "Icicle"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Make an icicle out of thin air and crash it on your opponent, dealing physical stab damage.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "Icicle"
}

ItsyScape.Resource.Spell "Icicle" {
	ItsyScape.Action.Cast() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Input {
			Resource = ItsyScape.Resource.Item "AirRune",
			Count = 3
		},

		Input {
			Resource = ItsyScape.Resource.Item "WaterRune",
			Count = 2
		}
	}
}

ItsyScape.Meta.CombatSpell {
	Strength = 16,
	Resource = ItsyScape.Resource.Spell "Icicle"
}

ItsyScape.Meta.ResourceName {
	Value = "Miasma",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "Miasma"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Summon miasma to fly at your foe, slowing their attacks by up to 10% for 60 seconds.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "Miasma"
}

ItsyScape.Resource.Spell "Miasma" {
	ItsyScape.Action.Cast() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(55)
		},

		Input {
			Resource = ItsyScape.Resource.Item "AirRune",
			Count = 5
		},

		Input {
			Resource = ItsyScape.Resource.Item "EarthRune",
			Count = 5
		},

		Input {
			Resource = ItsyScape.Resource.Item "WaterRune",
			Count = 4
		},

		Input {
			Resource = ItsyScape.Resource.Item "FireRune",
			Count = 2
		}
	}
}

ItsyScape.Meta.CombatSpell {
	Strength = 24,
	Resource = ItsyScape.Resource.Spell "Miasma"
}

ItsyScape.Resource.Effect "Miasma" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Miasma",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Miasma"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Slows your fighting speed from 2% to 10% for 60 seconds.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Miasma"
}
