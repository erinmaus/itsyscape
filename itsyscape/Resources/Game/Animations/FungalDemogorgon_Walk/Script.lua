Animation "Fungal Demogorgon Walk" {
	fadesIn = true,
	fadesOut = true,

	Target {
		PlayAnimation "Resources/Game/Animations/FungalDemogorgon_Walk/Transition.lanim",
		PlayAnimation "Resources/Game/Animations/FungalDemogorgon_Walk/Walk.lanim" {
			repeatAnimation = true
		},
		PlayAnimation "Resources/Game/Animations/FungalDemogorgon_Walk/Transition.lanim" {
			reverse = true
		}
	}
}
