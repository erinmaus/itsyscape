local DramaticTextController = require "ItsyScape.UI.Interfaces.DramaticTextController"

local OR_SO = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 48,
	textShadow = true,
	align = 'center',
	width = DramaticTextController.CANVAS_WIDTH - 64,
	x = 32,
	y = DramaticTextController.CANVAS_HEIGHT - 128,
	text = "Or so the many faithful to the Old Ones believe."
}

return Sequence {
	Player:narrate("", OR_SO, 6),

	Sequence {
		Camera:zoom(20),
		Camera:target(YendorianSwordfish),
		YendorianSwordfish:fireProjectile(YendorianSwordfish, "AstralMaelstrom"),
		Camera:relativeVerticalRotate(-math.pi / 8),
		Map:poke("cutsceneAttack", YendorianSwordfish:getPeep()),
		YendorianMast:wait(2),
		Camera:shake(1.5),
		Map:poke("cutsceneKill", YendorianSwordfish:getPeep()),
		YendorianSwordfish:wait(3)
	},

	Sequence {
		Camera:zoom(25),
		Camera:target(YendorianMast),
		YendorianMast:fireProjectile(YendorianMast, "AstralMaelstrom"),
		Camera:verticalRotate(-math.pi / 3),
		Camera:relativeHorizontalRotate(-math.pi / 48),
		Map:poke("cutsceneAttack", YendorianMast:getPeep()),
		YendorianMast:wait(2),
		Camera:shake(1.5),
		Map:poke("cutsceneKill", YendorianMast:getPeep()),
		YendorianMast:wait(3)
	},

	Intro:poke("playCutscene", Player:getPeep()),
	Player:wait(),

	Sistine:hide(),
	DowntownFloor1:hide(),
	DowntownFloor2:hide(),
	DowntownFloor3:hide()
}
