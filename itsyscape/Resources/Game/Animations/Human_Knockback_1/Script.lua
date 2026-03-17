Animation "Human Knockback (1)" {
	fadesOut = true,

	Target {
		PlayAnimation "Resources/Game/Animations/Human_Knockback_1/Begin.lanim",
		PlayAnimation "Resources/Game/Animations/Human_Knockback_1/Idle.lanim" {
			repeatAnimation = true
		},
		PlayAnimation "Resources/Game/Animations/Human_Knockback_1/End.lanim"
	}
}
