{
	materials = {
		{
			name = "velvet",
			material = {
				shader = "Resources/Shaders/DecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/MuseumRope1/Velvet.lua",
				uniforms = {
					scape_NumLayers = { "integer", 1 },
					scape_TriplanarScale = { "float", -0.5 },
					scape_TriplanarOffset = { "float", 0 },
					scape_TriplanarExponent = { "float", 0 },
					scape_SpecularTexture = { "texture", "Resources/Game/TileSets/MuseumRope1/SpecularVelvet.lua" },
				},

				properties = {
					color = "b3002a",
					outlineThreshold = 0.5
				}
			}
		},
		{
			name = "metal",
			material = {
				shader = "Resources/Shaders/DecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/MuseumRope1/Metal.lua",
				uniforms = {
					scape_NumLayers = { "integer", 1 },
					scape_TriplanarScale = { "float", -0.5 },
					scape_TriplanarOffset = { "float", 0 },
					scape_TriplanarExponent = { "float", 0 },
					scape_SpecularTexture = { "texture", "Resources/Game/TileSets/MuseumRope1/Metal.lua" },
				},

				properties = {
					outlineThreshold = 0.5,
					color = "ffa100",
					isReflectiveOrRefractive = true,
					reflectionPower = 0.5,
					reflectionDistance = 1
				}
			}
		}
	},

	decorations = {
		{
			name = "corner",

			features = {
				{ id = "corner", material = "metal" },
				{ id = "corner.velvet", material = "velvet" },
			}
		},
		{
			name = "edge",

			features = {
				{ id = "edge", material = "metal" },
				{ id = "edge.velvet", material = "velvet" },
			}
		},
		{
			name = "cap",

			features = {
				{ id = "cap", material = "metal" }
			}
		}
	}
}