local S = Sequence {
	Yendorian:teleport("Anchor_Right"),
	Yendorian:walkTo("Anchor_Left"),

	Tinkerer:teleport("Anchor_Right"),
	Tinkerer:walkTo("Anchor_Left"),

	ChestMimic:teleport("Anchor_Right"),
	ChestMimic:walkTo("Anchor_Left"),

	Svalbard:teleport("Anchor_Right"),
	Svalbard:walkTo("Anchor_Left"),

	RatKing:teleport("Anchor_Right"),
	RatKing:walkTo("Anchor_Left"),

	Cthulhu:teleport("Anchor_Right"),
	Cthulhu:walkTo("Anchor_Left")
}

return Sequence {
	Player:teleport(Vector(-1000, 0, -1000)),

	Camera:target(CameraDolly),
	Camera:translate(Vector(0, 2, 0)),
	CameraDolly:teleport("FireLeft"),
	Camera:zoom(20),
	Camera:verticalRotate(-math.pi / 8),

	S,

	Camera:target(CameraDolly),
	Camera:translate(Vector(0, 2, 0)),
	CameraDolly:teleport("FireRight"),
	Camera:zoom(20),
	Camera:verticalRotate(-math.pi + math.pi / 8),

	S,

	Player:teleport("Anchor_Spawn"),
}
