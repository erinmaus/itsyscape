{
	model = "Resources/Game/Skins/Common/PlayerKit1/Feet.lmesh",
	pathTexture = "Resources/Game/Skins/PlayerKit2/Shoes/Boots3.lvg",
	colors = {
		{
			name = "Boot",
			color = "#92541e"
		},
		{
			name = "Boot Shadow",
			color = "#713d19",
			parent = "Boot",

			hueOffset = -10,
			lightnessOffset = -20
		},
		{
			name = "Boot Darker",
			color = "#5e3613",
			parent = "Boot",

			hueOffset = -15,
			lightnessOffset = -35
		},
		{
			name = "Boot Highlight",
			color = "#f4e4c9",
			parent = "Boot",

			saturationOffset = 20,
			lightnessOffset = 30
		}
	}
}
