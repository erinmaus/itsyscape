local Vector = require "ItsyScape.Common.Math.Vector"

PLAYER_NAME = _TARGET:getName()

local function focus(speakerName)
	local speakerPeep = _SPEAKERS[speakerName]
	local actor = speakerPeep:getBehavior("ActorReference")
	actor = actor and actor.actor

	if actor then
		local player = Utility.Peep.getPlayerModel(_TARGET)
		player:pokeCamera("targetActor", actor:getID())
		player:pokeCamera("zoom", 35)
		player:pokeCamera("translate", Vector(0, 0, 0))
	end

	speaker(speakerName)
end

if Utility.Quest.isNextStep("PreTutorial", "PreTutorial_Start", _TARGET) and false then
	focus "CapnRaven"

	message { 
		"Avast, %person{Jenkins}!",
		"We know yer that merchant's portmaster!",
		"Give us yer %item{loot} and ye can sail another day."
	}

	focus "Jenkins"

	message {
		"How could ye do this?",
		"We use'd t'be mates, %person{Cap'n Raven}!"
	}

	focus "CapnRaven"

	message "That t'was before ye threw off yer hat."
	message "Now give us yer valuables and out of the little respect I still have fer ye, I'll let ye live."

	focus "Orlando"
	message "No! You won't have any of my lil sis's loot!"

	focus "Rosalind"
	message "You'll have to get through us first!"

	focus "CapnRaven"
	message {
		"A young witch and a cowardly warrior?",
		"Har har har! Sea bass be scarier then ye!"
	}

	focus "Rosalind"
	message "%person{Cap'n Raven}, you'll swallow your words!"

	focus "CapnRaven"
	message "We be seein' about that, landlubber!"

	focus "Jenkins"
	message {
		"%person{${PLAYER_NAME}}, man the cannons!",
		"Aim for %person{Cap'n Raven's} ship!",
		"Ye hear me?"
	}

	focus "_TARGET"
	message "Aye aye, captain!"

	_TARGET:getState():give("KeyItem", "PreTutorial_Start")
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_CthulhuRises", _TARGET) or true then
	focus "Cthulhu"
	do
		local player = Utility.Peep.getPlayerModel(_TARGET)
		player:pokeCamera("translate", Vector(0, 10, 0))
	end
	message {
		"Screeeeeeeeeeee! Screeeeee!",
		"(MORTALS! YENDOR COMES FOR YOU!)"
	}

	focus "CapnRaven"
	message {
		"Ahahahaha! %person{Cthulhu}, we finally meet!",
		"Time t'er die!"
	}

	focus "Jenkins"
	message "Yer mad, %person{Cap'n Raven}!"

	focus "CapnRaven"
	message "So I am, ye traitor! What's it to yer?"

	focus "Rosalind"
	message "Enough with the banter! Let's get out of here!"

	focus "Orlando"
	message "YES! ARE YOU TWO CRAZY?! LET'S GO!"

	focus "Jenkins"
	message {
		"Aye! %person{${PLAYER_NAME}}, man the cannons 'n plug any leaks!",
		"%person{Rosalind}, blast them squid to 'ell with yer magic!"
	}

	focus "Rosalind"
	message "Understood, captain!"

	focus "_TARGET"
	message "Aye aye, captain!"

	_TARGET:getState():give("KeyItem", "PreTutorial_CthulhuRises")
end
