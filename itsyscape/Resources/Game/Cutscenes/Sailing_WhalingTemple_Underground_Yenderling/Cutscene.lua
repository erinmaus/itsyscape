return Sequence {
	Rosalind:setState(false),

	Camera:target(Rosalind),
	Rosalind:talk("What the - is that...?", 3),
	Rosalind:wait(1),

	Rosalind:walkTo("Anchor_BeforeYenderling"),

	Rosalind:talk("Watch out! There's a yenderling here!"),

	Yenderling:talk("Scree! Screeeeee!"),
	Yenderling:attack(Rosalind),
	Rosalind:attack(Yenderling),

	Player:dialog("TalkAboutDungeon", Rosalind),
	Rosalind:setState("follow")
}
