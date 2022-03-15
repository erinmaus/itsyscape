Animation "Jellyfish Walk" {
	fadesIn = true,
	fadesOut = true,

	Target {
		PlayAnimation "Resources/Game/Animations/Jellyfish_Walk/Intro.lanim",
		PlayAnimation "Resources/Game/Animations/Jellyfish_Walk/Animation.lanim" {
			repeatAnimation = true
		},
		PlayAnimation "Resources/Game/Animations/Jellyfish_Walk/Outro.lanim"
	}
}
