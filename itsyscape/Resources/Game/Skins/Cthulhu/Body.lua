{
	model = "Resources/Game/Skins/Cthulhu/Body.lmesh",
	texture = "Resources/Game/Skins/Cthulhu/Body.png",
	material = {
		shader = "Resources/Shaders/Cthulhu",

		uniforms = {
			scape_RainSpeed = { "float", 2.0 },
			scape_RainScale = { "float", -0.875 },
			scape_RainDiffuseTexture = { "texture", "Resources/Game/Skins/Cthulhu/Rain.png" },
			scape_RainSpecularTexture = { "texture", "Resources/Game/Skins/Cthulhu/Rain@Specular.png" },
			scape_NumLayers = { "integer", 2 }, 
			scape_SpecularWeight = { "float", 0.25 },
			scape_TriplanarExponent = { "float", 0.0, 0.0 },
			scape_TriplanarOffset = { "float", 0.0, 0.0 },
			scape_TriplanarScale = { "float", -0.75, -0.9 },
			scape_TriplanarTexture = { "texture", "Resources/Game/Skins/Cthulhu/SkinTexture.lua" },
			scape_TriplanarSpecularTexture = { "texture", "Resources/Game/Skins/Cthulhu/SkinSpecularTexture.lua" },
		},
		properties = {
			outlineThreshold = -0.01
		}
	}
}
