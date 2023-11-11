return Sequence {
	Player:addBehavior("Disabled"),
	Player:teleport("Anchor_EarlReddick_Player"),
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

	Player:fireProjectile(EarlReddick, "ConfettiSplosion"),
	Player:dialog("EndSuperSupperSaboteurCutscene"),

	Player:removeBehavior("Disabled")
}
