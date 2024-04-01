Animation "Theodyssius Idle" {
	Channel {
		Tint {
			1, 1, 1, 0.25,
			duration = INFINITY,
			tween = 'constantOne'
		}
	},

	Target {
		PlayAnimation "Resources/Game/Animations/Theodyssius_Idle/Animation.lanim" {
			repeatAnimation = true
		}
	}
}
