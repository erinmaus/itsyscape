{
	model = "Resources/Game/Skins/Common/PlayerKit1/Head.lmesh",
	pathTexture = "Resources/Game/Skins/PlayerKit2/Head/PartiallyDigested.lvg",
	colors = {
		{
			name = "Bone",
			color = "#e9ddaf"
		},
		{
			name = "Bone Shadow",
			color = "#e4cf9d",

			parent = "Bone",

			hueOffset = -15,
			lightnessOffset = -20,
			saturationOffset = -5
		},
		{
			name = "Bone Crack",
			color = "#d4af64",

			parent = "Bone",

			hueOffset = 20,
			lightnessOffset = -10,
			saturationOffset = -10
		}
	},
	isBlocking = false
}