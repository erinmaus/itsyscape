Animation "Rat Walk (with Transition)" {
	fadesOut = true,

	Target {
		PlayAnimation "Resources/Game/Animations/Rat_Walk/Walk.lanim" {
			repeatAnimation = true
		},
		PlayAnimation "Resources/Game/Animations/Rat_Walk/ToIdle.lanim"
	}
}
