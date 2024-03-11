return Sequence {
	Rosalind:setState(false),

	Camera:target(Rosalind),
	Camera:zoom(20),

	Rosalind:talk("We did it?! WE DID IT!", 3),
	Rosalind:playAnimation("Human_Jump_1"),
	Player:playAnimation("Human_Jump_1"),
	Rosalind:wait(1.5),
	Rosalind:playAnimation("Human_Jump_1"),
	Player:playAnimation("Human_Jump_1"),
	Rosalind:wait(1.5),

	Rosalind:talk("Now I need to take care of this portal!", 3),

	Parallel {
		Rosalind:walkTo("Anchor_MantokPortal", 3),
		Rosalind:wait(3)
	},

	Parallel {
		Rosalind:talk("Abyssus deaz rey estaple...", 3),
		Rosalind:playAnimation("Human_ActionEnchant_1")
	},

	Map:poke("stabilizePortal"),

	Player:dialog("TalkAboutPortal", Rosalind),

	Rosalind:setState("follow")
}
