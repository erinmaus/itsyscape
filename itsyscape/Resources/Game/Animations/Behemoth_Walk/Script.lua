Animation "Behemoth Walk" {
	Blend {
		from = "Behemoth Idle",
		duration = 0.25
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Behemoth_Walk/Animation.lanim" {
			repeatAnimation = true,
			bones = {
				"root",
				"leg1.left.front",
				"leg2.left.front",
				"leg1.right.front",
				"leg2.right.front",
				"leg1.left.back",
				"leg2.left.back",
				"leg1.right.back",
				"leg2.right.back"
			}
		}
	}
}
