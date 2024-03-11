PLAYER_NAME = _TARGET:getName()

speaker "Grimm"
message {
	"%person{Rosalind} sent us a telegram ahead of your arrival.",
	"But it was sparse on details."
}

speaker "_TARGET"
message {
	"We were attacked by pirates! And then Cthulhu attacked!",
	"And then we landed on an island with maggots, yenderlings, and zombi!",
	"A Yendorian opened a portal to some monster called Man'tok!"
}

speaker "Grimm"
message {
	"%person{Isabelle} would surely love to hear more about your trip!",
	"She did select you to help in %hint{a special quest for an up-and-coming adventurer like yourself}...",
}

message {
	"But first things first, let's get you some rest for now."
}

local map = Utility.Peep.getMapScript(_TARGET)
map:poke('movePlayer', _TARGET)

Utility.Peep.poof(_SPEAKERS["Grimm"])
