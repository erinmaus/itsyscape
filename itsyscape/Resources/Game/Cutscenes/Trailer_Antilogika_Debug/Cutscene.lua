return Sequence {
	Camera:zoom(15),
	Camera:target(FungalDemogorgon),

	FungalDemogorgon:teleport("FungalDemogorgon"),
	Player:teleport("Anchor_Player"),

	FungalDemogorgon:removeBehavior("MashinaBehavior"),
	FungalDemogorgon:walkTo("FungalDemogorgon"),
	FungalDemogorgon:wait(2),

	Parallel {
		Sequence {
			FungalDemogorgon:walkTo("Anchor_FungalDemogorgonPounce"),
			Camera:target(Player)
		},

		Player:walkTo("Anchor_Spawn")
	},

	FungalDemogorgon:yell("Eeeeee!!!", 2),
	FungalDemogorgon:lookAt(Player, 0.25),
	FungalDemogorgon:poke("openFlower"),
	FungalDemogorgon:usePower("Decapitate"),
	FungalDemogorgon:fireProjectile(Player, "Power_Decapitate"),
	FungalDemogorgon:wait(0.5),

	Player:yell("Aaaaah! Ouch!", 2),
	Player:wait(2)
}
