{
	materials = {
		{
			name = "metal",
			material = {
				shader = "Resources/Shaders/DecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/MineCart1/Metal.lua",

				uniforms = {
					scape_NumLayers = { "integer", 1 }
				},

				properties = {
					color = "575d66",
					outlineColor = { 1, 1, 1, 1 }
				}
			}
		},
		{
			name = "splinter",
			material = {
				shader = "Resources/Shaders/DecorationSpecularMultiTriplanar",
				texture = "Resources/Game/TileSets/MineCart1/Splinter.lua",

				uniforms = {
					scape_NumLayers = { "integer", 1 }
				}
			}
		},
		{
			name = "track-plank",
			material = {
				shader = "Resources/Shaders/WallDecoration",
				texture = "Resources/Game/TileSets/MineCart1/Wood2.png"
			},

			properties = {
				outlineColor = { 1, 1, 1, 1 }
			}
		},
		{
			name = "support-plank",
			material = {
				shader = "Resources/Shaders/WallDecoration",
				texture = "Resources/Game/TileSets/MineCart1/Wood1.png"
			},

			properties = {
				outlineColor = { 1, 1, 1, 1 }
			}
		}
	},

	decorations = {
		{
			name = "straight.even",

			features = {
				{ id = "track.metal", material = "metal" },
				{ id = "track.even.plank", material = "track-plank" },
				{ id = "track.even.side", material = "splinter" },
			}
		},
		{
			name = "straight.odd",

			features = {
				{ id = "track.metal", material = "metal" },
				{ id = "track.odd.plank", material = "track-plank" },
				{ id = "track.odd.side", material = "splinter" },
			}
		},
		{
			name = "straight.even.bad",

			features = {
				{ id = "track.metal.bad", material = "metal" },
				{ id = "track.even.bad.plank", material = "track-plank" },
				{ id = "track.even.bad.side", material = "splinter" },
			}
		},
		{
			name = "straight.odd.bad",

			features = {
				{ id = "track.metal.bad", material = "metal" },
				{ id = "track.odd.bad.plank", material = "track-plank" },
				{ id = "track.odd.bad.side", material = "splinter" },
			}
		},
		{
			name = "ramp.even",

			features = {
				{ id = "track.metal.ramp", material = "metal" },
				{ id = "track.even.ramp.plank", material = "track-plank" },
				{ id = "track.even.ramp.side", material = "splinter" },
			}
		},
		{
			name = "ramp.odd",

			features = {
				{ id = "track.metal.ramp", material = "metal" },
				{ id = "track.odd.ramp.plank", material = "track-plank" },
				{ id = "track.odd.ramp.side", material = "splinter" },
			}
		},
		{
			name = "ramp.even.bad",

			features = {
				{ id = "track.metal.ramp.bad", material = "metal" },
				{ id = "track.even.bad.ramp.plank", material = "track-plank" },
				{ id = "track.even.bad.ramp.side", material = "splinter" },
			}
		},
		{
			name = "ramp.odd.bad",

			features = {
				{ id = "track.metal.ramp.bad", material = "metal" },
				{ id = "track.odd.bad.ramp.plank", material = "track-plank" },
				{ id = "track.odd.bad.ramp.side", material = "splinter" },
			}
		},
		{
			name = "left-interchange.even",

			features = {
				{ id = "track.metal.left-interchange", material = "metal" },
				{ id = "track.even.left-interchange.plank", material = "track-plank" },
				{ id = "track.even.left-interchange.side", material = "splinter" },
			}
		},
		{
			name = "left-interchange.odd",

			features = {
				{ id = "track.metal.left-interchange", material = "metal" },
				{ id = "track.odd.left-interchange.plank", material = "track-plank" },
				{ id = "track.odd.left-interchange.side", material = "splinter" },
			}
		},
		{
			name = "left-interchange.even.bad",

			features = {
				{ id = "track.metal.left-interchange.bad", material = "metal" },
				{ id = "track.even.left-interchange.bad.plank", material = "track-plank" },
				{ id = "track.even.left-interchange.bad.side", material = "splinter" },
			}
		},
		{
			name = "left-interchange.odd.bad",

			features = {
				{ id = "track.metal.left-interchange.bad", material = "metal" },
				{ id = "track.odd.left-interchange.bad.plank", material = "track-plank" },
				{ id = "track.odd.left-interchange.bad.side", material = "splinter" },
			}
		},
		{
			name = "right-interchange.even",

			features = {
				{ id = "track.metal.right-interchange", material = "metal" },
				{ id = "track.even.right-interchange.plank", material = "track-plank" },
				{ id = "track.even.right-interchange.side", material = "splinter" },
			}
		},
		{
			name = "right-interchange.odd",

			features = {
				{ id = "track.metal.right-interchange", material = "metal" },
				{ id = "track.odd.right-interchange.plank", material = "track-plank" },
				{ id = "track.odd.right-interchange.side", material = "splinter" },
			}
		},
		{
			name = "right-interchange.even.bad",

			features = {
				{ id = "track.metal.right-interchange.bad", material = "metal" },
				{ id = "track.even.right-interchange.bad.plank", material = "track-plank" },
				{ id = "track.even.right-interchange.bad.side", material = "splinter" },
			}
		},
		{
			name = "right-interchange.odd.bad",

			features = {
				{ id = "track.metal.right-interchange.bad", material = "metal" },
				{ id = "track.odd.right-interchange.bad.plank", material = "track-plank" },
				{ id = "track.odd.right-interchange.bad.side", material = "splinter" },
			}
		},
		{
			name = "support.diagonal",

			features = {
				{ id = "track.support.diagonal.plank", material = "support-plank" },
				{ id = "track.support.diagonal.side", material = "splinter" },
			}
		},
		{
			name = "support.half",

			features = {
				{ id = "track.support.half.plank", material = "support-plank" },
				{ id = "track.support.half.side", material = "splinter" },
			}
		},
		{
			name = "support.full",

			features = {
				{ id = "track.support.plank", material = "support-plank" },
				{ id = "track.support.side", material = "splinter" },
			}
		}
	}
}
