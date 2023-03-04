return Sequence {
	Sequence {
		Camera:zoom(40),
		Camera:target(Svalbard),
		Camera:verticalRotate(-math.pi / 2 + math.pi / 8),
		Svalbard:removeBehavior("MashinaBehavior"),
		Svalbard:poke('fly'),
		Svalbard:teleport("Svalbard"),
		Player:teleport("Anchor_Spawn"),
		Player:face(-1),
		Svalbard:lookAt(Player),
		Map:wait(2)
	},

	Sequence {
		Svalbard:poke('equipXWeapon', "Svalbard_Attack_Magic"),
		Svalbard:playAttackAnimation(Player),
		Svalbard:wait(1),
		Player:playAttackAnimation(Svalbard),
		Player:wait(1)
	},

	Sequence {
		Svalbard:poke('land'),
		Svalbard:poke('equipSpecialWeapon', "Svalbard_Special_Dragonfyre"),
		Camera:zoom(20, 0.75),
		Camera:verticalRotate(-math.pi / 2 - math.pi / 6),
		Camera:horizontalRotate(-math.pi / 12, 0.75),
		Svalbard:wait(1.25)
	},

	Sequence {
		Svalbard:playAttackAnimation(Player),
		Camera:target(Player),
		Camera:verticalRotate(-math.pi / 2, 0.75),
		Camera:horizontalRotate(-math.pi / 6),
		Camera:zoom(15),
		Player:talk("Noooooo!"),
		Player:playAnimation("Human_Die_1", 'cutscene', math.huge),
		Player:wait(4)
	}
}
