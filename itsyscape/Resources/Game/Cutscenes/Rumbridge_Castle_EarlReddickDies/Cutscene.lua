return Sequence {
	Player:addBehavior("Disabled"),
	Player:teleport("Anchor_EarlReddick_Player"),
	Player:face(EarlReddick),
	ChefAllon:teleport("Anchor_EarlReddick_Chef"),
	ChefAllon:face(EarlReddick),

	Sequence {
		Camera:target(EarlReddick),
		Camera:zoom(15),
		Camera:verticalRotate(-math.pi / 2)
	},

	Player:dialog("EndSuperSupperSaboteurCutscene"),

	ChefAllon:playAnimation("Human_ActionCook_1"),
	EarlReddick:playAnimation("Human_ActionCook_1"),

	Map:wait(1),
	EarlReddick:playAnimation("Human_ActionEat_1"),
	Map:wait(1),

	While {
		Player:dialog("EndSuperSupperSaboteurCutscene"),

		Sequence {
			EarlReddick:playAnimation("Human_ActionEat_1"),
			EarlReddick:wait(1)
		}
	},

	While {
		Player:dialog("EndSuperSupperSaboteurCutscene"),

		Sequence {
			EarlReddick:playAnimation("UndeadSquid_Target_Inking"),
			EarlReddick:wait(2)
		}
	},

	EarlReddick:talk("*dies*"),
	EarlReddick:playAnimation("Human_Die_1"),
	EarlReddick:wait(2),

	Player:dialog("EndSuperSupperSaboteurCutscene"),

	While {
		Sequence {
			Player:dialog("EndSuperSupperSaboteurCutscene"),

			Parallel {
				ChefAllon:playAnimation("Human_Die_1"),
				ChefAllon:wait(0.5),
				ChefAllon:talk("Please leave me alone! I didn't do it!"),

				Map:wait(1)
			}
		},

		Sequence {
			GuardCaptain:follow(ChefAllon, 1.5),

			ChefAllon:damage(0),
			GuardCaptain:playAttackAnimation(ChefAllon, true)
		}
	},

	Player:removeBehavior("Disabled")
}
