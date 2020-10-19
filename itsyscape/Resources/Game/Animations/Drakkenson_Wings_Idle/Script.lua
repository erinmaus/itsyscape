Animation "Drakkenson Wings Idle" {
	fadesIn = true,

	Target {
		PlayAnimation "Resources/Game/Animations/Drakkenson_Wings_Idle/In.lanim" {
			bones = {
				"wing.1.r",
				"wing.2.r",
				"wing.3.r",
				"wing.tip.r",
				"wing.1.l",
				"wing.2.l",
				"wing.3.l",
				"wing.tip.l"
			}
		},

		PlayAnimation "Resources/Game/Animations/Drakkenson_Wings_Idle/Flap.lanim" {
			repeatAnimation = true,

			bones = {
				"wing.1.r",
				"wing.2.r",
				"wing.3.r",
				"wing.tip.r",
				"wing.1.l",
				"wing.2.l",
				"wing.3.l",
				"wing.tip.l"
			}
		}
	}
}
