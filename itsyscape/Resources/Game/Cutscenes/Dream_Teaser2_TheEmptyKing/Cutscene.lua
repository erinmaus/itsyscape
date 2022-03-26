return Sequence {
	Camera:target(TheEmptyKing),
	Camera:zoom(1),
	Camera:horizontalRotate(0),
	Camera:translate(Vector(1, 0.5, 10), 0),
	Map:wait(2),
	Camera:translate(Vector(1, 0.5, 2), 1.5),
	Map:wait(5)
}
