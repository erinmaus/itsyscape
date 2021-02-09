return Parallel {
	Loop(20) {
		Map:wait(1),
		Map:poke('darken', 3)
	},

	Sequence {
		Hans:walkTo("Anchor_Hans_Target1"),
		Hans:walkTo("Anchor_Hans_Target2"),
		Hans:talk("Quickly! Through the portal!"),
		Hans:wait(5),

		Hans:talk("Hurry! Cthulhu is binding a kurse!"),
		Hans:wait(5),

		Player:talk("*glub* *glub* *glub*!"),
		Player:wait(5),

		Hans:talk("That's it, I'm forcing you through the portal before it's too late!"),
		Hans:wait(5),
		Map:poke('movePlayer')
	}
}
