{
	model = "Resources/Game/Skins/Common/PlayerKit1/Dress.lmesh",
	pathTexture = "Resources/Game/Skins/PlayerKit2/Shirts/FancyPirateGarb.lvg",
	colors = {
		{
			name = "Shirt",
			color = "#e6e6e6"
		},
		{
			name = "Jacket",
			color = "#c83737"
		},
		{
			name = "Shirt Shadow",
			color = "#cccccc",

			parent = "Shirt",

			hueOffset = -10,
			lightnessOffset = -40
		},
		{
			name = "Jacket Shadow",
			color = "#974a2a",

			parent = "Jacket",

			hueOffset = 15,
			lightnessOffset = -40
		},
		{
			name = "Trim",
			color = "#ffcc00",

			parent = "Jacket",

			hueOffset = 50,
			lightnessOffset = 20
		}
	},
}
