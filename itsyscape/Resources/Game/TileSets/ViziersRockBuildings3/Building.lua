{
	materials = {
		{
			name = "brick",
			material = {
				shader = "Resources/Shaders/DecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/ViziersRockBuildings3/Brick.lua",
				uniforms = {
					scape_NumLayers = { "integer", 3 },
					scape_TriplanarScale = { "float", -0.5, -0.5, -0.25 }
				},

				properties = {
					outlineThreshold = 0.05,
					color = "6f7c91"
				}
			}
		},
		{
			name = "wallpaper",
			material = {
				shader = "Resources/Shaders/DecorationTriplanar",
				texture = "Resources/Game/TileSets/ViziersRockBuildings3/Wallpaper.png",

				uniforms = {
					scape_TriplanarScale = { "float", -0.5 }
				},

				properties = {
					outlineThreshold = 0.05,
					color = "ffe680"
				}
			}
		},
		{
			name = "wood",
			material = {
				shader = "Resources/Shaders/DecorationTriplanar",
				texture = "Resources/Game/TileSets/ViziersRockBuildings3/Wood.png",

				properties = {
					outlineThreshold = 0.05,
					color = "614433"
				}
			}
		},
		{
			name = "glass",
			material = {
				shader = "Resources/Shaders/WallDecoration",
				texture = "Resources/Game/TileSets/ViziersRockBuildings3/Window.png",

				properties = {
					isTranslucent = true,
					outlineThreshold = -1
				}
			}
		},
		{
			name = "tile",
			material = {
				shader = "Resources/Shaders/WallDecoration",
				texture = "Resources/Game/TileSets/ViziersRockBuildings3/Tile.png",

				properties = {
					outlineThreshold = 0.05,
					color = "aa6c00"
				}
			}
		},
		{
			name = "corner",
			material = {
				shader = "Resources/Shaders/WallDecoration",
				texture = "Resources/Game/TileSets/ViziersRockBuildings3/Corner.png",

				properties = {
					outlineThreshold = 0.05,
					color = "6f7c91"
				}
			}
		},
	},

	decorations = {
		{
			name = "wall.exterior.big-window",

			features = {
				{ id = "wall.exterior.big-window.brick", material = "brick" },
				{ id = "wall.exterior.big-window.wallpaper", material = "wallpaper" },
				{ id = "wall.exterior.big-window.wood", material = "wood" },
				{ id = "wall.window.big-window.glass", material = "glass" },
				{ id = "wall.window.big-window.wood", material = "wood" },
			}
		},
		{
			name = "wall.exterior.corner",

			features = {
				{ id = "wall.exterior.corner.brick", material = "brick" },
				{ id = "wall.exterior.corner.wallpaper", material = "wallpaper" },
				{ id = "wall.exterior.corner.wood", material = "wood" },
			}
		},
		{
			name = "wall.exterior.edge",

			features = {
				{ id = "wall.exterior.edge.brick", material = "brick" },
				{ id = "wall.exterior.edge.wallpaper", material = "wallpaper" },
				{ id = "wall.exterior.edge.wood", material = "wood" },
			}
		},
		{
			name = "wall.exterior.t-edge",

			features = {
				{ id = "wall.exterior.t-edge.brick", material = "brick" },
				{ id = "wall.exterior.t-edge1.wallpaper", material = "wallpaper" },
				{ id = "wall.exterior.t-edge2.wallpaper", material = "wallpaper" },
				{ id = "wall.exterior.t-edge.wood", material = "wood" }
			}
		},
		{
			name = "wall.exterior.wedge",

			features = {
				{ id = "wall.exterior.wedge.brick", material = "brick" },
				{ id = "wall.exterior.wedge.wallpaper", material = "wallpaper" },
				{ id = "wall.exterior.wedge.wood", material = "wood" }
			}
		},
		{
			name = "wall.exterior.wedge",

			features = {
				{ id = "wall.exterior.wedge.brick", material = "brick" },
				{ id = "wall.exterior.wedge.wallpaper", material = "wallpaper" },
				{ id = "wall.exterior.wedge.wood", material = "wood" }
			}
		},
		{
			name = "wall.interior.corner",

			features = {
				{ id = "wall.interior.corner1.wallpaper", material = "wallpaper" },
				{ id = "wall.interior.corner2.wallpaper", material = "wallpaper" },
				{ id = "wall.interior.corner.wood", material = "wood" }
			}
		},
		{
			name = "wall.interior.edge",

			features = {
				{ id = "wall.interior.edge1.wallpaper", material = "wallpaper" },
				{ id = "wall.interior.edge2.wallpaper", material = "wallpaper" },
				{ id = "wall.interior.edge.wood", material = "wood" }
			}
		},
		{
			name = "wall.interior.t-edge",

			features = {
				{ id = "wall.interior.t-edge1.wallpaper", material = "wallpaper" },
				{ id = "wall.interior.t-edge2.wallpaper", material = "wallpaper" },
				{ id = "wall.interior.t-edge3.wallpaper", material = "wallpaper" },
				{ id = "wall.interior.t-edge.wood", material = "wood" }
			}
		},
		{
			name = "wall.interior.x",

			features = {
				{ id = "wall.interior.x1.wallpaper", material = "wallpaper" },
				{ id = "wall.interior.x2.wallpaper", material = "wallpaper" },
				{ id = "wall.interior.x3.wallpaper", material = "wallpaper" },
				{ id = "wall.interior.x4.wallpaper", material = "wallpaper" },
				{ id = "wall.interior.x.wood", material = "wood" }
			}
		},
		{
			name = "roof.base.steep.edge",

			features = {
				{ id = "roof.base.steep.edge.tiles", material = "tile" },
				{ id = "roof.base.steep.edge.trim", material = "wood" },
			}
		},
		{
			name = "roof.base.steep.exterior-corner",

			features = {
				{ id = "roof.base.steep.exterior-corner.corner", material = "corner" },
				{ id = "roof.base.steep.exterior-corner.tiles", material = "tile" },
				{ id = "roof.base.steep.exterior-corner.trim", material = "wood" },
			}
		},
		{
			name = "roof.base.steep.interior-corner",

			features = {
				{ id = "roof.base.steep.interior-corner.corner", material = "corner" },
				{ id = "roof.base.steep.interior-corner.tiles", material = "tile" },
				{ id = "roof.base.steep.interior-corner.trim", material = "wood" },
			}
		},
		{
			name = "roof.peak.cap",

			features = {
				{ id = "roof.peak.cap.corner", material = "corner" },
				{ id = "roof.peak.cap.tiles", material = "tile" }
			}
		},
		{
			name = "roof.peak.edge",

			features = {
				{ id = "roof.peak.edge.corner", material = "corner" },
				{ id = "roof.peak.edge.tiles", material = "tile" }
			}
		},
		{
			name = "roof.peak.flat",

			features = {
				{ id = "roof.peak.flat.tiles", material = "tile" }
			}
		},
		{
			name = "roof.steep.edge",

			features = {
				{ id = "roof.steep.edge.tiles", material = "tile" }
			}
		},
		{
			name = "roof.steep.exterior-corner",

			features = {
				{ id = "roof.steep.exterior-corner.tiles", material = "tile" },
				{ id = "roof.steep.exterior-corner.corner", material = "corner" }
			}
		},
		{
			name = "roof.steep.interior-corner",

			features = {
				{ id = "roof.steep.interior-corner.tiles", material = "tile" },
				{ id = "roof.steep.interior-corner.corner", material = "corner" }
			}
		},
	}
}