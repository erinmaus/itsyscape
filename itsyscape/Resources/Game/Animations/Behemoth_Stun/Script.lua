Animation "Behemoth Stun" {
	fadesOut = true,

	Target {
		PlayAnimation "Resources/Game/Animations/Behemoth_Stun/Animation.lanim" {
			repeatAnimation = true,
			keep = true
		},

		PlayAnimation "Resources/Game/Animations/Behemoth_Stun/Animation.lanim" {
			reverse = true
		}
	}
}
