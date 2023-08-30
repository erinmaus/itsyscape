Animation "Chest Mimic Talk (F)" {
	Blend {
		from = "Chest Mimic Talk (A)",
		duration = 0.125
	},

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

	Target {
		PlayAnimation "Resources/Game/Animations/ChestMimic_F/Animation.lanim" {
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
