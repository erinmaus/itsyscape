{
	materials = {
		{
			name = "book",
			material = {
				shader = "Resources/Shaders/MultiTextureDecoration",
				texture = "Resources/Game/TileSets/Books1/Texture.lua",
				uniforms = {
					scape_SpecularTexture = { "texture", "Resources/Game/TileSets/Books1/SpecularTexture.lua" },
				},

				properties = {
					outlineThreshold = 0.5
				}
			}
		}
	},

	decorations = {
		{
			name = "leather1",

			features = {
				{ id = "book", material = "book", texture = 1 },
				{ id = "book.pages", material = "book", texture = 3 },
				--{ id = "book.cover", material = "book", texture = 4 },
			}
		},
		{
			name = "leather2",

			features = {
				{ id = "book", material = "book", texture = 1 },
				{ id = "book.pages", material = "book", texture = 3 },
				--{ id = "book.cover", material = "book", texture = 5 },
			}
		},
		{
			name = "velvet1",

			features = {
				{ id = "book", material = "book", texture = 2 },
				{ id = "book.pages", material = "book", texture = 3 },
				--{ id = "book.cover", material = "book", texture = 4 },
			}
		},
		{
			name = "velvet2",

			features = {
				{ id = "book", material = "book", texture = 2 },
				{ id = "book.pages", material = "book", texture = 3 },
				--{ id = "book.cover", material = "book", texture = 5 },
			}
		}
	}
}
