Animation "The Empty King (Fully Realized) Attack (Magic, 2)" {
	fadesOut = true,

	Blend {
		from = "The Empty King (Fully Realized) Idle (Magic)",
		duration = 0.25
	},

	Channel {
		PlaySound "Resources/Game/Animations/TheEmptyKing_FullyRealized_Attack_Magic2/Sound.wav"
	},

	Target {
		PlayAnimation "Resources/Game/Animations/TheEmptyKing_FullyRealized_Attack_Magic2/Animation.lanim"
	}
}
