{
	materials = {
		{
			name = "marble",
			material = {
				shader = "Resources/Shaders/DecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/Cyclopean1/Marble.lua",
				uniforms = {
					scape_NumLayers = { "integer", 2 },
					scape_TriplanarScale = { "float", -0.5, -0.95 },
					scape_TriplanarOffset = { "float", 0, 0 },
					scape_TriplanarExponent = { "float", 0, 0 },
					scape_SpecularTexture = { "texture", "Resources/Game/TileSets/Cyclopean1/SpecularMarble.lua" }
				},

				properties = {
					outlineThreshold = -0.01,
					color = "ffffff"
				}
			}
		}
	},

	decorations = {
		{
			name = "cube.long",
			features = {
				{ id = "cube.long", material = "marble" }
			}
		},
		{
			name = "cube.short",
			features = {
				{ id = "cube.short", material = "marble" }
			}
		},
		{
			name = "cube.tiny",
			features = {
				{ id = "cube.tiny", material = "marble" }
			}
		}
	}
}
