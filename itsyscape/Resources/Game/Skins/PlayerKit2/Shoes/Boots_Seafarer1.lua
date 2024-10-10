{
	model = "Resources/Game/Skins/Common/PlayerKit1/Feet.lmesh",
	pathTexture = "Resources/Game/Skins/PlayerKit2/Shoes/Boots_Seafarer1.lvg",
	colors = {
		{
			name = "Boot",
			color = "#4d2f24"
		},
		{
			name = "Boot Shadow",
			color = "#3a211b",
			parent = "Boot",

			hueOffset = -10,
			lightnessOffset = -20
		},
		{
			name = "Boot Highlight",
			color = "#efdfcb",
			parent = "Boot",

			saturationOffset = 20,
			lightnessOffset = 30
		}
	}
}
