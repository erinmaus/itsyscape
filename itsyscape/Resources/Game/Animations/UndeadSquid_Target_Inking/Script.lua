Animation "Undead Squid (Target Inking)" {
	Target {
		Tint {
			0.3, 0.1, 0.3, 1.0,
			duration = 0.25,
			tween = 'sineIn'
		},

		Tint {
			0.3, 0.1, 0.3, 1.0,
			duration = 0.5,
			tween = 'constantOne'
		},

		Tint {
			0.3, 0.1, 0.3, 1.0,
			duration = 0.25,
			reverse = true,
			tween = 'sineOut'
		}
	}
}
