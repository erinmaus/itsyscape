Animation "Experiment X Idle (Archer)" {
	Blend {
		from = "Experiment X Idle (Wizard)",
		duration = 1
	},

	Blend {
		from = "Experiment X Idle (Warrior)",
		duration = 2
	},

	Target {
		PlayAnimation "Resources/Game/Animations/ExperimentX_Idle_Archer/Animation.lanim" {
			repeatAnimation = true,
			bones = {
				"body"
			}
		}
	}
}
