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
			EarlReddick:playAnimation("UndeadSquid_Target_Inking"),
			EarlReddick:wait(1.5)
		}
	},

	EarlReddick:talk("*dies*"),
	EarlReddick:playAnimation("Human_Die_1"),
	EarlReddick:wait(2),

	While {
		Player:dialog("EndSuperSupperSaboteurCutscene"),

		Sequence {
			GuardCaptain:wait(0.5),
			GuardCaptain:playAnimation("Human_ActionBury_1"),
			ChefAllon:wait(0.75),
			ChefAllon:playAnimation("Human_ActionBury_1"),

			Map:wait(2)
		}
	},

	Player:removeBehavior("Disabled")
}
