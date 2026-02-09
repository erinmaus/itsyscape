Animation "Tinkerer Fly" {
	fadesIn = true,
	fadesOut = true,

	Target {
		PlayAnimation "Resources/Game/Animations/Tinkerer_Fly/Begin.lanim" {
			bones = {
				"wing.l.1",
				"wing.l.2",
				"wing.l.3",
				"wing.l.4",
				"wing.r.1",
				"wing.r.2",
				"wing.r.3",
				"wing.r.4",
				"root",
			}
		},

		PlayAnimation "Resources/Game/Animations/Tinkerer_Fly/Idle.lanim" {
			repeatAnimation = true,
			bones = {
				"wing.l.1",
				"wing.l.2",
				"wing.l.3",
				"wing.l.4",
				"wing.r.1",
				"wing.r.2",
				"wing.r.3",
				"wing.r.4",
				"root",
			}
		},

		PlayAnimation "Resources/Game/Animations/Tinkerer_Fly/End.lanim" {
			bones = {
				"wing.l.1",
				"wing.l.2",
				"wing.l.3",
				"wing.l.4",
				"wing.r.1",
				"wing.r.2",
				"wing.r.3",
				"wing.r.4",
				"root",
			}
		}
	}
}
