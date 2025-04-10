Animation "Doggo Bark" {
	Channel {
		Wait(15 / 24),
		PlaySound "Resources/Game/Animations/Dog_Bark/Sound.wav"
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Dog_Bark/Animation.lanim"
	}
}
