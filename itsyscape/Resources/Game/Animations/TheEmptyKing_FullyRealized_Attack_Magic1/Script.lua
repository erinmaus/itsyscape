Animation "The Empty King (Fully Realized) Attack (Magic, 1)" {
	fadesOut = true,

	Blend {
		from = "The Empty King (Fully Realized) Idle (Magic)",
		duration = 0.25
	},

	Channel {
		PlaySound "Resources/Game/Animations/TheEmptyKing_FullyRealized_Attack_Magic1/Sound.wav"
	},

	Target {
		PlayAnimation "Resources/Game/Animations/TheEmptyKing_FullyRealized_Attack_Magic1/Animation.lanim"
	}
}
