Animation "Human Attack (Weapon: Grenade, Style: Ranged) 1" {
	Channel {
		ApplySkin "Resources/Game/Skins/NoWeapon/NoWeapon.lua" {
			slot = SLOTS.PLAYER_SLOT_RIGHT_HAND,
			duration = 1
		}
	},
	
	Target {

		PlayAnimation "Resources/Game/Animations/Human_AttackGrenadeRanged_1/Animation.lanim" {
			bones = {
				"root",
				"body",
				"shoulder.r",
				"arm.r",
				"hand.r",
				"shoulder.l",
				"arm.l",
				"hand.l",
				"head"
			}
		}
	}
}
