Animation "Human Dodge (1)" {
	fadesOut = true,

	Target {
		PlayAnimation "Resources/Game/Animations/Human_Dodge_1/Begin.lanim",
		PlayAnimation "Resources/Game/Animations/Human_Dodge_1/Idle.lanim" {
			repeatAnimation = true
		},
		PlayAnimation "Resources/Game/Animations/Human_Dodge_1/End.lanim"
	}
}
