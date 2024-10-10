{
	model = "Resources/Game/Skins/Common/PlayerKit1/Shirt.lmesh",
	pathTexture = "Resources/Game/Skins/PlayerKit2/Shirts/BankerSuit.lvg",
	colors = {
		{
			name = "Suit",
			color = "#5c7a87"
		},
		{
			name = "Tie",
			color = "#e8ba00"
		},
		{
			name = "Belt",
			color = "#565656"
		},
		{
			name = "Suit Lighter",
			color = "#93c6d2",

			parent = "Suit",

			saturationOffset = 10,
			lightnessOffset = 50
		},
		{
			name = "Suit Shadow",
			color = "#3d6873",

			parent = "Suit",

			saturationOffset = 20,
			lightnessOffset = -20
		}
	},
}
