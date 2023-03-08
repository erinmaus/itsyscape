Animation "Human Action (Smith) 1" {
	Channel {
		ApplySkin "Resources/Game/Skins/Tools/Hammer.lua" {
			slot = SLOTS.PLAYER_SLOT_RIGHT_HAND,
			duration = 1.875
		}
	},

	Target {
		PlaySound "Resources/Game/Animations/Human_ActionSmith_1/Sound.wav",
		PlayAnimation "Resources/Game/Animations/Human_ActionSmith_1/Animation.lanim"
	}
}
