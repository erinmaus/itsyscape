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
		Camera:target(YendorianBallista),
		YendorianBallista:fireProjectile(YendorianBallista, "AstralMaelstrom"),
		Camera:relativeVerticalRotate(math.pi / 8 + math.pi / 12),
		Camera:relativeHorizontalRotate(-math.pi / 16 + -math.pi / 24),
		Map:poke("cutsceneAttack", YendorianBallista:getPeep()),
		YendorianMast:wait(1.5),
		Camera:shake(1.0),
		Map:poke("cutsceneKill", YendorianBallista:getPeep()),
		YendorianBallista:wait(1.5)
	},

	Sequence {
		Camera:zoom(20),
		Camera:target(YendorianSwordfish),
		YendorianSwordfish:fireProjectile(YendorianSwordfish, "AstralMaelstrom"),
		Camera:relativeVerticalRotate(-math.pi / 8),
		Map:poke("cutsceneAttack", YendorianSwordfish:getPeep()),
		YendorianMast:wait(1.5),
		Camera:shake(1.5),
		Map:poke("cutsceneKill", YendorianSwordfish:getPeep()),
		YendorianSwordfish:wait(1.5)
	},

	Sequence {
		Camera:zoom(25),
		Camera:target(YendorianMast),
		YendorianMast:fireProjectile(YendorianMast, "AstralMaelstrom"),
		Camera:verticalRotate(-math.pi / 3),
		Camera:relativeHorizontalRotate(-math.pi / 16),
		Map:poke("cutsceneAttack", YendorianMast:getPeep()),
		YendorianMast:wait(1.5),
		Camera:shake(1.5),
		Map:poke("cutsceneKill", YendorianMast:getPeep()),
		YendorianMast:wait(1.5)
	}
}
