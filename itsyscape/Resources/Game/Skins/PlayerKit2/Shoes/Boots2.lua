{
	model = "Resources/Game/Skins/Common/PlayerKit1/Feet.lmesh",
	pathTexture = "Resources/Game/Skins/PlayerKit2/Shoes/Boots2.lvg",
	colors = {
		{
			name = "Boot",
			color = "#4d2f24"
		},
		{
			name = "Boot Shadow",
			color = "#a0624b",
			parent = "Boot",

			hueOffset = -10,
			lightnessOffset = -20
		},
		{
			name = "Boot Highlight",
			color = "#4d2f24",
			parent = "Boot",

			saturationOffset = 20,
			lightnessOffset = 30
		}
	}
}
