Animation "Dragon Roar" {
	Channel {
		Wait(0.5),

		Shake {
			duration = 1.5,
			interval = 0.05,
			minOffset = 0.25,
			maxOffset = 0.5
		}
	},

	Channel {
		PlaySound "Resources/Game/Animations/Dragon_Roar/Roar.wav",
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Dragon_Roar/Animation.lanim"
	}
}
