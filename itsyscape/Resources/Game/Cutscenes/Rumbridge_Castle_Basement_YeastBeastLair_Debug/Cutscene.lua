return Sequence {
	Camera:zoom(40),
	Camera:verticalRotate(-math.pi / 2 - math.pi / 8),
	Map:wait(5),

	Camera:target(CameraDolly),
	CameraDolly:teleport("Anchor_Corner1"),
	Player:face(-1),
	Player:teleport("Anchor_YeastBeast"),

	Parallel {
		CameraDolly:lerpPosition("Anchor_Corner2", 3, 'sineEaseOut'),

		Sequence {
			YeastBeast:lookAt(Player),
			YeastBeast:playAttackAnimation(Player),
			Player:playAttackAnimation(YeastBeast),
			Player:usePower("IceBarrage"),
			Player:fireProjectile(YeastBeast, "Power_IceBarrage"),
			Player:wait(3)
		}
	},

	Camera:target(Player),
	Camera:verticalRotate(-math.pi / 2),
	Camera:zoom(15),

	Player:yell("Oh no!"),
	Map:poke("attack", Player:getPeep()),

	Player:playAttackAnimation(YeastBeast),
	Player:wait(1),

	YeastBeast:playAttackAnimation(Player),
	YeastBeast:wait(1),

	Player:playAttackAnimation(YeastBeast),
	YeastBeast:fireProjectile(Player, "Power_Confuse"),
	Player:wait(1),

	Map:wait(5)
}
