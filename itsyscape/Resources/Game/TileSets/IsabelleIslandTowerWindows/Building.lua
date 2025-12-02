{
	materials = {
		{
			name = "glass",
			material = {
				shader = "Resources/Shaders/MultiTextureWallDecoration",
				properties = {
					isTranslucent = true,
					isFullLit = true,
					outlineThreshold = 0.5
				}
			}
		},
		{
			name = "metal",
			material = {
				shader = "Resources/Shaders/MultiTextureWallDecoration",
				properties = {
					outlineThreshold = 0.5
				}
			}
		}
	},

	decorations = {
		{
			name = "fierbloom",
			features = {
				{ id = "glass", material = "glass", texture = 1 },
				{ id = "metal", material = "metal", texture = 1 }
			}
		}
	}
}
