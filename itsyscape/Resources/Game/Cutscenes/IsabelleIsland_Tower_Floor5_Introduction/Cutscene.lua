return Sequence {
	Player:addBehavior("Disabled"),
	Camera:target(Orlando),
	Camera:zoom(40),
	Map:performNamedAction("OrlandoYell1", Player),
	Orlando:wait(5),
	Camera:zoom(20, 5),
	
	Parallel {
		Orlando:walkTo("Anchor_OrlandoOnTower"),

		Sequence {
			Orlando:wait(2),
			Orlando:talk("Huff... Huff... Huff..."),
			Orlando:wait(4),
			Orlando:talk("Wow, who built this dumb tower?!"),
		}
	},

	Map:performNamedAction("OrlandoYell2", Player),
	Player:removeBehavior("Disabled")
}
