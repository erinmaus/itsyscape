Animation "Drakkenson Wings Flap" {
	fadesOut = true,

	Target {
		PlayAnimation "Resources/Game/Animations/Drakkenson_Wings_Flap/Animation.lanim" {
			repeatAnimation = true,
			bones = {
				"wing.1.r",
				"wing.2.r",
				"wing.3.r",
				"wing.tip.r",
				"wing.1.l",
				"wing.2.l",
				"wing.3.l",
				"wing.tip.l",
			}
		}
	}
}
