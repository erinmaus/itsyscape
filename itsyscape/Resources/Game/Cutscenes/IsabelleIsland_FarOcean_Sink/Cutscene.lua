local DURATION = 20

return Parallel {
	Parallel {
		CapnRavensShip:lerpPosition("Anchor_Ship_Target", DURATION),
		CapnRavensShip:slerpRotation("Anchor_Ship_Target", DURATION)
	},

	Parallel {
		Wizard:playAnimation("Human_Idle_SleepingInVat", "main", 1, math.random()),
		Wizard:lerpPosition("Anchor_Wizard_Target", DURATION)
	},

	Parallel {
		Archer:playAnimation("Human_Idle_SleepingInVat", "main", 1, math.random()),
		Archer:lerpPosition("Anchor_Archer_Target", DURATION)
	},

	Sequence {
		Parallel {
			Player:playAnimation("Human_Idle_SleepingInVat", "main", 1, math.random()),
			Player:lerpPosition("Anchor_Player_Target", DURATION)
		}
	}
}
