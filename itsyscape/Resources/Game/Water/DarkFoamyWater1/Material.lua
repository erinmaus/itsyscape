{
	shader = "Resources/Shaders/Water",
	texture = "Resources/Game/Water/LightFoamyWater1/Texture.png",
	uniforms = {
		scape_YOffset = { "float", 0.5 },
		scape_TextureScale = { "float", 4, 4 },
		scape_TimeScale = { "float", 0.125, 0.25 },

		scape_WindSpeedMultiplier = { "float", 1 },
		scape_WindPatternMultiplier = { "float", 1, 1, 1 },

		scape_NearFoamDepth = { "float", 0.0, 2.5 },
		scape_FarFoamDepth = { "float", 1.0, 2.5 },
		scape_WaterDepth = { "float", 2.5, 3.5 },

		scape_FoamColor = { "color", "e3f2ff", 1 },
		scape_DiffuseColor = { "color", "e3f2ff", 1 },
		scape_ShallowWaterColor = { "color", "55ddff", 1 },
		scape_DeepWaterColor = { "color", "3970ab", 1 },

		scape_FoamTexture = { "texture", "Resources/Game/Water/LightFoamyWater1/Foam.png" },
	},

	properties = {
		isTranslucent = false,
		outlineThreshold = -1
	}
}
