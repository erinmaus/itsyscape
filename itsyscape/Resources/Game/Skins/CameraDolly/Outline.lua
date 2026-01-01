{
	model = "Resources/Game/Skins/CameraDolly/Outline.lmesh",
	material = {
		shader = "Resources/Shaders/SolidModel",
		texture = false,

		uniforms = {
			scape_Specular = { "float", 0.0 }
		},

		properties = {
			color = "000000",
			alpha = 0.75,
			isTranslucent = true,
			isFullLit = true,
			outlineThreshold = -1
		}
	}
}
