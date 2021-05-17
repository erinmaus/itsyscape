PLAYER_NAME = _TARGET:getName()

speaker "Orlando"
message {
	"'Ey, we're so glad you're alive!",
	"When that ship sunk, only Jenkins washed ashore.",
}

speaker "_TARGET"
message {
	"A zombi opened a portal, I think!",
	"I was in this weird shadow world!",
	"Everything was dark and creepy."
}

speaker "Orlando"
message {
	"Sounds like a case of scurvy or somethin' to me!",
	"Let me talk you down to %person{lady Isabelle}."
}

local map = Utility.Peep.getMapScript(_TARGET)
map:poke('movePlayer')
