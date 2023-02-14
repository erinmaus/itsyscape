return Sequence {
	Map:wait(5),

	Parallel {
		Parallel {
			PlayerShip:sail({
				"Anchor_PlayerShip_1",
				"Anchor_PlayerShip_2",
				"Anchor_PlayerShip_3"
			}, 22),

			PirateShip:sail({
				"Anchor_PirateShip_1",
				"Anchor_PirateShip_2",
				"Anchor_PirateShip_3"
			}, 18)
		},

		Sequence {
			Camera:verticalRotate(-math.pi / 2 + math.pi / 8),
			Camera:target(CapnRaven),
			Camera:zoom(40),

			Map:wait(4),

			CameraDolly:teleport("Anchor_Cthulhu_Spawn1"),
			Camera:verticalRotate(-math.pi / 2),
			Camera:target(CameraDolly),
			Map:wait(0.25),
			Map:poke("spawnCthulhu", "Cthulhu_Spawn"),

			Parallel {
				CameraDolly:lerpPosition("Anchor_Cthulhu_Spawn2", 2, 'bounceIn'),
				Camera:zoom(100, 0.5),

				Sequence {
					Map:poke("lightningZap"),
					Map:poke("lightningZap"),
					Map:wait(0.5),
					Map:poke("lightningZap"),
					Map:wait(0.75),
					Map:poke("lightningZap"),
					Map:poke("lightningZap"),
					Map:poke("lightningZap"),
					Map:wait(0.5)
				}
			},

			Camera:target(Jenkins),
			Jenkins:yell("Noooooo! Madness awaits!", 3),
			Camera:zoom(10),
			Map:wait(3),

			Camera:target(CapnRaven),
			CapnRaven:yell("Arrrr, it's time! Fire away, mates!", 3),
			Camera:zoom(15),
			Map:wait(3),

			Camera:target(CameraDolly),
			Camera:verticalRotate(-math.pi / 2 - math.pi / 4),
			Camera:verticalRotate(-math.pi / 2 + math.pi / 8, 1.5),
			Camera:zoom(75, 1.5),
			Map:wait(0.5),
			Map:poke('firePiratesCannons')
		}
	}
}
