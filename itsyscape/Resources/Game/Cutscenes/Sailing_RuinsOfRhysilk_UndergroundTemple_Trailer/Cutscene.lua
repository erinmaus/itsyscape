return Sequence {
	Player:teleport("Anchor_Chasm"),
	Camera:target(Yendor),
	Camera:verticalRotate(-math.pi / 2 - math.pi / 8),
	Camera:zoom(40),
	Map:wait(5),

	Camera:translate(Vector(0, 0, 60)),
	Camera:translate(Vector(0, 0, 0), 2),
	Map:wait(0.5),

	Warrior:playAttackAnimation(Yendor),
	Archer:playAttackAnimation(Yendor),

	Yendor:poke('resurrect'),
	Yendor:wait(1),
	Camera:verticalRotate(-math.pi / 2 + math.pi / 4, 2),
	Yendor:lookAt(Warrior, 0.5),
	Yendor:playAttackAnimation(Warrior),
	Warrior:playAttackAnimation(Yendor),
	Archer:playAttackAnimation(Yendor),
	Map:wait(2),

	Camera:target(Warrior),
	Camera:zoom(10),
	Camera:verticalRotate(-math.pi / 2),

	Yendor:lookAt(Archer, 0.5),
	Yendor:playAttackAnimation(Archer),

	Warrior:yell("Taste this!", 2),
	Warrior:playAnimation("Human_AttackZweihanderSlash_Tornado", "combat", 1000),
	Warrior:wait(2),

	Yendor:lookAt(Archer, 0.5),
	Yendor:playAttackAnimation(Archer),

	Archer:wait(1),
	Archer:playAttackAnimation(Yendor),

	Camera:target(Yendor),
	Camera:zoom(60),
	Archer:fireProjectile(Yendor, "Nuke"),
	Archer:yell("Take that!"),

	Map:wait(5)
}
