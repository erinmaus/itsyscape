{
	model = "Resources/Game/Skins/Common/PlayerKit1/Dress.lmesh",
	pathTexture = "Resources/Game/Skins/PlayerKit2/Shirts/LabCoat.lvg",
	colors = {
		{
			name = "Shirt",
			color = "#333333"
		},
		{
			name = "Coat",
			color = "#e6e6e6"
		},
		{
			name = "Trim",
			color = "#6025c6"
		},
		{
			name = "Shirt Shadow",
			color = "#181818",

			parent = "Shirt",

			hueOffset = -10,
			lightnessOffset = -20
		},
		{
			name = "Coat Shadow",
			color = "#d3d3d3",

			parent = "Coat",

			hueOffset = -10,
			lightnessOffset = -20
		},
		{
			name = "Coat Inside",
			color = "#666666",

			parent = "Coat",

			hueOffset = -10,
			saturationOffset = -30,
			lightnessOffset = -40
		}
	}
}
