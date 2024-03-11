Animation "Cthulhu Swimming" {
	fadesIn = true,
	fadesOut = true,

	Target {
		PlayAnimation "Resources/Game/Animations/Cthulhu_Swim/Begin.lanim",
		PlayAnimation "Resources/Game/Animations/Cthulhu_Swim/Swim.lanim" {
			repeatAnimation = true
		},
		PlayAnimation "Resources/Game/Animations/Cthulhu_Swim/End.lanim"
	}
}
