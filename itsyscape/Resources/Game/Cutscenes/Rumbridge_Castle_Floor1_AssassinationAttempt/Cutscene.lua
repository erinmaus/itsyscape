local function Dialog()
	return While {
		Player:dialog("StartSuperSupperSaboteurCutscene"),

		Parallel {
			Sequence {
				Demon:damage(50, 100),
				Guard1:playAttackAnimation(Demon)
			},

			Sequence {
				Hellhound:damage(50, 100),
				Guard2:playAttackAnimation(Hellhound)
			},

			Sequence {
				EarlReddick:damage(0, 10),
				Demon:playAttackAnimation(EarlReddick)
			},

			Sequence {
				EarlReddick:damage(0, 10),
				Hellhound:playAttackAnimation(EarlReddick)
			},

			Map:wait(1)
		}
	}
end

return Sequence {
	Player:addBehavior("Disabled"),

	Sequence {
		Camera:target(EarlReddick),
		Camera:zoom(10),
		Camera:verticalRotate(-math.pi / 2 - math.pi / 8)
	},

	Sequence {
		Parallel {
			Demon:walkTo("Anchor_EarlReddick_Left"),
			Hellhound:walkTo("Anchor_EarlReddick_Right"),

			Parallel {
				Sequence {
					Guard1:wait(2),
					Guard1:talk("Halt!"),
					Guard1:follow(Demon, 1.5),
					Guard1:wait(1),
					Guard1:follow(Demon, 1.5),
					Guard1:face(Demon)
				},

				Sequence {
					Guard2:wait(2),
					Guard2:talk("A hellhound?!"),
					Guard2:follow(Hellhound, 1.5),
					Guard2:wait(1),
					Guard2:follow(Hellhound, 1.5),
					Guard2:face(Hellhound)
				}
			}
		},

		Demon:face(EarlReddick),
		Hellhound:face(EarlReddick),

		Camera:zoom(25, 2),
		Camera:verticalRotate(-math.pi / 2, 1.5)
	},

	Player:dialog("StartSuperSupperSaboteurCutscene"),

	Parallel {
		Sequence {
			Demon:damage(50, 100),
			Guard1:playAttackAnimation(Demon)
		},

		Sequence {
			Hellhound:damage(50, 100),
			Guard2:playAttackAnimation(Hellhound)
		},

		Sequence {
			Camera:shake(0.5),
			Demon:usePower("Tornado"),
			EarlReddick:damage(1, 15),
			Demon:playAnimation("Human_AttackZweihanderSlash_Tornado"),
			Demon:wait(2),
		},

		Sequence {
			Hellhound:wait(2),
			EarlReddick:damage(1, 15),
			Hellhound:usePower("Backstab"),
		}
	},

	Dialog(),

	Parallel {
		Sequence {
			Demon:damage(50, 100),
			Guard1:playAttackAnimation(Demon)
		},

		Sequence {
			Hellhound:damage(50, 100),
			Guard2:playAttackAnimation(Hellhound)
		},

		Sequence {
			EarlReddick:damage(1, 15),
			Demon:playAttackAnimation(EarlReddick)
		},

		Sequence {
			Hellhound:wait(2),
			EarlReddick:damage(1, 15),
			Hellhound:usePower("Backstab"),
			Hellhound:playAttackAnimation(EarlReddick)
		}
	},

	Dialog(),

	Parallel {
		Sequence {
			Demon:damage(50, 100),
			Guard1:playAttackAnimation(Demon)
		},

		Sequence {
			Hellhound:damage(50, 100),
			Guard2:playAttackAnimation(Demon)
		},

		Sequence {
			Camera:shake(0.5),
			Demon:usePower("Earthquake"),
			EarlReddick:damage(1, 15),
			Demon:fireProjectile(EarlReddick, "Power_Earthquake"),
			Demon:wait(2)
		},

		Sequence {
			Hellhound:wait(2),
			Hellhound:usePower("Decapitate"),
			Hellhound:fireProjectile(EarlReddick, "Power_Decapitate"),
			Hellhound:playAttackAnimation(EarlReddick)
		}
	},

	Dialog(),

	Parallel {
		Sequence {
			Guard1:playAttackAnimation(Demon),
			Demon:playAnimation("Human_Die_1"),
		},

		Sequence {
			Guard2:playAttackAnimation(Hellhound),
			Hellhound:playAnimation("Dog_Die"),
		}
	},

	Map:wait(2),

	Camera:target(Player),
	Camera:zoom(5),

	Parallel {
		Player:follow(EarlReddick, 2),
		Camera:zoom(25, 2)
	},

	Player:dialog("StartSuperSupperSaboteurCutscene"),

	Player:removeBehavior("Disabled")
}
