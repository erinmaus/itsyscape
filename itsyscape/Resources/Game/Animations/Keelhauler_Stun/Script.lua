Animation "Keelhauler Stun" {
	Blend {
		from = "Keelhauler Run",
		duration = 0.25
	},

	fadesIn = true,
	fadesOut = true,

	Target {
		PlayAnimation "Resources/Game/Animations/Keelhauler_Stun/Sit.lanim",
		PlayAnimation "Resources/Game/Animations/Keelhauler_Stun/Idle.lanim" {
			repeatAnimation = true
		}
	}
}
