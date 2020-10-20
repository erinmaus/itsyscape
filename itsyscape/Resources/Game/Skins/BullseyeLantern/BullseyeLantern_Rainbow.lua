{
	model = "Resources/Game/Skins/BullseyeLantern/BullseyeLantern.lmesh",
	texture = "Resources/Game/Skins/BullseyeLantern/BullseyeLantern_Rainbow.png",
	lights = {
		{
			type = 'ambient',
			color = { 1, 1, 1 },
			ambience = 0.1
		},
		{
			type = 'point',
			color = { 1, 0, 0 },
			position = { -1.5, 0.25, -1.5 },
			attenuation = 3
		},
		{
			type = 'point',
			color = { 1, 0.5, 0 },
			position = { 0, 0, .25,1.5 },
			attenuation = 3
		},
		{
			type = 'point',
			color = { 1, 1, 0 },
			position = { 1.5, 0.25, -1.5 },
			attenuation = 3
		},
		{
			type = 'point',
			color = { 0, 1, 0 },
			position = { -1.5, 0.25, 1.5 },
			attenuation = 3
		},
		{
			type = 'point',
			color = { 0, 0, 0 },
			position = { 0, 0, .25,.5 },
			attenuation = 3
		},
		{
			type = 'point',
			color = { 0, 0.8, 0.7 },
			position = { 1.5, 0.25, 1.5 },
			attenuation = 3
		}
	}
}
