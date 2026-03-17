{
	materials = {
		{
			name = "solid",
			material = {
				shader = "Resources/Shaders/Solid",
				texture = false,
				uniforms = {
					scape_Specular = { "float", 0 },
				},

				properties = {
					outlineThreshold = 0.5,
					color = "30231c"
				}
			}
		},
		{
			name = "grain",
			material = {
				shader = "Resources/Shaders/SpecularTriplanarWallhack",
				texture = "Resources/Game/TileSets/Cabin1/Grain.png",

				uniforms = {
					scape_TriplanarScale = { "float", -0.5 },
					scape_TriplanarOffset = { "float", 0 },
					scape_TriplanarScale = { "float", 0 },
					scape_SpecularWeight = { "float", 0 }
				},

				properties = {
					outlineThreshold = 0.5,
					color = "ffe680"
				}
			}
		},
		{
			name = "wood",
			material = {
				shader = "Resources/Shaders/WallDecoration",
				texture = "Resources/Game/TileSets/Cabin1/Wood.png",

				properties = {
					outlineThreshold = 0.5,
					color = "ffffff"
				}
			}
		},
		{
			name = "glass",
			material = {
				shader = "Resources/Shaders/WallDecoration",
				texture = "Resources/Game/TileSets/Cabin1/Window.png",

				properties = {
					color = "604ba5",
					outlineThreshold = -1,
					isTranslucent = true,
					glassThickness = 1
				}
			}
		},
		{
			name = "tile",
			material = {
				shader = "Resources/Shaders/WallDecoration",
				texture = "Resources/Game/TileSets/Cabin1/Tile.png",

				properties = {
					outlineThreshold = 0.5,
					color = "2b1f19"
				}
			}
		},
		{
			name = "corner",
			material = {
				shader = "Resources/Shaders/WallDecoration",
				texture = "Resources/Game/TileSets/Cabin1/Corner.png",

				properties = {
					outlineThreshold = 0.5,
					color = "1f1612"
				}
			}
		},
	},

	decorations = {
		{
			name = "wall.exterior.window",

			features = {
				{ id = "wall.exterior.window.wood", material = "wood" },
				{ id = "wall.exterior.window.grain", material = "grain" },
				{ id = "wall.exterior.window.glass", material = "glass" },
				{ id = "wall.exterior.window.solid", material = "solid" },
			}
		},
		{
			name = "wall.exterior.corner",

			features = {
				{ id = "wall.exterior.corner.wood", material = "wood" },
				{ id = "wall.exterior.corner.grain", material = "grain" },
				{ id = "wall.exterior.corner.solid", material = "solid" },
			}
		},
		{
			name = "wall.exterior.edge",

			features = {
				{ id = "wall.exterior.edge.wood", material = "wood" },
				{ id = "wall.exterior.edge.grain", material = "grain" },
				{ id = "wall.exterior.edge.solid", material = "solid" },
			}
		},
		{
			name = "wall.exterior.t-edge",

			features = {
				{ id = "wall.exterior.t-edge.wood", material = "wood" },
				{ id = "wall.exterior.t-edge.grain", material = "grain" },
				{ id = "wall.exterior.t-edge.solid", material = "solid" },
			}
		},
		{
			name = "wall.exterior.post",

			features = {
				{ id = "wall.exterior.post.grain", material = "grain" },
			}
		},
		{
			name = "wall.interior.corner",

			features = {
				{ id = "wall.interior.corner.grain", material = "grain" },
				{ id = "wall.interior.corner.wood", material = "wood" },
				{ id = "wall.interior.corner.solid", material = "solid" },
			}
		},
		{
			name = "wall.interior.edge",

			features = {
				{ id = "wall.interior.edge.grain", material = "grain" },
				{ id = "wall.interior.edge.wood", material = "wood" },
				{ id = "wall.interior.edge.solid", material = "solid" },
			}
		},
		{
			name = "wall.interior.t-edge",

			features = {
				{ id = "wall.interior.t-edge.grain", material = "grain" },
				{ id = "wall.interior.t-edge.solid", material = "solid" },
				{ id = "wall.interior.t-edge.wood", material = "wood" },
			}
		},
		{
			name = "wall.interior.x-edge",

			features = {
				{ id = "wall.interior.x-edge.grain", material = "grain" },
				{ id = "wall.interior.x-edge.solid", material = "solid" },
				{ id = "wall.interior.x-edge.wood", material = "wood" },
			}
		},
		{
			name = "roof.base.steep.edge",

			features = {
				{ id = "roof.base.steep.edge.tiles", material = "tile" },
				{ id = "roof.base.steep.edge.trim", material = "grain" },
			}
		},
		{
			name = "roof.base.steep.exterior-corner",

			features = {
				{ id = "roof.base.steep.exterior-corner.corner", material = "corner" },
				{ id = "roof.base.steep.exterior-corner.tiles", material = "tile" },
				{ id = "roof.base.steep.exterior-corner.trim", material = "grain" },
			}
		},
		{
			name = "roof.base.steep.interior-corner",

			features = {
				{ id = "roof.base.steep.interior-corner.corner", material = "corner" },
				{ id = "roof.base.steep.interior-corner.tiles", material = "tile" },
				{ id = "roof.base.steep.interior-corner.trim", material = "grain" },
			}
		},
		{
			name = "roof.peak.cap",

			features = {
				{ id = "roof.peak.cap.corner", material = "corner" },
				{ id = "roof.peak.cap.tiles", material = "tile" },
			}
		},
		{
			name = "roof.peak.edge",

			features = {
				{ id = "roof.peak.edge.corner", material = "corner" },
				{ id = "roof.peak.edge.tiles", material = "tile" },
			}
		},
		{
			name = "roof.peak.flat",

			features = {
				{ id = "roof.peak.flat.tiles", material = "tile" },
			}
		},
		{
			name = "roof.steep.edge",

			features = {
				{ id = "roof.steep.edge.tiles", material = "tile" },
			}
		},
		{
			name = "roof.steep.exterior-corner",

			features = {
				{ id = "roof.steep.exterior-corner.tiles", material = "tile" },
				{ id = "roof.steep.exterior-corner.corner", material = "corner" },
			}
		},
		{
			name = "roof.steep.interior-corner",

			features = {
				{ id = "roof.steep.interior-corner.tiles", material = "tile" },
				{ id = "roof.steep.interior-corner.corner", material = "corner" },
			}
		},
	}
}