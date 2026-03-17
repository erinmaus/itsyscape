{
	model = "Resources/Game/Skins/Cthulhu/Eyes.lmesh",
	texture = "Resources/Game/Skins/Cthulhu/Head.png",
	material = {
		shader = "Resources/Shaders/Cthulhu",

		uniforms = {
			scape_RainSpeed = { "float", 2.0 },
			scape_RainScale = { "float", -0.875 },
			scape_RainDiffuseTexture = { "texture", "Resources/Game/Skins/Cthulhu/Rain.png" },
			scape_RainSpecularTexture = { "texture", "Resources/Game/Skins/Cthulhu/Rain@Specular.png" },
			scape_NumLayers = { "integer", 1 }, 
			scape_SpecularWeight = { "float", 0.25 },
			scape_TriplanarExponent = { "float", 0.0 },
			scape_TriplanarOffset = { "float", 0.0 },
			scape_TriplanarScale = { "float", -0.75 },
			scape_TriplanarTexture = { "texture", "Resources/Game/Skins/Cthulhu/EyesTexture.lua" },
			scape_TriplanarSpecularTexture = { "texture", "Resources/Game/Skins/Cthulhu/EyesSpecularTexture.lua" },
		},
		properties = {
			outlineThreshold = -0.01
		}
	}
}
