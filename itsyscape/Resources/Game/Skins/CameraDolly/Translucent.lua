{
	model = "Resources/Game/Skins/CameraDolly/Translucent.lmesh",
	material = {
		shader = "Resources/Shaders/SolidModel",
		texture = false,

		uniforms = {
			scape_Specular = { "float", 0.0 }
		},

		properties = {
			color = "ffffff",
			alpha = 0.25,
			isTranslucent = true,
			isFullLit = true,
			outlineThreshold = -1
		}
	}
}
