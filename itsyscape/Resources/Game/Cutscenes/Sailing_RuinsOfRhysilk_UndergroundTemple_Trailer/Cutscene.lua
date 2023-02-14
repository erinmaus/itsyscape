return Sequence {
	Camera:target(Yendor),
	Camera:verticalRotate(-math.pi / 2 - math.pi / 8),
	Camera:zoom(40),
	Map:wait(5),

	Camera:translate(Vector(0, 0, 60)),
	Camera:translate(Vector(0, 0, 0), 2),
	Map:wait(0.5),

	Yendor:poke('resurrect'),
	Yendor:wait(1),
	Camera:verticalRotate(-math.pi / 2 + math.pi / 4, 2.5),
	Yendor:lookAt(Player),
	Yendor:playAttackAnimation(Player),

	Map:wait(5)
}
