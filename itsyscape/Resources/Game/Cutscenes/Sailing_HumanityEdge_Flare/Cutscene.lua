local function r(min, max)
	return love.math.random() * (math.max(min, max) - math.min(min, max)) + math.min(min, max)
end

local PATH = {
	Vector(r(-2, 2), r(4, 6), r(-2, 2)),
	Vector(r(-2, 2), r(4, 6), r(-2, 2)),
	Vector(r(-2, 2), r(4, 6), r(-2, 2)),
	Vector(r(-2, 2), r(4, 6), r(-2, 2)),
	Vector(r(-2, 2), r(4, 6), r(-2, 2))
}

return Parallel {
	Sequence {
		Scout:playAnimation("Yendorian_Attack_Flare"),
		Scout:wait(1),

		Scout:playAnimation("Yendorian_Die")
	},

	Sequence {
		Flare:teleport("Anchor_FlareHidden"),
		CameraDolly:teleport(Scout),

		Camera:target(CameraDolly),
		Camera:zoom(15),

		CameraDolly:wait(0.5),

		Parallel {
			Sequence {
				Flare:teleport(Scout),
				Flare:lerpPosition(PATH[1], 0.5),
				Flare:lerpPosition(PATH[2], 0.5),
				Flare:lerpPosition(PATH[3], 0.5),
				Flare:lerpPosition(PATH[4], 0.5),
				Flare:lerpPosition(PATH[5], 0.5)
			},

			Sequence {
				CameraDolly:teleport(Scout),
				CameraDolly:lerpPosition(PATH[1], 0.5),
				CameraDolly:lerpPosition(PATH[2], 0.5),
				CameraDolly:lerpPosition(PATH[3], 0.5),
				CameraDolly:lerpPosition(PATH[4], 0.5),
				CameraDolly:lerpPosition(PATH[5], 0.5)
			}
		},

		Flare:wait(2)
	}
}
