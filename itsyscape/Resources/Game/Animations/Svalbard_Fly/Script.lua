Animation "Svalbard Fly" {
	fadesOut = true,

	Target {
		PlayAnimation "Resources/Game/Animations/Svalbard_Fly/Jump.lanim",
		PlayAnimation "Resources/Game/Animations/Svalbard_Fly/Idle.lanim" {
			repeatAnimation = true
		},
		PlayAnimation "Resources/Game/Animations/Svalbard_Fly/Land.lanim"
	}
}
