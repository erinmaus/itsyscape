Animation "Chest Mimic Talk (E)" {
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
		from = "Chest Mimic Talk (F)",
		duration = 0.125
	},

	blendOut = true,

	Target {
		PlayAnimation "Resources/Game/Animations/ChestMimic_E/Animation.lanim" {
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
