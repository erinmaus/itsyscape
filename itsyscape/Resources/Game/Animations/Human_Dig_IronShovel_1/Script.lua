Animation "Human Dig (w/ Iron Shovel)" {
	Channel {
		ApplySkin "Resources/Game/Skins/Iron/Shovel.lua" {
			slot = SLOTS.PLAYER_SLOT_RIGHT_HAND,
			duration = 0.75
		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Human_Dig_IronShovel_1/Animation.lanim"
	}
}
