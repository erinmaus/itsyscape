Animation "Lightning Zap (Target)" {
	Target {
		Tint {
			1.0, 1.0, 0, 1.0,
			duration = 0.25,
			tween = 'sineIn'
		},

		Tint {
			1.0, 1.0, 0, 1.0,
			duration = 0.25,
			tween = 'constantOne'
		},

		Tint {
			1.0, 1.0, 0, 1.0,
			duration = 0.25,
			reverse = true,
			tween = 'sineIn'
		}
	}
}
