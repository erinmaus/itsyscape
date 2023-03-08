Animation "Human Action (Mix) 1" {
	Channel {
		ApplySkin "Resources/Game/Skins/Tools/Vial.lua" {
			slot = SLOTS.PLAYER_SLOT_RIGHT_HAND,
			duration = 40 / 24
		}
	},

	Target {
		PlaySound "Resources/Game/Animations/Human_ActionMix_1/Sound.wav",
		PlayAnimation "Resources/Game/Animations/Human_ActionMix_1/Animation.lanim"
	}
}
