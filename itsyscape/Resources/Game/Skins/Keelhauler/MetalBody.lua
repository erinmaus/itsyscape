{
	model = "Resources/Game/Skins/Keelhauler/Metal.lmesh",
	scale = { 0.5, 0.5, 0.5 },
	material = {
		shader = "Resources/Shaders/ModelSpecularMultiTriplanar",
		texture = "Resources/Game/Skins/Keelhauler/Metal.lua",

		uniforms = {
			scape_NumLayers = { "integer", 1 },
			scape_TriplanarScale = { "float", 0 },
			scape_TriplanarOffset = { "float", 0 },
			scape_TriplanarExponent = { "float", 0 },
		},

		properties = {
			color = "ffdd55",
			isReflectiveOrRefractive = true,
			reflectionPower = 0.5,
			reflectionDistance = 1
		}
	}
}
