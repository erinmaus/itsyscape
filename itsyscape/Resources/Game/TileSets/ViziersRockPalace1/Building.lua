{
	materials = {
		{
			name = "feather1",
			material = {
				shader = "Resources/Shaders/DetailDecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/ViziersRockPalace1/Feather1.png",
				uniforms = {
					scape_NumLayers = { "integer", 1 },
					scape_TriplanarScale = { "float", -0.75 },
					scape_TriplanarTexture = { "texture", "Resources/Game/TileSets/ViziersRockPalace1/Marble.lua" },
					scape_TriplanarSpecularTexture = { "texture", "Resources/Game/TileSets/ViziersRockPalace1/SpecularMarble.lua" },
				},

				properties = {
					outlineThreshold = 0.5
				}
			}
		}
	},

	decorations = {
		{
			name = "feather1",

			features = {
				{ id = "feather1", material = "feather1" }
			}
		},
		{
			name = "wall.outer.left",

			features = {
				{ id = "wall.outer.left", material = "feather1" }
			}
		}
	}
}