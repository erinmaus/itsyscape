{
	model = "Resources/Game/Skins/GoredDragon/Muscle.lmesh",
	texture = "Resources/Game/Skins/GoredDragon/Muscle.png",
	material = {
		shader = "Resources/Shaders/GoredDragon",
		texture = false,

		uniforms = {
			scape_NumLayers = { "integer", 1 }, 
			scape_SpecularWeight = { "float", 0 },
			scape_TriplanarExponent = { "float", 0 },
			scape_TriplanarOffset = { "float", 0 },
			scape_TriplanarScale = { "float", 0 },
			scape_Wiggle = { "float", 1.17 },
			scape_NoiseScale = { "float", 3.3, 4.87, 2.7 },
			scape_NoiseOffset = { "float", 516.34, 473.65, 158.87 },
			scape_NoiseThreshold = { "float", 0.5 },
			scape_TriplanarTexture = { "texture", "Resources/Game/Skins/GoredDragon/ScalesTexture.lua" },
			scape_TriplanarSpecularTexture = { "texture", "Resources/Game/Skins/GoredDragon/SpecularScalesTexture.lua" },
			scape_WallHackAlpha = { "float", 0 },
			scape_WallHackWindow = { "float", 0, 0, 0, 0 },
			scape_WallHackNear = { "float", 0 },
		},

		properties = {
			outlineThreshold = -0.01
		}
	}
}
