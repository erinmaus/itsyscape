{
	materials = {
		{
			name = "marble",
			material = {
				shader = "Resources/Shaders/FloatingSpecularTriplanar",
				texture = "Resources/Game/Props/IsabelleIslandTowerSpiralStaircase/Texture.png",

				uniforms = {
					scape_TriplanarScale = { "float", -0.5 },
					scape_TriplanarExponent = { "float", 0 },
					scape_TriplanarOffset = { "float", 0 },
					scape_SpecularWeight = { "float", 0 },
					scape_NumPatterns = { "integer", 1 },
					scape_Pattern = {
						"float",
						0.6, 0, 0.2
					},
				},

				properties = {
					outlineThreshold = -0.01,
					color = "b5b3c4"
				}
			}
		}
	},

	decorations = {
		{
			name = "rune1",
			features = {
				{ id = "rune", material = "marble" }
			}
		}
	}
}
