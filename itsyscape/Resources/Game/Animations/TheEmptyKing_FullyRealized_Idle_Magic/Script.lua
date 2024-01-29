Animation "The Empty King (Fully Realized) Idle (Magic)" {
	Blend {
		from = "The Empty King (Fully Realized) Summon Weapon (Magic)",
		duration = 0.25
	},

	Blend {
		from = "The Empty King (Fully Realized) Attack (Magic, 1)",
		duration = 0.25
	},

	Blend {
		from = "The Empty King (Fully Realized) Attack (Magic, 2)",
		duration = 0.25
	},

	Blend {
		from = "The Empty King (Fully Realized) Attack (Magic, Special)",
		duration = 0.125
	},

	Target {
		PlayAnimation "Resources/Game/Animations/TheEmptyKing_FullyRealized_Idle_Magic/Animation.lanim" {
			repeatAnimation = true
		}
	}
}
