{
	model = "Resources/Game/Skins/Common/PlayerKit1/Dress.lmesh",
	pathTexture = "Resources/Game/Skins/PlayerKit2/Shirts/Hunter.lvg",
	colors = {
		{
			name = "Shirt",
			color = "#6c5353"
		},
		{
			name = "Leather",
			color = "#4f3930"
		},
		{
			name = "Hide",
			color = "#484f30"
		},
		{
			name = "Shirt Shadow",
			color = "#4f3333",

			parent = "Shirt",

			hueOffset = -10,
			lightnessOffset = -20
		},
		{
			name = "Leather Shadow",
			color = "#30201a",

			parent = "Leather",

			hueOffset = -10,
			lightnessOffset = -20
		},
		{
			name = "Hide Shadow",
			color = "#273822",

			parent = "Hide",

			hueOffset = -10,
			lightnessOffset = -20
		}
	},
}
