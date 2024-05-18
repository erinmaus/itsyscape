{
	model = "Resources/Game/Skins/Common/PlayerKit1/Feet.lmesh",
	pathTexture = "Resources/Game/Skins/PlayerKit2/Shoes/FancyShoes1.lvg",
	colors = {
		{
			name = "Shoe",
			color = "#565656"
		},
		{
			name = "Shoe Shadow",
			color = "#463c3c",
			parent = "Shoe",

			hueOffset = -10,
			lightnessOffset = -20
		},
		{
			name = "Shoe Highlight",
			color = "#dfdbdb",
			parent = "Shoe",

			saturationOffset = 20,
			lightnessOffset = 30
		}
	}
}
