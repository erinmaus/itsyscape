{
	materials = {
		{
			name = "candle",
			material = {
				shader = "Resources/Shaders/SpecularTriplanar",
				texture = "Resources/Game/TileSets/Candles1/Candle.png",

				properties = {
					color = "ffffff",
					outlineThreshold = 0.2
				},

				uniforms = {
					scape_TriplanarScale = { "float", 1 },
					scape_TriplanarExponent = { "float", 2 },
					scape_TriplanarOffset = { "float", 0 },
					scape_SpecularWeight = { "float", 0 }
				}
			}
		}
	},

	decorations = {
		{
			name = "candle",
			features = {
				{ id = "candle", material = "candle" }
			}
		}
	}
}
