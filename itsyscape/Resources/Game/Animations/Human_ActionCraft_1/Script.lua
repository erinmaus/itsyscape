Animation "Human Action (Craft) 1" {
	Channel {
		Wait(0.625),

		ApplySkin "Resources/Game/Skins/Tools/Needle.lua" {
			slot = SLOTS.PLAYER_SLOT_RIGHT_HAND,
			duration = 1.875
		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Human_ActionCraft_1/Put.lanim",

		PlaySound "Resources/Game/Animations/Human_ActionCraft_1/Sound.wav",
		PlayAnimation "Resources/Game/Animations/Human_ActionCraft_1/Animation.lanim",
		Wait(0.25),

		PlayAnimation "Resources/Game/Animations/Human_ActionCraft_1/Put.lanim",
	}
}
