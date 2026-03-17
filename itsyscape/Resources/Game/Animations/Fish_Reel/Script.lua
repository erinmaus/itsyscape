Animation "Fish Reel" {
	fadesIn = true,
	fadesOut = true,

	Target {
		PlayAnimation "Resources/Game/Animations/Fish_Reel/Begin.lanim",
		PlayAnimation "Resources/Game/Animations/Fish_Reel/Idle.lanim" {
			repeatAnimation = true
		},
		PlayAnimation "Resources/Game/Animations/Fish_Reel/End.lanim"
	}
}
