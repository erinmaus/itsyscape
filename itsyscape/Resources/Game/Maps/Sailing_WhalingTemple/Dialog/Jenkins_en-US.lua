local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"

PLAYER_NAME = _TARGET:getName()

if Utility.Quest.isNextStep("PreTutorial", "PreTutorial_ArriveAtTheWhalingTemple", _TARGET) then
	_TARGET:addBehavior(DisabledBehavior)

	speaker "Jenkins"
	message {
		"We be at the %location{Whaling Temple}, mates...",
		"%person{Rosalind} and %person{Orlando}, stay with me 'n the crew.",
		"%person{${PLAYER_NAME}}, ye have the honor of explorin' the island."
	}

	speaker "Rosalind"
	message {
		"If I may, %person{Jenkins}, I think we should split into pairs.",
		"%person{Orlando} and you can stay near the ship,",
		"while %person{${PLAYER_NAME}} and me can explore the island.",
	}

	message {
		"I'll keep %hint{a scry open on the sea},",
		"in case %person{Cthulhu} or some of his minions come close.",
		"We'll turn around if that happens."
	}

	speaker "_TARGET"
	message {
		"I think that's a good idea...",
		"After all, I'm new to all this!"
	}

	speaker "Jenkins"
	message {
		"Hmmph. I s'pose that would be best.",
		"Bastiel knows what be out here..."
	}

	message {
		"Ye both best come back with supplies, then.",
		"We be needin' wood and food."
	}

	speaker "Rosalind"
	message {
		"We will!",
		"Alright, let's head out, %person{${PLAYER_NAME}}!"
	}

	speaker "_TARGET"
	message "Got it!"

	speaker "Orlando"
	message "Sigh... *mumble* %person{Rosalind} *mumble*..."

	speaker "Rosalind"
	message "Did you say something, %person{Orlando}?"

	speaker "Orlando"
	message {
		"Oh, um, yeah, good luck to both of you!",
		"Yeah, that's what I said..."
	}

	speaker "Rosalind"
	message "You're so kind! Thank you!"

	local mapScript = Utility.Peep.getMapScript(_TARGET)
	if mapScript then
		mapScript:makeRosalindFollowPlayer(_TARGET, false)
	end

	_TARGET:getState():give("KeyItem", "PreTutorial_ArriveAtTheWhalingTemple")
	_TARGET:removeBehavior(DisabledBehavior)
end
