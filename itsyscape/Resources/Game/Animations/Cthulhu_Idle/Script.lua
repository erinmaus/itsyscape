Animation "Cthulhu Risen" {
	Blend {
		from = "Cthulhu Attack",
		duration = 0.25
	},

	Blend {
		from = "Cthulhu Defend",
		duration = 0.25
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Cthulhu_Idle/Animation.lanim" {
			repeatAnimation = true
		}
	}
}
