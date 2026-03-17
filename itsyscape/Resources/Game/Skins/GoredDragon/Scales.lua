{
	model = "Resources/Game/Skins/GoredDragon/Scales.lmesh",
	texture = "Resources/Game/Skins/GoredDragon/Texture.png",
	material = {
		shader = "Resources/Shaders/GoredDragon",

		uniforms = {
			scape_NumLayers = { "integer", 1 }, 
			scape_SpecularWeight = { "float", 0 },
			scape_TriplanarExponent = { "float", 0.0 },
			scape_TriplanarOffset = { "float", 0.0 },
			scape_TriplanarScale = { "float", 0 },
			scape_NoiseScale = { "float", 3.3, 4.87, 2.7 },
			scape_NoiseOffset = { "float", 0, 0, 0 },
			scape_Wiggle = { "float", 0.0, 0.0, 0.0 },
			scape_NoiseThreshold = { "float", 0.4 },
			scape_TriplanarTexture = { "texture", "Resources/Game/Skins/GoredDragon/ScalesTexture.lua" },
			scape_TriplanarSpecularTexture = { "texture", "Resources/Game/Skins/GoredDragon/SpecularScalesTexture.lua" },
		},

		properties = {
			outlineThreshold = -0.01
		}
	}
}
