Animation "Experiment X Idle (Wizard)" {
	Blend {
		from = "Experiment X Idle (Archer)",
		duration = 1
	},

	Blend {
		from = "Experiment X Idle (Warrior)",
		duration = 1
	},

	Target {
		PlayAnimation "Resources/Game/Animations/ExperimentX_Idle_Wizard/Animation.lanim" {
			repeatAnimation = true,
			bones = {
				"body"
			}
		}
	}
}
