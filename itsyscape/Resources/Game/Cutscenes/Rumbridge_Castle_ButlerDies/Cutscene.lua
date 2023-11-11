return Sequence {
	Player:addBehavior("Disabled"),
	Oliver:playAnimation("Darken"),
	Oliver:face(-1),

	Sequence {
		Camera:target(Player),
		Camera:zoom(5),
		Camera:verticalRotate(-math.pi / 2 - math.pi / 8)
	},

	Player:dialog("StartSuperSupperSaboteurCutscene"),

	Sequence {
		Camera:verticalRotate(-math.pi / 2, 0.5),
		Camera:zoom(25, 1.0),

		ButlerLear:playAnimation("Human_Die_1"),
		Oliver:playAnimation("Dog_Attack"),

		Parallel {
			Player:walkTo("Anchor_ButlerLear_PlayerWalkTo"),
			ChefAllon:walkTo("Anchor_ButlerLear_ChefAllonWalkTo"),
		},

		Player:face(-1),
		ChefAllon:face(1),

		Camera:verticalRotate(-math.pi / 2 + math.pi / 8, 0.5),

		Parallel {
			Oliver:walkTo("Anchor_Oliver_RunAway"),
			Oliver:playAnimation("FX_Despawn"),

			Sequence {
				ChefAllon:talk("Oh nooooo!"),
				Player:dialog("StartSuperSupperSaboteurCutscene")
			}
		}
	},

	Player:removeBehavior("Disabled")
}
