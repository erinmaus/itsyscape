Animation "Corrupt Power" {
	Target {
		Tint {
			0.7, 0.2, 0.8, 1.0,
			duration = 0.25,
			tween = 'sineIn'
		},

		Tint {
			0.7, 0.2, 0.8, 1.0,
			duration = 0.5,
			tween = 'constantOne'
		},

		Tint {
			0.7, 0.2, 0.8, 1.0,
			duration = 0.25,
			reverse = true,
			tween = 'sineOut'
		}
	}
}
