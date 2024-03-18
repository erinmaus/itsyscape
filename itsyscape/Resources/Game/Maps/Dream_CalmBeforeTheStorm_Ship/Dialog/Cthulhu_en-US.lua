local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"

PLAYER_NAME = _TARGET:getName()
_TARGET:addBehavior(DisabledBehavior)

speaker "Cthulhu"
message {
	"Screeee!\n",
	"(We know you're out there. You might've escaped us for now, but we will find you.)"
}

message {
	"(The madness will turn you.)\n",
	"(Soon enough, %hint{the enchantment will fail} and the Realm will face its reckoning.)"
}

local WHAT_ENCHANTMENT = option "What's this enchantment?"
local WHY              = option "Why will the Realm fall?!"

local result = select {
	WHAT_ENCHANTMENT,
	WHY
}

if result == WHAT_ENCHANTMENT then
	speaker "_TARGET"
	message "What's this enchantment you're talking about?"

	speaker "Cthulhu"
	message {
		"Scree!\n",
		"(%empty{A usurper of divinity} banished our %person{Lady of the Shroud} and the others from the Realm eons ago.)"
	}

	message {
		"(%empty{Their} enchantment keeps the Old Ones from the Realm.",
		"But the specifics matter little. An ant can't stop a volcano and %empty{The Empty King} can't stop %person{Yendor} or any of the others.)"
	}
elseif result == WHY then
	speaker "_TARGET"
	message "Why will the Realm fall?!"

	speaker "Cthulhu"
	message {
		"(%hint{A storm is coming} from the imbalance enforced by the %empty{mockery of divinity}.",
		"A dam can't hold back a hurricane, and %empty{The Empty King} can't stop my %person{Lady of the Shroud} nor Her fellow Old Ones.)"
	}

	speaker "Cthulhu"
	message {
		"(The Realm will collapse. %hint{The return of the Old Ones is inevitable}.)"
	}
end

message {
	"(And thanks to you, %person{${PLAYER_NAME}}, a very horrifying %hint{chaos} has been introduced in the Realm.)"
}

speaker "_TARGET"
message "Chaos? How did I bring chaos?! I'm just an up-and-coming adventurer!"

speaker "Cthulhu"
message {
	"(Your understanding of %empty{Fate} means little to me. I grow tired of your questions.)"
}

message "(Leave me.)"

_TARGET:removeBehavior(DisabledBehavior)
Utility.Quest.wakeUp(_TARGET)
