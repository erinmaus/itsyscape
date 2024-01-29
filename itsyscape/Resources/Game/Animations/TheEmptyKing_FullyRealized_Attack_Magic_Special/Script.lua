Animation "The Empty King (Fully Realized) Attack (Magic, Special)" {
	fadesOut = true,

	Blend {
		from = "The Empty King (Fully Realized) Idle (Magic)",
		duration = 0.25
	},

	Channel {
		PlaySound "Resources/Game/Animations/TheEmptyKing_FullyRealized_Attack_Magic_Special/Sound.wav"
	},

	Target {
		PlayAnimation "Resources/Game/Animations/TheEmptyKing_FullyRealized_Attack_Magic_Special/Animation.lanim"
	}
}
