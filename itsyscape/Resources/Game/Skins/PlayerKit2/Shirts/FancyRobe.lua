{
	model = "Resources/Game/Skins/Common/PlayerKit1/Dress.lmesh",
	pathTexture = "Resources/Game/Skins/PlayerKit2/Shirts/FancyRobe.lvg",
	colors = {
		{
			name = "Shirt",
			color = "#333333"
		},
		{
			name = "Jacket",
			color = "#c84637"
		},
		{
			name = "Jacket Shadow",
			color = "#962929",

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
