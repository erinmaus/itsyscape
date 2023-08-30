Animation "Chest Mimic Talk (A)" {
	Blend {
		from = "Chest Mimic Talk (B)",
		duration = 0.125
	},

	Blend {
		from = "Chest Mimic Talk (C)",
		duration = 0.125
	},

	Blend {
		from = "Chest Mimic Talk (D)",
		duration = 0.125
	},

	Blend {
		from = "Chest Mimic Talk (E)",
		duration = 0.125
	},

	Blend {
		from = "Chest Mimic Talk (F)",
		duration = 0.125
	},

	Target {
		PlayAnimation "Resources/Game/Animations/ChestMimic_A/Animation.lanim" {
			repeatAnimation = true,
			keep = true,
			bones = {
				"tongue.b",
				"tongue.m",
				"tongue.f",
				"head"
			}
		}
	}
}
