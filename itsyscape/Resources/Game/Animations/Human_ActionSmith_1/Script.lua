Animation "Human Action (Smith) 1" {
	Channel {
		Wait(0.625),

		ApplySkin "Resources/Game/Skins/Tools/Hammer.lua" {
			slot = SLOTS.PLAYER_SLOT_RIGHT_HAND,
			duration = 1.875
		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Human_ActionSmelt_1/Animation.lanim",

		PlaySound "Resources/Game/Animations/Human_ActionSmith_1/Sound.wav",
		PlayAnimation "Resources/Game/Animations/Human_ActionSmith_1/Animation.lanim",
		Wait(0.25),

		PlayAnimation "Resources/Game/Animations/Human_ActionSmelt_1/Animation.lanim",
	}
}
