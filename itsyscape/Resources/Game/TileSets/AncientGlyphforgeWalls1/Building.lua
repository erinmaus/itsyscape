{
	materials = {
		{
			name = "stone",
			material = {
				shader = "Resources/Shaders/DetailDecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/AncientGlyphforgeWalls1/Texture.png",
				uniforms = {
					scape_NumLayers = { "integer", 3 },
					scape_TriplanarScale = { "float", 0, 0, -0.5 },
					scape_TriplanarOffset = { "float", 0, 0, 0 },
					scape_TriplanarExponent = { "float", 0, 0, 0 },
					scape_SpecularWeight = { "float", 1 },
					scape_TriplanarTexture = { "texture", "Resources/Game/TileSets/AncientGlyphforgeWalls1/Stone.lua" },
					scape_TriplanarSpecularTexture = { "texture", "Resources/Game/TileSets/AncientGlyphforgeWalls1/SpecularStone.lua" },
				},

				properties = {
					outlineThreshold = 0.5,
					color = "ffffff"
				}
			}
		}
	},

	decorations = {
		{
			name = "wall.exterior-corner",

			features = {
				{ id = "wall.exterior-corner", material = "stone" }
			}
		},
		{
			name = "wall.exterior-corner.crumbling1",

			features = {
				{ id = "wall.exterior-corner.crumbling1", material = "stone" }
			}
		},
		{
			name = "wall.interior-corner.crumbling2",

			features = {
				{ id = "wall.interior-corner.crumbling2", material = "stone" }
			}
		},
		{
			name = "wall.interior-corner.crumbling1",

			features = {
				{ id = "wall.interior-corner.crumbling1", material = "stone" }
			}
		},
		{
			name = "wall.flat.crumbling4",

			features = {
				{ id = "wall.flat.crumbling4", material = "stone" }
			}
		},
		{
			name = "wall.flat.crumbling3",

			features = {
				{ id = "wall.flat.crumbling3", material = "stone" }
			}
		},
		{
			name = "wall.flat.crumbling2",

			features = {
				{ id = "wall.flat.crumbling2", material = "stone" }
			}
		},
		{
			name = "wall.flat.crumbling1",

			features = {
				{ id = "wall.flat.crumbling1", material = "stone" }
			}
		},
		{
			name = "wall.interior-corner",

			features = {
				{ id = "wall.interior-corner", material = "stone" }
			}
		},
		{
			name = "wall.exterior-corner.crumbling2",

			features = {
				{ id = "wall.exterior-corner.crumbling2", material = "stone" }
			}
		},
		{
			name = "wall.flat",

			features = {
				{ id = "wall.flat", material = "stone" }
			}
		}
	}
}
