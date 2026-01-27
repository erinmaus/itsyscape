{
	model = "Resources/Game/Skins/Yenderling/ExtraterrestrialYenderling.lmesh",
	texture = "Resources/Game/Skins/Yenderling/ExtraterrestrialYenderling_Tentacle.png",
	material = {
		shader = "Resources/Shaders/Cthulhu",

		uniforms = {
			scape_RainSpeed = { "float", 2.0 },
			scape_RainScale = { "float", -0.5 },
			scape_RainDiffuseTexture = { "texture", "Resources/Game/Skins/Yenderling/ExtraterrestrialYenderling_Rain.png" },
			scape_RainSpecularTexture = { "texture", "Resources/Game/Skins/Yenderling/ExtraterrestrialYenderling_Rain@Specular.png" },
			scape_NumLayers = { "integer", 1 }, 
			scape_SpecularWeight = { "float", 0.25 },
			scape_TriplanarExponent = { "float", 0.0 },
			scape_TriplanarOffset = { "float", 0.0 },
			scape_TriplanarScale = { "float", -0.9 },
			scape_TriplanarTexture = { "texture", "Resources/Game/Skins/Yenderling/ExtraterrestrialYenderling_TentacleTexture.lua" },
			scape_TriplanarSpecularTexture = { "texture", "Resources/Game/Skins/Yenderling/ExtraterrestrialYenderling_SpecularTentacleTexture.lua" },
		},
		properties = {
			outlineThreshold = -0.01
		}
	}
}
