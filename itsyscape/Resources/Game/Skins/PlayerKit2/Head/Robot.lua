{
	model = "Resources/Game/Skins/Common/PlayerKit1/Head.lmesh",
	pathTexture = "Resources/Game/Skins/PlayerKit2/Head/Robot.lvg",
	colors = {
		{
			name = "Metal",

			"head1",
			"head2",
			"ear1"
		},
		{
			name = "Shadow",
			parent = "Metal",

			hueOffset = -20,
			lightnessOffset = -40,

			"shadow1",
			"shadow2",
			"ear2"
		},
		{
			name = "Highlight",
			parent = "Metal",

			hueOffset = 20,
			lightnessOffset = 40,
			saturationOffset = 35,

			"highlight"
		}
	},
	isBlocking = false
}
