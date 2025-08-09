{
	materials = {
		{
			name = "splinter",
			material = {
				shader = "Resources/Shaders/DecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/Scaffolding1/Splinter.lua",

				uniforms = {
					scape_NumLayers = { "integer", 1 }
				}
			}
		},
		{
			name = "scaffold-plank",
			material = {
				shader = "Resources/Shaders/WallDecoration",
				texture = "Resources/Game/TileSets/Scaffolding1/Wood2.png"
			},

			properties = {
				outlineColor = { 1, 1, 1, 1 }
			}
		},
		{
			name = "fence-plank",
			material = {
				shader = "Resources/Shaders/WallDecoration",
				texture = "Resources/Game/TileSets/Scaffolding1/Wood1.png"
			},

			properties = {
				outlineColor = { 1, 1, 1, 1 }
			}
		},
		{
			name = "twine",
			material = {
				shader = "Resources/Shaders/WallDecoration",
				texture = "Resources/Game/TileSets/Scaffolding1/Twine.png"
			},

			properties = {
				outlineColor = { 1, 1, 1, 1 }
			}
		}
	},

	decorations = {
		{
			name = "fence.post",

			features = {
				{ id = "barrier.post.plank", material = "fence-plank" },
				{ id = "barrier.post.side", material = "splinter" }
			}
		},
		{
			name = "fence.even",

			features = {
				{ id = "barrier.fence.even.plank", material = "fence-plank" },
				{ id = "barrier.fence.even.side", material = "splinter" }
			}
		},
		{
			name = "fence.odd",

			features = {
				{ id = "barrier.fence.odd.plank", material = "fence-plank" },
				{ id = "barrier.fence.odd.side", material = "splinter" }
			}
		},
		{
			name = "scaffolding.even",

			features = {
				{ id = "scaffolding.plank", material = "scaffold-plank" },
				{ id = "scaffolding.plank.side", material = "splinter" },
				{ id = "scaffolding.even.twine", material = "twine" },
				{ id = "scaffolding.even.supports", material = "splinter" },
			}
		},
		{
			name = "scaffolding.even.bad",

			features = {
				{ id = "scaffolding.plank.bad", material = "scaffold-plank" },
				{ id = "scaffolding.plank.side.bad", material = "splinter" },
				{ id = "scaffolding.even.twine", material = "twine" },
				{ id = "scaffolding.even.supports", material = "splinter" },
			}
		},
		{
			name = "scaffolding.odd",

			features = {
				{ id = "scaffolding.plank", material = "scaffold-plank" },
				{ id = "scaffolding.plank.side", material = "splinter" },
				{ id = "scaffolding.odd.twine", material = "twine" },
				{ id = "scaffolding.odd.supports", material = "splinter" },
			}
		},
		{
			name = "scaffolding.odd.bad",

			features = {
				{ id = "scaffolding.plank.bad", material = "scaffold-plank" },
				{ id = "scaffolding.plank.side.bad", material = "splinter" },
				{ id = "scaffolding.odd.twine", material = "twine" },
				{ id = "scaffolding.odd.supports", material = "splinter" },
			}
		},
		{
			name = "scaffolding.even",

			features = {
				{ id = "scaffolding.plank", material = "scaffold-plank" },
				{ id = "scaffolding.plank.side", material = "splinter" },
				{ id = "scaffolding.even.twine", material = "twine" },
				{ id = "scaffolding.even.supports", material = "splinter" },
			}
		},
		{
			name = "scaffolding.even.bad",

			features = {
				{ id = "scaffolding.plank.bad", material = "scaffold-plank" },
				{ id = "scaffolding.plank.side.bad", material = "splinter" },
				{ id = "scaffolding.even.twine", material = "twine" },
				{ id = "scaffolding.even.supports", material = "splinter" },
			}
		},
		{
			name = "scaffolding.odd.cap",

			features = {
				{ id = "scaffolding.plank", material = "scaffold-plank" },
				{ id = "scaffolding.plank.side", material = "splinter" },
				{ id = "scaffolding.odd.cap.twine", material = "twine" },
				{ id = "scaffolding.odd.cap.supports", material = "splinter" },
			}
		},
		{
			name = "scaffolding.odd.cap.bad",

			features = {
				{ id = "scaffolding.plank.bad", material = "scaffold-plank" },
				{ id = "scaffolding.plank.side.bad", material = "splinter" },
				{ id = "scaffolding.odd.cap.twine", material = "twine" },
				{ id = "scaffolding.odd.cap.supports", material = "splinter" },
			}
		},
		{
			name = "scaffolding.even.cap",

			features = {
				{ id = "scaffolding.plank", material = "scaffold-plank" },
				{ id = "scaffolding.plank.side", material = "splinter" },
				{ id = "scaffolding.even.cap.twine", material = "twine" },
				{ id = "scaffolding.even.cap.supports", material = "splinter" },
			}
		},
		{
			name = "scaffolding.even.cap.bad",

			features = {
				{ id = "scaffolding.plank.bad", material = "scaffold-plank" },
				{ id = "scaffolding.plank.side.bad", material = "splinter" },
				{ id = "scaffolding.even.cap.twine", material = "twine" },
				{ id = "scaffolding.even.cap.supports", material = "splinter" },
			}
		},
		{
			name = "scaffolding.diagonal",

			features = {
				{ id = "scaffolding.plank.diagonal", material = "scaffold-plank" },
				{ id = "scaffolding.plank.diagonal.side", material = "splinter" },
				{ id = "scaffolding.diagonal.twine", material = "twine" },
				{ id = "scaffolding.diagonal", material = "splinter" },
			}
		},
		{
			name = "scaffolding.diagonal.bad",

			features = {
				{ id = "scaffolding.plank.diagonal.bad", material = "scaffold-plank" },
				{ id = "scaffolding.plank.diagonal.side.bad", material = "splinter" },
				{ id = "scaffolding.diagonal.twine", material = "twine" },
				{ id = "scaffolding.diagonal", material = "splinter" },
			}
		},
	}
}
