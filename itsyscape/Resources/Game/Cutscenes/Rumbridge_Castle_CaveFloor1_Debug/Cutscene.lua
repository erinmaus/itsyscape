return Parallel {
	Sequence {
		Camera:zoom(30),
		Camera:verticalRotate(-math.pi / 2 - math.pi / 4),
		Camera:target(Shrimp),
		Player:teleport("Anchor_Debug_VsShrimp"),
		Map:wait(2),

		Sequence {
			Shrimp:playAnimation("SaberToothShrimp_Attack_Lava", 'cutscene'),
			Camera:verticalRotate(-math.pi / 2 + math.pi / 8, 1),
			Camera:zoom(40, 0.75),
			Shrimp:wait(1.75)
		},

		Sequence {
			Camera:target(Player),
			Camera:verticalRotate(-math.pi / 2),
			Camera:zoom(15),
			Player:playAnimation("Human_AttackZweihanderSlash_Tornado", 'cutscene'),
			Player:wait(1),
			Shrimp:playAnimation("SaberToothShrimp_Attack_Lava", 'cutscene')
		},

		Sequence {
			Player:playAnimation("Human_Die_1", 'cutscene', math.huge, true),
			Player:talk("Argh!"),
			Camera:zoom(40, 1),
			Player:wait(1.5)
		}
	},

	Sequence {
		MagmaJellyfish:removeBehavior("MashinaBehavior"),
		MagmaJellyfish:teleport("Anchor_Debug_MagmaJellyfishTarget"),
		MagmaJellyfish:walkTo("Anchor_Debug_VsShrimp")
	}
}
