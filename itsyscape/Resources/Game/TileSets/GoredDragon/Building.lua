{
	materials = {
		{
			name = "muscle",
			material = {
				shader = "Resources/Shaders/StaticGoredDragon",
				texture = "Resources/Game/Skins/GoredDragon/Muscle.png",

				uniforms = {
					scape_NumLayers = { "integer", 1 }, 
					scape_SpecularWeight = { "float", 0 },
					scape_TriplanarExponent = { "float", 0 },
					scape_TriplanarOffset = { "float", 0 },
					scape_TriplanarScale = { "float", -0.75 },
					scape_Wiggle = { "float", 1.17 },
					scape_NoiseScale = { "float", 13.2, 19.48, 10.8 },
					scape_NoiseOffset = { "float", 516.34, 473.65, 158.87 },
					scape_NoiseThreshold = { "float", 0.5 },
					scape_TriplanarTexture = { "texture", "Resources/Game/Skins/GoredDragon/ScalesTexture.lua" },
					scape_TriplanarSpecularTexture = { "texture", "Resources/Game/Skins/GoredDragon/SpecularScalesTexture.lua" }
				},

				properties = {
					outlineThreshold = -0.01,
					isShadowCaster = false
				}
			}
		},
		{
			name = "bones",
			material = {
				texture = "Resources/Game/Skins/GoredDragon/Bones.png"
			}
		},
		{
			name = "organs",
			material = {
				shader = "Resources/Shaders/GoredDragonOrgans",
				texture = "Resources/Game/TileSets/GoredDragon/Organs.png"
			}
		}
	},

	decorations = {
		{
			name = "muscle",

			features = {
				{ id = "muscle", material = "muscle" }
			}
		},
		{
			name = "bones",

			features = {
				{ id = "bones", material = "bones" }
			}
		},
		{
			name = "heart",

			features = {
				{ id = "heart", material = "organs" }
			}
		},
		{
			name = "intestines",

			features = {
				{ id = "intestines", material = "organs" }
			}
		},
		{
			name = "kidney",

			features = {
				{ id = "kidney", material = "organs" }
			}
		},
		{
			name = "kinderla",

			features = {
				{ id = "kinderla", material = "organs" }
			}
		},
		{
			name = "liver",

			features = {
				{ id = "liver", material = "organs" }
			}
		},
		{
			name = "lungs",

			features = {
				{ id = "lungs", material = "organs" }
			}
		},
		{
			name = "stomach",

			features = {
				{ id = "stomach", material = "organs" }
			}
		},
		{
			name = "tinderlet",

			features = {
				{ id = "tinderlet", material = "organs" }
			}
		}
	}
}