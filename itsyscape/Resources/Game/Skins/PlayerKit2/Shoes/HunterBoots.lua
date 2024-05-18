{
	model = "Resources/Game/Skins/Common/PlayerKit1/Feet.lmesh",
	pathTexture = "Resources/Game/Skins/PlayerKit2/Shoes/HunterBoots.lvg",
	colors = {
		{
			name = "Boot",
			color = "#4f3930"
		},
		{
			name = "Boot Shadow",
			color = "#30201a",
			parent = "Boot",

			hueOffset = -10,
			lightnessOffset = -20
		},
		{
			name = "Boot Highlight",
			color = "#f0ad92",
			parent = "Boot",

			saturationOffset = 20,
			lightnessOffset = 30
		},
		{
			name = "Metal Bits",
			color = "#808080",
		},
		{
			name = "Metal Bits Shadow",
			color = "#4d4d4d",
			parent = "Metal Bits",

			hueOffset = -10,
			saturationOffset = -20,
			lightnessOffset = -30
		},
	}
}
