local DramaticTextController = require "ItsyScape.UI.Interfaces.DramaticTextController"

local RITUAL1 = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	textShadow = true,
	align = 'center',
	width = DramaticTextController.CANVAS_WIDTH - 64,
	x = 32,
	y = DramaticTextController.CANVAS_HEIGHT - 256,
	text = "In a time immemorial, a necromancer-turned-god, The Empty King, performed a horrific ritual"
}

local RITUAL2 = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	textShadow = true,
	align = 'center',
	width = DramaticTextController.CANVAS_WIDTH - 64,
	x = 32,
	y = DramaticTextController.CANVAS_HEIGHT - 128,
	text = "that claimed innumerable lives in order to banish the Old Ones from the Realm."
}

local WAKE1 = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	textShadow = true,
	align = 'center',
	width =DramaticTextController.CANVAS_WIDTH - 64,
	x = 32,
	y = DramaticTextController.CANVAS_HEIGHT - 256,
	text = "The Old Ones gnaw at the edges of The Empty King's enchantment on the Realm yearning"
}

local WAKE2 = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	textShadow = true,
	align = 'center',
	width =DramaticTextController.CANVAS_WIDTH - 64,
	x = 32,
	y = DramaticTextController.CANVAS_HEIGHT - 128,
	text = "to wake from their horrible nightmare and exact a cosmic revenge on the The Empty King and Their zealots."
}

local NarrationSequence = Sequence {
	Player:narrate("", RITUAL1, 12),
	Player:wait(4),

	Player:narrate("", RITUAL2, 8),
	Player:wait(8),

	Player:wait(1),

	Player:narrate("", WAKE1, 12),
	Player:wait(4),

	Player:narrate("", WAKE2, 8),
	Player:wait(8),

	Player:wait(1)
}

local FightSequence = Sequence {
	Camera:zoom(20),
	Camera:translate(Vector(0, 4, 0)),
	Camera:horizontalRotate(0),

	TheEmptyKing:playAnimation("TheEmptyKing_FullyRealized_SummonWeapon_Magic", "idle", 500),
	TheEmptyKing:playAnimation("Darken", "x-darken"),

	Yendor:playAnimation("Yendor_Rise", "idle", 500),
	Yendor:playAnimation("Yendor_Idle_Alive", "idle", 500),
	Yendor:playAnimation("Darken", "x-darken"),

	Sequence {
		Camera:target(CameraDolly),
		CameraDolly:teleport("Anchor_Gottskrieg"),
		CameraDolly:wait(2),

		Gottskrieg:fireProjectile(TheEmptyKing, "TheEmptyKing_FullyRealized_SummonStaff"),
		CameraDolly:lerpPosition("Anchor_TheEmptyKing", 1.5),

		Camera:translate(Vector(0, 6, 0), 1.5),
		Camera:zoom(30, 1.5),
		Camera:relativeVerticalRotate(0, 1.5),
		Camera:relativeHorizontalRotate(0, 1.5),
		CameraDolly:wait(1.5),

		TheEmptyKing:playAnimation("TheEmptyKing_FullyRealized_Idle_Magic", "idle", 500),

		TheEmptyKing:playAnimation("TheEmptyKing_FullyRealized_Attack_Magic2", "x-attack"),
		TheEmptyKing:fireProjectile(Vector.ZERO, "TheEmptyKing_FullyRealized_Staff"),
		TheEmptyKing:fireProjectile(Yendor, "FireBlast"),
		TheEmptyKing:wait(1.5)
	},

	Sequence {
		TheEmptyKing:lookAt(Yendor),
		TheEmptyKing:playAnimation("TheEmptyKing_FullyRealized_Attack_Magic1", "x-attack"),
		TheEmptyKing:fireProjectile(Vector.ZERO, "TheEmptyKing_FullyRealized_Staff"),
		TheEmptyKing:fireProjectile(Yendor, "FireBlast"),

		Yendor:lookAt(TheEmptyKing),
		Yendor:playAnimation("Yendor_Attack_Magic", "x-attack"),

		Camera:zoom(50, 1.5),
		Camera:translate(Vector(0, 6, 16), 1.5),
		Camera:relativeVerticalRotate(math.pi / 16, 1.5),
		TheEmptyKing:wait(3.5),

		TheEmptyKing:playAnimation("TheEmptyKing_FullyRealized_Attack_Magic2", "x-attack"),
		TheEmptyKing:fireProjectile(Vector.ZERO, "TheEmptyKing_FullyRealized_Staff"),
		TheEmptyKing:fireProjectile(Yendor, "FireBlast"),

		Yendor:playAnimation("Yendor_Attack_Magic", "x-attack"),
		TheEmptyKing:wait(3.5),

		Camera:zoom(20),
		Camera:translate(Vector(0, 8, 0)),
		Camera:relativeVerticalRotate(0),
		Camera:target(TheEmptyKing),

		TheEmptyKing:playAnimation("TheEmptyKing_FullyRealized_Attack_Magic_Special", "x-attack"),

		Yendor:playAnimation("Yendor_Attack_Magic", "x-attack"),

		TheEmptyKing:wait(1.5),
		TheEmptyKing:fireProjectile(Yendor, "AstralMaelstrom"),

		Camera:target(Yendor),
		Camera:zoom(75),
		Camera:relativeVerticalRotate(math.pi / 16),
		Camera:relativeHorizontalRotate(0),

		TheEmptyKing:playAnimation("TheEmptyKing_FullyRealized_Attack_Magic1", "x-attack"),
		TheEmptyKing:fireProjectile(Vector.ZERO, "TheEmptyKing_FullyRealized_Staff"),
		TheEmptyKing:fireProjectile(Yendor, "FireBlast"),

		Yendor:wait(2),
		Camera:shake(3.5),
		Yendor:playAnimation("Yendor_Die"),
		Yendor:wait(2.5),

		Camera:zoom(30, 2),
		Camera:translate(Vector(0, 0, -10), 2),
		Camera:relativeVerticalRotate(math.pi / 4 + math.pi / 8, 2),
		Yendor:wait(4),

		Camera:zoom(30),
		Camera:translate(Vector(0, 5.5, 0)),
		Camera:relativeVerticalRotate(0),
		Camera:horizontalRotate(0),
		Camera:target(TheEmptyKing),
		TheEmptyKing:lookAt(Quaternion.IDENTITY),
		Camera:zoom(4, 2),
		TheEmptyKing:wait(2)
	}
}

return Sequence {
	Map:playMusic("TutorialIntro"),

	Parallel {
		NarrationSequence,
		FightSequence
	},

	Map:pushPoke("playDowntownCutscene", Player:getPeep(), "EmptyRuins_Downtown_Intro")
}
