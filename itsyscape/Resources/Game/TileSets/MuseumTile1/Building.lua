{
	materials = {
		{
			name = "marble",
			material = {
				shader = "Resources/Shaders/DecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/MuseumTile1/Marble.lua",
				uniforms = {
					scape_NumLayers = { "integer", 1 },
					scape_TriplanarScale = { "float", -0.75 },
					scape_TriplanarOffset = { "float", 0 },
					scape_TriplanarExponent = { "float", 0 },
					scape_SpecularTexture = { "texture", "Resources/Game/TileSets/MuseumTile1/SpecularMarble.lua" },
				},

				properties = {
					outlineThreshold = 0.5,
					isReflectiveOrRefractive = true,
					reflectionPower = 0.5,
					reflectionDistance = 1,
					roughness = 0
				}
			}
		},
		{
			name = "caulk",
			material = {
				shader = "Resources/Shaders/DecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/MuseumTile1/Marble.lua",
				uniforms = {
					scape_NumLayers = { "integer", 1 },
					scape_TriplanarScale = { "float", 0.5 },
					scape_TriplanarOffset = { "float", 0 },
					scape_TriplanarExponent = { "float", 0 },
					scape_SpecularTexture = { "texture", "Resources/Game/TileSets/MuseumTile1/Marble.lua" },
				},

				properties = {
					outlineThreshold = 0.7,
					color = "aaaaaa"
				}
			}
		}
	},

	decorations = {
		{
			name = "center",

			features = {
				{ id = "tile.center", material = "marble" }
			}
		},
		{
			name = "edge",

			features = {
				{ id = "tile.edge", material = "marble" },
				{ id = "tile.edge.raised", material = "caulk" }
			}
		},
		{
			name = "corner",

			features = {
				{ id = "tile.corner", material = "marble" },
				{ id = "tile.corner.raised", material = "caulk" }
			}
		}
	}
}