Animation "Undead Squid Mn'thro Swim" {
	fadesIn = true,
	fadesOut = true,

	Target {
		PlayAnimation "Resources/Game/Animations/UndeadSquid_Swim/Sink.lanim",
		PlayAnimation "Resources/Game/Animations/UndeadSquid_Swim/SurfaceSwim.lanim",
		PlayAnimation "Resources/Game/Animations/UndeadSquid_Swim/Swim.lanim" {
			repeatAnimation = true
		},
		PlayAnimation "Resources/Game/Animations/UndeadSquid_Swim/SwimSink.lanim"
	}
}
