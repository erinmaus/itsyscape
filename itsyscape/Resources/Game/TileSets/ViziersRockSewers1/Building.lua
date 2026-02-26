{
	materials = {
		{
			name = "brick",
			material = {
				shader = "Resources/Shaders/DecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/ViziersRockSewers1/Brick.lua",
				uniforms = {
					scape_NumLayers = { "integer", 3 },
					scape_TriplanarScale = { "float", -0.5, -0.5, -0.25 },
					scape_TriplanarOffset = { "float", 0, 0, 0 },
					scape_TriplanarScale = { "float", 0, 0, 0 }
				},

				properties = {
					outlineThreshold = 0.05,
					color = "91846f"
				}
			}
		},
		{
			name = "stone",
			material = {
				shader = "Resources/Shaders/DecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/ViziersRockSewers1/Stone.lua",

				uniforms = {
					scape_NumLayers = { "integer", 3 },
					scape_TriplanarScale = { "float", 0, -0.5, -0.25 },
					scape_TriplanarOffset = { "float", 0, 0, 0 },
					scape_TriplanarScale = { "float", 0, 0, 0 }
				},

				properties = {
					outlineThreshold = 0.05,
					color = "91846f"
				}
			}
		},
		{
			name = "dark",
			material = {
				shader = "Resources/Shaders/DecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/ViziersRockSewers1/Dark.lua",

				uniforms = {
					scape_NumLayers = { "integer", 1 },
					scape_TriplanarScale = { "float", 0 },
					scape_TriplanarOffset = { "float", 0 },
					scape_TriplanarScale = { "float", 0 }
				},

				properties = {
					outlineThreshold = 0.05,
					color = "51493e"
				}
			}
		}
	},

	decorations = {
		{
			name = "wall.exterior.corner",

			features = {
				{ id = "wall.exterior.corner.brick", material = "brick" },
				{ id = "wall.exterior.corner.stone", material = "stone" },
				{ id = "wall.exterior.corner.dark", material = "dark" },
			}
		},
		{
			name = "wall.exterior.edge",

			features = {
				{ id = "wall.exterior.edge.brick", material = "brick" },
				{ id = "wall.exterior.edge.stone", material = "stone" },
				{ id = "wall.exterior.edge.dark", material = "dark" },
			}
		},
		{
			name = "wall.exterior.t-edge",

			features = {
				{ id = "wall.exterior.t-edge.brick", material = "brick" },
				{ id = "wall.exterior.t-edge.stone", material = "stone" },
				{ id = "wall.exterior.t-edge.dark", material = "dark" }
			}
		},
		{
			name = "wall.exterior.wedge",

			features = {
				{ id = "wall.exterior.wedge.brick", material = "brick" },
				{ id = "wall.exterior.wedge.stone", material = "stone" },
				{ id = "wall.exterior.wedge.dark", material = "dark" }
			}
		},
		{
			name = "wall.interior.corner",

			features = {
				{ id = "wall.interior.corner.stone", material = "stone" },
				{ id = "wall.interior.corner.dark", material = "dark" }
			}
		},
		{
			name = "wall.interior.edge",

			features = {
				{ id = "wall.interior.edge.stone", material = "stone" },
				{ id = "wall.interior.edge.dark", material = "dark" }
			}
		},
		{
			name = "wall.interior.t-edge",

			features = {
				{ id = "wall.interior.t-edge.stone", material = "stone" },
				{ id = "wall.interior.t-edge.dark", material = "dark" }
			}
		},
		{
			name = "wall.interior.x-edge",

			features = {
				{ id = "wall.interior.x.stone", material = "stone" },
				{ id = "wall.interior.x.dark", material = "dark" }
			}
		}
	}
}
