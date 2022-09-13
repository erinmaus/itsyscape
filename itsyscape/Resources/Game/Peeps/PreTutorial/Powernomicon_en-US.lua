speaker "Powernomicon"

message {
	"...and thus %item{copper}...",
	"...being a metal with the right resonance,",
	"can be fashioned into a %item{copper amulet}..."
}

message {
	"...which then %hint{enchanted}, can allow one to speak...",
	"...with those ghostly dead too far gone...",
}

message {
	"%empty{...Speak Their Name, in Their Glory, The Empty King, The Fate Mashina.}"
}
 
local FLAGS = { ['item-inventory'] = true }
local gaveCosmicRune = _TARGET:getState():give("Item", "CosmicRune", 1, FLAGS)
local gaveAirRune = _TARGET:getState():give("Item", "AirRune", 1, FLAGS)

speaker "_TARGET"
if gaveCosmicRune and gaveAirRune then
	message {
		"Look, some runes!",
		"Don't mind if I take them..."
	}
else
	message {
		"There's some runes stuffed in this book,",
		"but I don't have inventory space to take them."
	}
end

_TARGET:getState():give("KeyItem", "PreTutorial_LearnedToMakeGhostspeakAmulet")
