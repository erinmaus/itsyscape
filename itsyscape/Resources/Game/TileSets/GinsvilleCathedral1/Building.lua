{
	materials = {
		{
			name = "exterior-stone",
			material = {
				shader = "Resources/Shaders/DetailDecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/GinsvilleCathedral1/Texture.png",
				uniforms = {
					scape_NumLayers = { "integer", 3 },
					scape_TriplanarScale = { "float", 0.5, -0.75, -0.5 },
					scape_TriplanarOffset = { "float", 0, 0, 0 },
					scape_TriplanarOffsetExponent = { "float", 0, 0, 0 },
					scape_TriplanarTexture = { "texture", "Resources/Game/TileSets/GinsvilleCathedral1/ExteriorStone.lua" },
					scape_TriplanarSpecularTexture = { "texture", "Resources/Game/TileSets/GinsvilleCathedral1/SpecularExteriorStone.lua" },
				},

				properties = {
					outlineThreshold = 0.5
				}
			}
		},
		{
			name = "interior-stone",
			material = {
				shader = "Resources/Shaders/DetailDecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/GinsvilleCathedral1/Texture.png",
				uniforms = {
					scape_NumLayers = { "integer", 3 },
					scape_TriplanarScale = { "float", -0.5, -0.75, -0.5 },
					scape_TriplanarOffset = { "float", 0, 0, 0 },
					scape_TriplanarOffsetExponent = { "float", 0, 0, 0 },
					scape_TriplanarTexture = { "texture", "Resources/Game/TileSets/GinsvilleCathedral1/InteriorStone.lua" },
					scape_TriplanarSpecularTexture = { "texture", "Resources/Game/TileSets/GinsvilleCathedral1/SpecularInteriorStone.lua" },
				},

				properties = {
					outlineThreshold = 0.5
				}
			}
		},
		{
			name = "decoration-stone",
			material = {
				shader = "Resources/Shaders/DetailDecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/GinsvilleCathedral1/Texture.png",
				uniforms = {
					scape_NumLayers = { "integer", 3 },
					scape_TriplanarScale = { "float", 0, -0.75, -0.5 },
					scape_TriplanarOffset = { "float", 0, 0, 0 },
					scape_TriplanarOffsetExponent = { "float", 0, 0, 0 },
					scape_TriplanarTexture = { "texture", "Resources/Game/TileSets/GinsvilleCathedral1/DecorationStone.lua" },
					scape_TriplanarSpecularTexture = { "texture", "Resources/Game/TileSets/GinsvilleCathedral1/SpecularDecorationStone.lua" },
				},

				properties = {
					outlineThreshold = 0.5
				}
			}
		},
		{
			name = "roof",
			material = {
				shader = "Resources/Shaders/DetailDecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/GinsvilleCathedral1/Texture.png",
				uniforms = {
					scape_NumLayers = { "integer", 3 },
					scape_TriplanarScale = { "float", 0.5, -0.75, -0.5 },
					scape_TriplanarOffset = { "float", 0, 0, 0 },
					scape_TriplanarOffsetExponent = { "float", 0, 0, 0 },
					scape_TriplanarTexture = { "texture", "Resources/Game/TileSets/GinsvilleCathedral1/ExteriorStone.lua" },
					scape_TriplanarSpecularTexture = { "texture", "Resources/Game/TileSets/GinsvilleCathedral1/SpecularExteriorStone.lua" },
				},

				properties = {
					outlineThreshold = 0.5
				}
			}
		},
		{
			name = "roof",
			material = {
				shader = "Resources/Shaders/DetailDecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/GinsvilleCathedral1/Texture.png",
				uniforms = {
					scape_NumLayers = { "integer", 3 },
					scape_TriplanarScale = { "float", 0.5, -0.75, -0.5 },
					scape_TriplanarOffset = { "float", 0, 0, 0 },
					scape_TriplanarOffsetExponent = { "float", 0, 0, 0 },
					scape_TriplanarTexture = { "texture", "Resources/Game/TileSets/GinsvilleCathedral1/ExteriorStone.lua" },
					scape_TriplanarSpecularTexture = { "texture", "Resources/Game/TileSets/GinsvilleCathedral1/SpecularExteriorStone.lua" },
				},

				properties = {
					outlineThreshold = 0.5
				}
			}
		},
		{
			name = "big-window",
			material = {
				shader = "Resources/Shaders/WallDecoration",
				texture = "Resources/Game/TileSets/GinsvilleCathedral1/BigWindow.png",
				properties = {
					isTranslucent = true,
					isFullLit = true,
					outlineThreshold = -1,
					glassThickness = 1
				}
			}
		},
		{
			name = "small-window",
			material = {
				shader = "Resources/Shaders/WallDecoration",
				texture = "Resources/Game/TileSets/GinsvilleCathedral1/SmallWindow.png",
				properties = {
					isTranslucent = true,
					isFullLit = true,
					outlineThreshold = -1,
					glassThickness = 1
				}
			}
		}
	},

	decorations = {
		{
			name = "wall.window.big",

			features = {
				{ id = "wall.window.big.stone1", material = "exterior-stone" },
				{ id = "wall.window.big.stone2", material = "interior-stone" },
				{ id = "wall.window.big.stone3", material = "decoration-stone" }
			}
		},
		{
			name = "window.small",

			features = {
				{ id = "window.small.stone1", material = "interior-stone" },
				{ id = "window.small.stone2", material = "exterior-stone" },
				{ id = "window.small.stone3", material = "decoration-stone" }
			}
		},
		{
			name = "window.big.glass",

			features = {
				{ id = "window.big.glass", material = "big-window" }
			}
		},
		{
			name = "window.small.glass",

			features = {
				{ id = "window.small.glass", material = "small-window" }
			}
		},
		{
			name = "window.big",

			features = {
				{ id = "window.big.stone1", material = "interior-stone" },
				{ id = "window.big.stone2", material = "exterior-stone" },
				{ id = "window.big.stone3", material = "decoration-stone" }
			}
		},
		{
			name = "wall.window.small",

			features = {
				{ id = "wall.window.stone1", material = "interior-stone" },
				{ id = "wall.window.stone2", material = "exterior-stone" },
				{ id = "wall.window.stone3", material = "decoration-stone" }
			}
		},
		{
			name = "wall.middle-decoration",

			features = {
				{ id = "wall.middle-decoration", material = "decoration-stone" }
			}
		},
		{
			name = "wall.corner.middle-decoration",

			features = {
				{ id = "wall.corner.middle-decoration", material = "decoration-stone" }
			}
		},
		{
			name = "pillar.thick",

			features = {
				{ id = "pillar.thick", material = "decoration-stone" }
			}
		},
		{
			name = "pillar.thick.curve",

			features = {
				{ id = "pillar.thick.curve", material = "decoration-stone" }
			}
		},
		{
			name = "pillar.thick.roof-cap",

			features = {
				{ id = "pillar.thick.roof-cap", material = "decoration-stone" }
			}
		},
		{
			name = "pillar.thick.roof",

			features = {
				{ id = "pillar.thick.roof", material = "decoration-stone" }
			}
		},
		{
			name = "pillar.thin",

			features = {
				{ id = "pillar.thin", material = "decoration-stone" }
			}
		},
		{
			name = "pillar.thin.damage1",

			features = {
				{ id = "pillar.thin.damage1", material = "decoration-stone" }
			}
		},
		{
			name = "pillar.thin.damage2",

			features = {
				{ id = "pillar.thin.damage2", material = "decoration-stone" }
			}
		},
		{
			name = "wall.edge",

			features = {
				{ id = "wall.edge.stone1", material = "interior-stone" },
				{ id = "wall.edge.stone2", material = "exterior-stone" }
			}
		},
		{
			name = "wall.corner",

			features = {
				{ id = "wall.corner.stone1", material = "interior-stone" },
				{ id = "wall.corner.stone2", material = "exterior-stone" }
			}
		},
		{
			name = "wall.edge.damage1",

			features = {
				{ id = "wall.edge.damage1.stone1", material = "interior-stone" },
				{ id = "wall.edge.damage1.stone2", material = "exterior-stone" }
			}
		},
		{
			name = "wall.edge.damage2",

			features = {
				{ id = "wall.edge.damage2.stone1", material = "interior-stone" },
				{ id = "wall.edge.damage2.stone2", material = "exterior-stone" }
			}
		},
		{
			name = "wall.edge.damage3",

			features = {
				{ id = "wall.edge.damage3.stone1", material = "interior-stone" },
				{ id = "wall.edge.damage3.stone2", material = "exterior-stone" }
			}
		},
		{
			name = "wall.edge.damage4",

			features = {
				{ id = "wall.edge.damage4.stone1", material = "interior-stone" },
				{ id = "wall.edge.damage4.stone2", material = "exterior-stone" }
			}
		},
		{
			name = "roof",

			features = {
				{ id = "roof", material = "roof" },
				{ id = "roof.stone1", material = "interior-stone" },
			}
		},
		{
			name = "roof.peak",

			features = {
				{ id = "roof.peak.tile", material = "roof" },
				{ id = "roof.peak.stone1", material = "interior-stone" },
			}
		},
		{
			name = "wall.roof.left",

			features = {
				{ id = "wall.roof.left.stone1", material = "interior-stone" },
				{ id = "wall.roof.left.stone2", material = "exterior-stone" },
			}
		},
		{
			name = "wall.roof.right",

			features = {
				{ id = "wall.roof.right.stone1", material = "interior-stone" },
				{ id = "wall.roof.right.stone2", material = "exterior-stone" },
			}
		},
	}
}