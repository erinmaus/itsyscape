Animation "Human Action (Eat) 1" {
	Channel {
		ApplySkin "Resources/Game/Skins/Tools/Spoon.lua" {
			slot = SLOTS.PLAYER_SLOT_RIGHT_HAND,
			duration = 1
		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Human_ActionEat_1/Animation.lanim"
	}
}
