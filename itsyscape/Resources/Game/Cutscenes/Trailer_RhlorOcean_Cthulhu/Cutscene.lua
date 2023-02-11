return Sequence {
	Map:wait(5),

	Parallel {
		Parallel {
			PlayerShip:sail({
				"Anchor_PlayerShip_1",
				"Anchor_PlayerShip_2",
				"Anchor_PlayerShip_3"
			}, 10),

			PirateShip:sail({
				"Anchor_PirateShip_1",
				"Anchor_PirateShip_2",
				"Anchor_PirateShip_3"
			}, 9)
		},

		Sequence {
			Camera:target(CapnRaven),
			Camera:zoom(40),

			Map:wait(2),

			CameraDolly:teleport("Anchor_Cthulhu_Spawn1"),
			Camera:target(CameraDolly),
			Map:poke("spawnCthulhu", "Cthulhu_Spawn"),

			Parallel {
				CameraDolly:lerpPosition("Anchor_Cthulhu_Spawn2", 1.5, 'bounceOut'),
				Camera:zoom(100, 0.5),

				Sequence {
					Map:poke("lightningZap", "Cthulhu_Lightning1"),
					Map:wait(0.5),
					Map:poke("lightningZap", "Cthulhu_Lightning2"),
				}
			},

			Camera:target(Jenkins),
			Jenkins:talk("Noooooo! Madness awaits!", 2),
			Camera:zoom(10),
			Map:wait(2),

			Camera:target(CapnRaven),
			CapnRaven:talk("Arrrr, it's time! Fire away, mates!", 2),
			Camera:zoom(15),
			Map:wait(2)
		}
	}
}
