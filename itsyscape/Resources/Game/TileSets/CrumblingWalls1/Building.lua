{
	materials = {
		{
			name = "bricks-front",
			material = {
				shader = "Resources/Shaders/DetailDecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/CrumblingWalls1/Bricks_Front.png",
				uniforms = {
					scape_NumLayers = { "integer", 2 },
					scape_TriplanarScale = { "float", -0.25, 0.1 },
					scape_TriplanarTexture = { "texture", "Resources/Game/TileSets/CrumblingWalls1/BricksDetail.lua" },
					scape_TriplanarSpecularTexture = { "texture", "Resources/Game/TileSets/CrumblingWalls1/SpecularBricksDetail.lua" },
				},

				properties = {
					outlineThreshold = 0.5,
					color = "463779",
				}
			}
		},
		{
			name = "bricks-side",
			material = {
				shader = "Resources/Shaders/DetailDecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/CrumblingWalls1/Bricks_Side.png",
				uniforms = {
					scape_NumLayers = { "integer", 2 },
					scape_TriplanarScale = { "float", -0.25, 0.1 },
					scape_TriplanarExponent = { "float", 0, 0 },
					scape_TriplanarOffset = { "float", 0, 0 },
					scape_TriplanarTexture = { "texture", "Resources/Game/TileSets/CrumblingWalls1/BricksDetail.lua" },
					scape_TriplanarSpecularTexture = { "texture", "Resources/Game/TileSets/CrumblingWalls1/SpecularBricksDetail.lua" },
				},

				properties = {
					outlineThreshold = 0.5,
					color = "463779",
				}
			}
		},
		{
			name = "caulk",
			material = {
				shader = "Resources/Shaders/DecorationTriplanar",
				texture = "Resources/Game/TileSets/CrumblingWalls1/Caulk.png",
				uniforms = {
					scape_NumLayers = { "integer", 2 },
					scape_TriplanarScale = { "float", 0.5 },
					scape_TriplanarExponent = { "float", 0 },
					scape_TriplanarOffset = { "float", 0 }
				},

				properties = {
					outlineThreshold = 0.5,
					color = "bfa797"
				}
			}
		}
	},

	decorations = {
		{
			name = "exterior.outer-corner",

			features = {
				{ id = "exterior.outer-corner.wall", material = "caulk" },
				{ id = "exterior.outer-corner.bricks.side", material = "bricks-side" },
				{ id = "exterior.outer-corner.bricks.front", material = "bricks-front" }
			}
		},
		{
			name = "exterior.inner-corner",

			features = {
				{ id = "exterior.inner-corner.wall", material = "caulk" },
				{ id = "exterior.inner-corner.bricks.side", material = "bricks-side" },
				{ id = "exterior.inner-corner.bricks.front", material = "bricks-front" }
			}
		},
		{
			name = "exterior.edge",

			features = {
				{ id = "exterior.edge.wall", material = "caulk" },
				{ id = "exterior.edge.bricks.side", material = "bricks-side" },
				{ id = "exterior.edge.bricks.front", material = "bricks-front" }
			}
		},
		{
			name = "exterior.edge.crumbling1",

			features = {
				{ id = "exterior.edge.crumbling1.wall", material = "caulk" },
				{ id = "exterior.edge.crumbling1.bricks.side", material = "bricks-side" },
				{ id = "exterior.edge.crumbling1.bricks.front", material = "bricks-front" }
			}
		},
		{
			name = "exterior.edge.crumbling2",

			features = {
				{ id = "exterior.edge.crumbling2.wall", material = "caulk" },
				{ id = "exterior.edge.crumbling2.bricks.side", material = "bricks-side" },
				{ id = "exterior.edge.crumbling2.bricks.front", material = "bricks-front" }
			}
		},
		{
			name = "exterior.edge.crumbling3",

			features = {
				{ id = "exterior.edge.crumbling3.wall", material = "caulk" },
				{ id = "exterior.edge.crumbling3.bricks.side", material = "bricks-side" },
				{ id = "exterior.edge.crumbling3.bricks.front", material = "bricks-front" }
			}
		},
		{
			name = "exterior.edge.crumbling4",

			features = {
				{ id = "exterior.edge.crumbling4.wall", material = "caulk" },
				{ id = "exterior.edge.crumbling4.bricks.side", material = "bricks-side" },
				{ id = "exterior.edge.crumbling4.bricks.front", material = "bricks-front" }
			}
		}
	}
}