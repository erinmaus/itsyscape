Animation "The Empty King (Fully Realized) Attack (Melee, Special)" {
	fadesOut = true,

	Blend {
		from = "The Empty King (Fully Realized) Idle (Melee)",
		duration = 0.25
	},

	Channel {
		PlaySound "Resources/Game/Animations/TheEmptyKing_FullyRealized_Attack_Melee_Special/Sound.wav"
	},

	Target {
		PlayAnimation "Resources/Game/Animations/TheEmptyKing_FullyRealized_Attack_Melee_Special/Animation.lanim"
	}
}
