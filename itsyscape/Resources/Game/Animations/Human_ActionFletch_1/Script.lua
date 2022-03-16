Animation "Human Action (Fletch) 1" {
	Channel {
		ApplySkin "Resources/Game/Skins/Tools/Knife.lua" {
			slot = SLOTS.PLAYER_SLOT_RIGHT_HAND,
			duration = 1.75
		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Human_ActionFletch_1/Animation.lanim"
	}
}
