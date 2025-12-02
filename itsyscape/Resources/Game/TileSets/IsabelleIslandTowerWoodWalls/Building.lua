{
	materials = {
		{
			name = "grain1",
			material = {
				shader = "Resources/Shaders/DecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/IsabelleIslandTowerWoodWalls/Grain1.lua",
				uniforms = {
					scape_NumLayers = { "integer", 1 },
					scape_TriplanarScale = { "float", -0.5 },
					scape_TriplanarOffset = { "float", 0 },
					scape_TriplanarExponent = { "float", 0 },
					scape_SpecularTexture = { "texture", "Resources/Game/TileSets/IsabelleIslandTowerWoodWalls/SpecularGrain1.lua" }
				}
			}
		},
		{
			name = "grain2",
			material = {
				shader = "Resources/Shaders/DecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/IsabelleIslandTowerWoodWalls/Grain2.lua",
				uniforms = {
					scape_NumLayers = { "integer", 1 },
					scape_TriplanarScale = { "float", -0.75 },
					scape_TriplanarOffset = { "float", 0.25 },
					scape_TriplanarExponent = { "float", 0.3 },
					scape_SpecularTexture = { "texture", "Resources/Game/TileSets/IsabelleIslandTowerWoodWalls/SpecularGrain2.lua" }
				}
			}
		},
		{
			name = "wood-trim-1",
			material = {
				shader = "Resources/Shaders/WallDecoration",
				texture = "Resources/Game/TileSets/IsabelleIslandTowerWoodWalls/Interior1.png",
			}
		},
		{
			name = "wood-trim-2",
			material = {
				shader = "Resources/Shaders/WallDecoration",
				texture = "Resources/Game/TileSets/IsabelleIslandTowerWoodWalls/Interior2.png",
			}
		},
		{
			name = "wallpaper",
			material = {
				shader = "Resources/Shaders/WallDecoration",
				texture = "Resources/Game/TileSets/IsabelleIslandTowerWoodWalls/Wallpaper.png",
			}
		}
	},

	decorations = {
		{
			name = "exterior.arch",
			features = {
				{ id = "arch-edge.trim", material = "grain2" },
				{ id = "arch-edge.exterior", material = "grain1" },
				{ id = "arch-edge.interior1", material = "wood-trim-1" },
				{ id = "arch-edge.interior2", material = "wood-trim-2" },
			}
		},
		{
			name = "exterior",
			features = {
				{ id = "edge.trim", material = "grain2" },
				{ id = "edge.exterior", material = "grain1" },
				{ id = "edge.interior", material = "wood-trim-1" },
				{ id = "edge.wallpaper", material = "wallpaper" },
			}
		}
	}
}
