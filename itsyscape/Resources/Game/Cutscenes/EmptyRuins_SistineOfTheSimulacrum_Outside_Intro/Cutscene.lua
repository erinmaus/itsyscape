return Sequence {
	Camera:zoom(15),
	Camera:translate(Vector(0, 2, 0)),
	Camera:horizontalRotate(0),

	TheEmptyKing:playAnimation("TheEmptyKing_FullyRealized_SummonWeapon_Magic", "idle", 500),
	TheEmptyKing:playAnimation("Darken", "x-darken"),

	Yendor:playAnimation("Yendor_Rise", "idle", 500),
	Yendor:playAnimation("Yendor_Idle_Alive", "idle", 500),
	Yendor:playAnimation("Darken", "x-darken"),

	Sequence {
		Camera:target(CameraDolly),
		CameraDolly:teleport("Anchor_Gottskrieg"),
		CameraDolly:wait(1),

		Gottskrieg:fireProjectile(TheEmptyKing, "TheEmptyKing_FullyRealized_SummonStaff"),
		CameraDolly:lerpPosition("Anchor_TheEmptyKing", 1.5),

		Camera:translate(Vector(0, 6, 0), 1.5),
		Camera:zoom(30, 1.5),
		Camera:relativeVerticalRotate(0, 1.5),
		Camera:relativeHorizontalRotate(-math.pi / 16, 1.5),
		CameraDolly:wait(1.5)
	},

	TheEmptyKing:playAnimation("TheEmptyKing_FullyRealized_Idle_Magic", "idle", 500),

	Sequence {
		TheEmptyKing:lookAt(Yendor),
		TheEmptyKing:playAnimation("TheEmptyKing_FullyRealized_Attack_Magic1", "x-attack"),
		TheEmptyKing:fireProjectile(Vector.ZERO, "TheEmptyKing_FullyRealized_Staff"),
		TheEmptyKing:fireProjectile(Yendor, "FireBlast"),

		Yendor:lookAt(TheEmptyKing),
		Yendor:playAnimation("Yendor_Attack_Magic", "x-attack"),

		Camera:zoom(50, 1.5),
		Camera:relativeVerticalRotate(math.pi / 4, 1.5),
		TheEmptyKing:wait(2.5),

		TheEmptyKing:playAnimation("TheEmptyKing_FullyRealized_Attack_Magic2", "x-attack"),
		TheEmptyKing:fireProjectile(Vector.ZERO, "TheEmptyKing_FullyRealized_Staff"),
		TheEmptyKing:fireProjectile(Yendor, "FireBlast"),

		Yendor:playAnimation("Yendor_Attack_Magic", "x-attack"),

		TheEmptyKing:wait(2.5),

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
		Camera:relativeVerticalRotate(math.pi / 4),
		Camera:relativeHorizontalRotate(0),

		TheEmptyKing:playAnimation("TheEmptyKing_FullyRealized_Attack_Magic1", "x-attack"),
		TheEmptyKing:fireProjectile(Vector.ZERO, "TheEmptyKing_FullyRealized_Staff"),
		TheEmptyKing:fireProjectile(Yendor, "FireBlast"),

		Yendor:wait(2),
		Camera:shake(1.5),
		Yendor:playAnimation("Yendor_Die"),
		Yendor:wait(2),
	},

	Map:pushPoke("playDowntownCutscene", Player:getPeep(), "EmptyRuins_Downtown_Intro")
}
