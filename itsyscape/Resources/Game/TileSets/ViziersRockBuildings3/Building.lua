{
	materials = {
		{
			name = "brick",
			material = {
				shader = "Resources/Shaders/SpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/ViziersRockBuildings3/Brick.lua",
				uniforms = {
					scape_NumLayers = { "integer", 3 },
					scape_TriplanarScale = { "float", -0.5, -0.5, -0.25 }
				},

				properties = {
					outlineThreshold = 0.5,
					color = "6f7c91"
				}
			}
		},
		{
			name = "wallpaper",
			material = {
				shader = "Resources/Shaders/Triplanar",
				texture = "Resources/Game/TileSets/ViziersRockBuildings3/Wallpaper.png",

				uniforms = {
					scape_TriplanarScale = { "float", -0.5 }
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
				shader = "Resources/Shaders/Triplanar",
				texture = "Resources/Game/TileSets/ViziersRockBuildings3/Wood.png",

				properties = {
					outlineThreshold = 0.5,
					color = "614433"
				}
			}
		},
		{
			name = "glass",
			material = {
				shader = "Resources/Shaders/Decoration",
				texture = "Resources/Game/TileSets/ViziersRockBuildings3/Window.png",

				properties = {
					isTranslucent = true,
					outlineThreshold = -1
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
	}
}