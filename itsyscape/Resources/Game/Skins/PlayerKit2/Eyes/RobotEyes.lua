{
	model = "Resources/Game/Skins/Common/PlayerKit1/Face.lmesh",
	pathTexture = "Resources/Game/Skins/PlayerKit2/Eyes/RobotEyes.lvg",
	colors = {
		{
			name = "Eyebrow",

			"left-brow",
			"right-brow"
		},
		{
			name = "Eye",

			"left-eye",
			"right-eye"
		},
		{
			name = "Scanline",

			parent = "Eye",

			"left-eye-scanline1",
			"left-eye-scanline2",
			"left-eye-scanline3",
			"right-eye-scanline1",
			"right-eye-scanline2",
			"right-eye-scanline3",

			lightnessOffset = -15,
			saturationOffset = -20
		}
	},
	isBlocking = false,
	isOccluded = true
}
