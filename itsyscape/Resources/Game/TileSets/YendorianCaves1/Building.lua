{
	materials = {
		{
			name = "rock",
			material = {
				shader = "Resources/Shaders/DecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/YendorianCaves1/Rock.lua",
				uniforms = {
					scape_NumLayers = { "integer", 1 },
					scape_TriplanarScale = { "float", -0.5 },
					scape_TriplanarOffset = { "float", 0 },
					scape_TriplanarExponent = { "float", 0 },
				},

				properties = {
					outlineThreshold = -0.01,
					color = "aa7766"
				}
			}
		}
	},

	decorations = {
		{
			name = "wall.slope-begin",
			features = {
				{ id = "wall.slope-begin", material = "rock" }
			}
		},
		{
			name = "wall.slope-middle",
			features = {
				{ id = "wall.slope-middle", material = "rock" }
			}
		},
		{
			name = "wall.slope",
			features = {
				{ id = "wall.slope", material = "rock" }
			}
		},
		{
			name = "wall.slope-end",
			features = {
				{ id = "wall.slope-end", material = "rock" }
			}
		},
		{
			name = "wall.corner",
			features = {
				{ id = "wall.corner", material = "rock" }
			}
		},
		{
			name = "wall.edge",
			features = {
				{ id = "wall.edge", material = "rock" }
			}
		}
	}
}
