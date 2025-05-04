{
	model = "Resources/Game/Skins/Common/PlayerKit1/Head.lmesh",
	pathTexture = "Resources/Game/Skins/PlayerKit2/Head/Zombi.lvg",
	colors = {
		{
			name = "Skin",

			"head1-light",
			"head2-light",
			"ear-light"
		},
		{
			name = "Shadow",
			parent = "Skin",

			hueOffset = -10,
			lightnessOffset = -20,

			"head1-shadow",
			"head2-shadow",
			"ear-shadow"
		},
		{
			name = "Patch",

			"patch1",
			"patch2"
		},
		{
			name = "Patch shadow",
			parent = "Patch",

			hueOffset = -30,
			lightnessOffset = -40,

			"patch-shadow1",
			"patch-shadow2",
			"patch-shadow3",
			"patch-shadow4"
		}
	},
	isBlocking = false
}
