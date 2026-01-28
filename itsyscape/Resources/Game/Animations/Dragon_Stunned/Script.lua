Animation "Dragon Stunned" {
	fadesIn = true,
	fadesOut = true,

	Target {
		PlayAnimation "Resources/Game/Animations/Dragon_Stunned/Begin.lanim",
		PlayAnimation "Resources/Game/Animations/Dragon_Stunned/Idle.lanim" {
			repeatAnimation = true
		},
		PlayAnimation "Resources/Game/Animations/Dragon_Stunned/End.lanim"
	}
}
