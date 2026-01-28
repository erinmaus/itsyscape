{
	shader = "Resources/Shaders/Water",
	texture = "Resources/Game/Water/Magma1/Texture.png",
	uniforms = {
		scape_YOffset = { "float", 0.5 },
		scape_TextureScale = { "float", 4, 4 },
		scape_TimeScale = { "float", 0.125, 0.25 },

		scape_WindSpeedMultiplier = { "float", 1 },
		scape_WindPatternMultiplier = { "float", 1, 1, 1 },

		scape_NearFoamDepth = { "float", 0.0, 2.5 },
		scape_FarFoamDepth = { "float", 1.0, 2.5 },
		scape_WaterDepth = { "float", 2.5, 3.5 },

		scape_FoamColor = { "color", "2f1203", 1.0 },
		scape_DiffuseColor = { "color", "2f1203", 1.0 },
		scape_ShallowWaterColor = { "color", "cb340d", 0.95 },
		scape_DeepWaterColor = { "color", "db510e", 1.0 },

		scape_FoamTexture = { "texture", "Resources/Game/Water/Magma1/Foam.png" },
	},

	properties = {
		isTranslucent = true,
		outlineThreshold = -1
	}
}
