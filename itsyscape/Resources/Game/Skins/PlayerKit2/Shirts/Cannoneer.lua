{
	model = "Resources/Game/Skins/Common/PlayerKit1/Shirt.lmesh",
	pathTexture = "Resources/Game/Skins/PlayerKit2/Shirts/Cannoneer.lvg",
	colors = {
		{
			name = "Base",
			color = "#2cb0ba"
		},
		{
			name = "Belt",
			color = "#70473e",
		},
		{
			name = "Buckle",
			color = "#cccccc",
		},
		{
			name = "Base Shadow",
			color = "#637e95",

			parent = "Base",

			hueOffset = 25,
			lightnessOffset = -30
		},
		{
			name = "Belt Shadow",
			color = "#573229",

			parent = "Belt",

			hueOffset = 10,
			saturationOffset = 10,
			lightnessOffset = -30
		},
		{
			name = "Buckle Highlight",
			color = "#e8e8e8",

			parent = "Buckle",

			hueOffset = -10,
			lightnessOffset = 40
		},
	},
}
