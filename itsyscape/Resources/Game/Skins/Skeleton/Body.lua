{
	model = "Resources/Game/Skins/Common/Equipment/Body.lmesh",
	pathTexture = "Resources/Game/Skins/Skeleton/Texture.lvg",
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
