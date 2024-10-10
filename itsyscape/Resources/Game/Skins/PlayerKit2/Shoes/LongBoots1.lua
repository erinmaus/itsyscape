{
	model = "Resources/Game/Skins/Common/PlayerKit1/Feet.lmesh",
	pathTexture = "Resources/Game/Skins/PlayerKit2/Shoes/LongBoots1.lvg",
	colors = {
		{
			name = "Boot",
			color = "#4d4d4d"
		},
		{
			name = "Boot Shadow",
			color = "#333333",
			parent = "Boot",

			hueOffset = -10,
			lightnessOffset = -20
		},
		{
			name = "Boot Highlight",
			color = "#f9f9f9",
			parent = "Boot",

			saturationOffset = 20,
			lightnessOffset = 30
		}
	}
}
