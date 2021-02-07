local DURATION = 5

return Parallel {
	Sequence {
		Player:addBehavior("Disabled"),
		Portal:lerpScale("Anchor_Portal_Target", DURATION),
		Player:wait(1),
		Player:playAnimation("Human_Teleport_1"),
		Player:wait(0.4),
		Player:removeBehavior("Disabled"),
		Map:poke('movePlayer')
	},

	Sequence {
		Hans:walkTo("Anchor_Hans_Target1"),
		Hans:talk("Quickly! Through the portal!"),
		Hans:walkTo("Anchor_Hans_Target2"),
		Player:wait(2),
		Player:talk("*glub* *glub* *glub*!"),
	}
}
