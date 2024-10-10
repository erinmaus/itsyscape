{
	model = "Resources/Game/Skins/Common/PlayerKit1/Head.lmesh",
	pathTexture = "Resources/Game/Skins/PlayerKit2/Head/Dummy.lvg",
	colors = {
		{
			name = "Cloth",

			"head1",
			"head2"
		},
		{
			name = "Shadow",
			parent = "Cloth",

			hueOffset = -10,
			lightnessOffset = -20,

			"head1-shadow",
			"head2-shadow",
			"ear-shadow"
		},
		{
			name = "Patch",
			parent = "Cloth",

			hueOffset = 35,
			lightnessOffset = -20,

			"patch1",
			"patch2"
		}
	},
	isBlocking = false
}
