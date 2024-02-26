return Sequence {
	Orlando:stopAnimation("x-run"),
	Orlando:setState(false),
	Cthulhu:setState(false),

	Jenkins:setState("sail"),
	Player:dialog("IntroDialog"),

	Camera:target(CapnRaven),
	Camera:zoom(20),
	CapnRaven:talk("Har har har! I will make boots out of yer hide!", 4),
	CapnRaven:wait(4),

	Camera:target(Cthulhu),
	Cthulhu:lookAt(Quaternion.IDENTITY),
	Camera:zoom(50),
	Camera:translate(Vector(0, 12, 0)),
	Camera:zoom(20, 2),

	Player:wait(2),
	Player:move("Sailing_WhalingTemple", "Anchor_Spawn")
}
