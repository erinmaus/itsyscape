return Sequence {
	Camera:zoom(20),
	Camera:target(Theodyssius),
	Camera:verticalRotate(-math.pi / 2 - math.pi / 8),
	Theodyssius:teleport("Theodyssius"),
	Player:teleport("Anchor_Spawn"),
	Player:face(-1),
	Map:wait(4),

	Camera:translate(Vector(0, 15, 0), 8),
	Camera:zoom(100, 4),

	Parallel {
		Map:wait(2),

		Theodyssius:lookAt(Player, 0.5),
		Theodyssius:playAttackAnimation(Player),
		Player:playAttackAnimation(Theodyssius)
	},

	Camera:zoom(20),
	Camera:translate(Vector.ZERO),
	Camera:target(Player),
	Camera:verticalRotate(-math.pi / 2),

	Player:yell("Feel the singularity!", 2),
	Player:usePower("Gravity"),
	Theodyssius:playAttackAnimation(Player),
	Player:playAttackAnimation(Theodyssius),
	Player:wait(2),

	Camera:target(Theodyssius),
	Camera:zoom(40),
	Camera:verticalRotate(-math.pi / 2 - math.pi / 8),
	Player:fireProjectile(Theodyssius, "Power_Gravity"),

	Theodyssius:playAttackAnimation(Player),
	Theodyssius:yell("Taste Judgment!", 2),
	Theodyssius:playAttackAnimation(Player),
	Player:playAttackAnimation(Theodyssius),
	Theodyssius:wait(2),
	Theodyssius:usePower("IceBarrage"),
	Theodyssius:fireProjectile(Player, "Power_IceBarrage"),
	Theodyssius:playAttackAnimation(),
	Theodyssius:wait(2),

	Camera:target(Player),
	Camera:zoom(20),
	Camera:verticalRotate(-math.pi / 2),

	Theodyssius:fireProjectile(Player, "Power_IceBarrage"),
	Theodyssius:playAttackAnimation(Player),
	Player:yell("Brrr!", 2),
	Player:wait(2),
}
