{
	materials = {
		{
			name = "brick",
			material = {
				shader = "Resources/Shaders/DecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/YendorianWalls1/Brick.lua",
				uniforms = {
					scape_NumLayers = { "integer", 3 },
					scape_TriplanarScale = { "float", -0.75, -0.25, 0.1 },
					scape_TriplanarOffset = { "float", 0, 0, 0 },
					scape_TriplanarExponent = { "float", 0, 0, 0 },
				},

				properties = {
					outlineThreshold = 0.5,
					color = "46416b"
				}
			}
		}
	},

	decorations = {
		{
			name = "wall.exterior-corner",

			features = {
				{ id = "wall.exterior-corner", material = "brick" }
			}
		},
		{
			name = "wall.exterior-corner.crumbling1",

			features = {
				{ id = "wall.exterior-corner.crumbling1", material = "brick" }
			}
		},
		{
			name = "wall.interior-corner.crumbling2",

			features = {
				{ id = "wall.interior-corner.crumbling2", material = "brick" }
			}
		},
		{
			name = "wall.interior-corner.crumbling1",

			features = {
				{ id = "wall.interior-corner.crumbling1", material = "brick" }
			}
		},
		{
			name = "wall.flat.crumbling4",

			features = {
				{ id = "wall.flat.crumbling4", material = "brick" }
			}
		},
		{
			name = "wall.flat.crumbling3",

			features = {
				{ id = "wall.flat.crumbling3", material = "brick" }
			}
		},
		{
			name = "wall.flat.crumbling2",

			features = {
				{ id = "wall.flat.crumbling2", material = "brick" }
			}
		},
		{
			name = "wall.flat.crumbling1",

			features = {
				{ id = "wall.flat.crumbling1", material = "brick" }
			}
		},
		{
			name = "wall.interior-corner",

			features = {
				{ id = "wall.interior-corner", material = "brick" }
			}
		},
		{
			name = "wall.exterior-corner.crumbling2",

			features = {
				{ id = "wall.exterior-corner.crumbling2", material = "brick" }
			}
		},
		{
			name = "wall.flat",

			features = {
				{ id = "wall.flat", material = "brick" }
			}
		}
	}
}
