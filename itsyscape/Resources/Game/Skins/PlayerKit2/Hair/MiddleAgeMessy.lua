{
	model = "Resources/Game/Skins/Common/PlayerKit1/Hair.lmesh",
	pathTexture = "Resources/Game/Skins/PlayerKit2/Hair/MiddleAgeMessy.lvg",
	colors = {
		{
			name = "Hair",

			"hair"
		},
		{
			name = "Hair Highlight",
			parent = "Hair",
			hueOffset = 10,
			lightnessOffset = 50,
			saturationOffset = 10,

			"highlight"
		},
		{
			name = "Hair Shadow",
			parent = "Hair",
			hueOffset = 0,
			lightnessOffset = 15,
			saturationOffset = 30,

			"shadow1",
			"shadow2",
			"shadow3"
		}
	},
	isBlocking = false,
	isOccluded = true
}
