Animation "Experiment X Idle (Warrior)" {
	Blend {
		from = "Experiment X Idle (Archer)",
		duration = 2
	},

	Blend {
		from = "Experiment X Idle (Wizard)",
		duration = 1.5
	},

	Target {
		PlayAnimation "Resources/Game/Animations/ExperimentX_Idle_Warrior/Animation.lanim" {
			repeatAnimation = true,
			bones = {
				"body"
			}
		}
	}
}
