Animation "Dragon Stunned" {
	fadesIn = true,
	fadesOut = true,

	Channel {
		Wait(30 / 24),
		PlaySound "Resources/Game/Animations/Dragon_Stunned/Impact.wav",

		Shake {
			duration = 1.5,
			interval = 0.05,
			minOffset = 0.25,
			maxOffset = 0.5
		}
	},

	Target {
		PlaySound "Resources/Game/Animations/Dragon_Stunned/Roar.wav",
		PlayAnimation "Resources/Game/Animations/Dragon_Stunned/Begin.lanim",
		PlayAnimation "Resources/Game/Animations/Dragon_Stunned/Idle.lanim" {
			repeatAnimation = true
		},
		PlayAnimation "Resources/Game/Animations/Dragon_Stunned/End.lanim"
	}
}
