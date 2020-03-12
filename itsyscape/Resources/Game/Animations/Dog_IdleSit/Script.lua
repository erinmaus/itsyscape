Animation "Doggo Idle, Sitting" {
	fadesIn = true,

	Target {
		PlayAnimation "Resources/Game/Animations/Dog_IdleSit/Transition.lanim" {
			reverse = true
		},
		PlayAnimation "Resources/Game/Animations/Dog_IdleSit/Animation.lanim" {
			repeatAnimation = true
		},
		PlayAnimation "Resources/Game/Animations/Dog_IdleSit/Transition.lanim" {
			reverse = false
		}
	}
}
