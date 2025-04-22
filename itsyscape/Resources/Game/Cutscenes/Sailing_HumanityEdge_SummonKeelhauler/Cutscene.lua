return Sequence {
	Sequence {
		Camera:target(CapnRaven),
		Camera:zoom(10),
		Camera:horizontalRotate(-math.pi / 8),
		Camera:verticalRotate(-math.pi / 16),
	},

	CapnRaven:playAnimation("Human_Summon_Keelhauler"),
	CapnRaven:wait(60 / 24),

	Sequence {
		CameraDolly:teleport("Anchor_Dolly_KeelhaulerSpawn_Start"),

		Camera:target(CameraDolly),
		Camera:zoom(40),
		Camera:horizontalRotate(-math.pi / 8),
		Camera:verticalRotate(math.pi - math.pi / 8),
	},

	Loop(3) {
		Map:fireProjectile("Anchor_Dolly_KeelhaulerSpawn_Start", "Anchor_Dolly_KeelhaulerSpawn_Done", "StormLightning"),
		Camera:shake(0.5),
		Map:wait(0.25),
		Map:fireProjectile("Anchor_Dolly_KeelhaulerSpawn_Start", "Anchor_Dolly_KeelhaulerSpawn_Done", "CannonSplosion"),
		Map:wait(0.75)
	},

	Map:poke("summonKeelhauler", Player:getPeep()),
	Map:wait(0.25),

	Sequence {
		CameraDolly:lerpPosition("Anchor_Dolly_KeelhaulerSpawn_Done", 1)
	},

	Map:wait(0.5),

	Map:poke("attackKeelhauler", Player:getPeep())
}
