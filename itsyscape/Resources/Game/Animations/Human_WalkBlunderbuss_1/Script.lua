Animation "Human Walk (Weapon: Blunderbuss) 1" {
	Channel {
		PlayAnimation "Resources/Game/Animations/Human_WalkBlunderbuss_1/Base.lanim" {
			bones = {
				"leg.r",
				"foot.r",
				"leg.l",
				"foot.l"
			},
			repeatAnimation = true
		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Human_WalkBlunderbuss_1/Animation.lanim" {
			bones = {
				"root",
				"body",
				"shoulder.r",
				"arm.r",
				"hand.r",
				"shoulder.l",
				"arm.l",
				"hand.l",
				"head"
			},
			repeatAnimation = true
		}
	}
}
