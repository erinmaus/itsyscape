Animation "Human Action (Craft) 1" {
	Channel {
		ApplySkin "Resources/Game/Skins/Tools/Needle.lua" {
			slot = SLOTS.PLAYER_SLOT_RIGHT_HAND,
			duration = 0.75
		}
	},

	Target {
		PlaySound "Resources/Game/Animations/Human_ActionCraft_1/Sound.wav",
		PlayAnimation "Resources/Game/Animations/Human_ActionCraft_1/Animation.lanim"
	}
}
