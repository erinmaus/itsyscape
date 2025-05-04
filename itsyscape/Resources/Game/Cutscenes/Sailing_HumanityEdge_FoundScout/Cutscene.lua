return Sequence {
	CameraDolly:teleport(Player),

	Camera:target(CameraDolly),
	Camera:zoom(10),

	CameraDolly:wait(0.5),
	CameraDolly:lerpPosition(Scout, 1),

	Camera:zoom(20, 0.5),
	CameraDolly:wait(2)
}
