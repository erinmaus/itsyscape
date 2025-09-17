Animation "Human Action (Smelt) 1" {
	Channel {
		Wait(1),
		PlaySound "Resources/Game/Animations/Human_ActionSmelt_1/Sound.wav",
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Human_ActionSmelt_1/Animation.lanim",

		Wait(2.5),

		PlayAnimation "Resources/Game/Animations/Human_ActionSmelt_1/Animation.lanim"
	}
}
