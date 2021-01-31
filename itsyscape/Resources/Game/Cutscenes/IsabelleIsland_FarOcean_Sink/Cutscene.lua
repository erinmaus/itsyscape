local DURATION = 5

return Parallel {
	Parallel {
		CapnRavensShip:lerpPosition("Anchor_Ship_Target", DURATION),
		CapnRavensShip:slerpRotation("Anchor_Ship_Target", DURATION)
	},

	Parallel {
		Sequence {
			Coelacanth1:lerpPosition("Anchor_Coelacanth1_Target", DURATION),
			Coelacanth1:poke('roam', 2, 4)
		},

		Sequence {
			Coelacanth2:lerpPosition("Anchor_Coelacanth2_Target", DURATION),
			Coelacanth2:poke('roam', 3, 6)
		}
	},

	Sequence {
		Wizard:playAnimation("Human_Idle_SleepingInVat", "main", 1, math.random()),
		Wizard:lerpPosition("Anchor_Wizard_Target", DURATION),
		Wizard:poke('die')
	},

	Sequence {
		Archer:playAnimation("Human_Idle_SleepingInVat", "main", 1, math.random()),
		Archer:lerpPosition("Anchor_Archer_Target", DURATION),
		Archer:poke('die')
	},

	Sequence {
		Parallel {
			Player:playAnimation("Human_Idle_SleepingInVat", "main", 1, math.random()),
			Player:lerpPosition("Anchor_Player_Target", DURATION)
		}
	}
}
