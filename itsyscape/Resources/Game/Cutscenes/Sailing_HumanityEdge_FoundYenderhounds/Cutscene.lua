return Sequence {
	CameraDolly:teleport(Player),

	Camera:target(CameraDolly),
	Camera:zoom(10),

	CameraDolly:wait(0.5),
	CameraDolly:lerpPosition("Yenderhound3", 1),

	Camera:zoom(20, 0.5),
	CameraDolly:wait(2)
}
