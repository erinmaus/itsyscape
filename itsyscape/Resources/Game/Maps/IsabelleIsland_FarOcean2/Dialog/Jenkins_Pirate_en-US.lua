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

if Utility.Quest.isNextStep("PreTutorial", "PreTutorial_Start", _TARGET) then
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
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_CthulhuRises", _TARGET) then
	focus "Cthulhu"
	do
		local player = Utility.Peep.getPlayerModel(_TARGET)
		player:pokeCamera("translate", Vector(0, 10, 0))
	end
	message {
		"Screeeeeeeeeeee! Screeeeee!\n",
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
	message {
		"Enough with the banter! Let's get out of here!",
		"Look what Cthulhu did with his Starfall attack!",
		"He's not wasting time!"
	}

	focus "Orlando"
	message "YES! ARE YOU TWO CRAZY?! LET'S GO!"

	focus "Jenkins"
	message {
		"Aye! %person{${PLAYER_NAME}}, man the cannons 'n plug any leaks!",
		"%person{Rosalind}, blast them squid to 'ell with yer magic!",
		"I'll get us out o' harm's way!"
	}

	focus "Rosalind"
	message "Understood, captain!"

	focus "_TARGET"
	message "Aye aye, captain!"

	_TARGET:getState():give("KeyItem", "PreTutorial_CthulhuRises")
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_DefendShip", _TARGET) then
	focus "Rosalind"
	message {
		"We did it!",
		"%person{${PLAYER_NAME}}! You're certainly a promising adventurer!"
	}

	focus "Orlando"
	message {
		"Definitely!",
		"Good job %person{${PLAYER_NAME}} and ... %person{Rosalind} ... *sigh*.",
		"(Maybe I should be more like " .. Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_OBJECT) .. "...)"
	}

	focus "Jenkins"
	message {
		"Aye, ye two did well.",
		"But th' %person{Soaked Log} be shamblin',",
		"we best find a port and fix 'er up!",
	}
	message "There be an abandoned Yendorian outpost in th' distance."

	focus "Rosalind"
	message {
		"The old %location{Whaling Temple}...",
		"It might not be as abandoned as we think."
	}

	focus "Orlando"
	message "The w-whaling temple? Isn't that..."

	focus "Jenkins"
	message {
		"Well, we ain't got much o' choice now do we?",
		"I got ye three to keep us safe, aye?"
	}

	focus "Rosalind"
	message "You can count on me!"

	focus "Orlando"
	message "And me!"

	focus "_TARGET"
	local AND_ME = option "Don't forget me!"
	local UHH = option "Uh..."

	local result = select {
		AND_ME,
		UHH
	}

	if result == AND_ME then
		message "Don't forget me!"

		focus "Jenkins"
		message {
			"Aye, charting a trail for the %location{Whaling Temple}.",
			"Be ready, mates."
		}
	elseif result == UHH then
		message "Uh, I don't know about this..."

		focus "Jenkins"
		message {
			"Wet feet? Har har har!",
			"Let's be ready for anythin', mates.",
			"To the %location{Whaling Temple}!"
		}
	end

	_TARGET:getState():give("KeyItem", "PreTutorial_DefendShip")
end
