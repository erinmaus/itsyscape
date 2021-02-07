local DURATION = 5

return Sequence {
	Player:addBehavior("Disabled"),
	Portal:lerpScale("Anchor_Portal_Target", DURATION),
	Player:wait(1),
	Player:playAnimation("Human_Teleport_1"),
	Player:wait(0.2),
	Player:removeBehavior("Disabled"),
	Map:poke('movePlayer')
}
