Animation "The Empty King (Fully Realized) Idle (Melee)" {
	Blend {
		from = "The Empty King (Fully Realized) Summon Weapon (Melee)",
		duration = 0.25
	},

	Blend {
		from = "The Empty King (Fully Realized) Attack (Melee, 1)",
		duration = 0.5
	},

	Blend {
		from = "The Empty King (Fully Realized) Attack (Melee, 2)",
		duration = 0.125
	},

	Blend {
		from = "The Empty King (Fully Realized) Attack (Melee, Special)",
		duration = 0.25
	},

	Target {
		PlayAnimation "Resources/Game/Animations/TheEmptyKing_FullyRealized_Idle_Melee/Animation.lanim" {
			repeatAnimation = true
		}
	}
}
