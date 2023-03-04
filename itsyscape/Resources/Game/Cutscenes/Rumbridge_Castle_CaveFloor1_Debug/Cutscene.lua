return Parallel {
	Sequence {
		Shrimp:poke('stareAt', MagmaJellyfish:getPeep()),
		Map:wait(2),

		Camera:zoom(30),
		Camera:verticalRotate(-math.pi / 2 - math.pi / 4),
		Camera:target(Shrimp),
		Player:teleport("Anchor_Debug_VsShrimp"),
		Map:wait(2),

		Player:yell("Hey, shrimp boy!", 2),
		Camera:target(Player),
		Camera:zoom(15),
		Player:playAttackAnimation(),
		Map:wait(2),

		Sequence {
			Shrimp:poke('stareAt', Player:getPeep()),
			Shrimp:playAnimation("SaberToothShrimp_Attack_Lava"),
			Camera:verticalRotate(-math.pi / 2 + math.pi / 8, 2),
			Camera:zoom(40, 1.5),
			Shrimp:wait(1.75)
		},

		Sequence {
			Camera:target(Player),
			Camera:verticalRotate(-math.pi / 2),
			Camera:zoom(15),
			Player:playAttackAnimation(),
			Player:yell("Eat dirt, clod!", 2),
			Player:usePower("Earthquake"),
			Player:fireProjectile(Shrimp, "Power_Earthquake"),
			Player:fireProjectile(Shrimp, "Power_Decapitate"),
			Player:wait(2),
			Shrimp:playAnimation("SaberToothShrimp_Attack_Lava")
		},

		Sequence {
			Player:yell("Argh!"),
			Player:playAnimation("Human_Defend_Shield_Right_1"),
			Player:wait(1),
			Player:playAnimation("Human_Run_Crazy_1", "x-cutscene", math.huge, true),
			Player:walkTo("Anchor_FromDungeon"),
			Camera:zoom(40, 1),
			Player:wait(1.5)
		}
	},

	Sequence {
		MagmaJellyfish:removeBehavior("MashinaBehavior"),
		MagmaJellyfish:teleport("Anchor_Debug_MagmaJellyfishTarget"),
		MagmaJellyfish:walkTo("Anchor_Debug_MagmaJellyfishTarget"),

		Map:wait(2),

		MagmaJellyfish:walkTo("Anchor_Debug_VsShrimp"),
		MagmaJellyfish:walkTo("Anchor_FromDungeon")
	}
}
