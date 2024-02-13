PLAYER_NAME = _TARGET:getName()

if Utility.Quest.isNextStep("PreTutorial", "PreTutorial_Start", _TARGET) then
	speaker "CapnRaven"

	message { 
		"Avast, %person{Jenkins}!",
		"We know yer that merchant's portmaster!",
		"Give us yer %item{loot} and ye can sail another day."
	}

	speaker "Jenkins"

	message {
		"How could ye do this?",
		"We use'd t'be mates, %person{Cap'n Raven}!"
	}

	speaker "CapnRaven"

	message "That t'was before ye threw off yer hat."
	message "Now give us yer valuables and out of the little respect I still have fer ye, I'll let ye live."

	speaker "Orlando"
	message "No! You won't have any of my lil sis's loot!"

	speaker "Rosalind"
	message "You'll have to get through us first!"

	speaker "CapnRaven"
	message {
		"A young witch and a cowardly warrior?",
		"Har har har! Sea bass be scarier then ye!"
	}

	speaker "Rosalind"
	message "%person{Cap'n Raven}, you'll swallow your words!"

	speaker "CapnRaven"
	message "We be seein' about that, landlubber!"

	speaker "Jenkins"
	message {
		"%person{${PLAYER_NAME}}, man the cannons!",
		"%person{Orlando} and %person{Rosalind}, kill any pirates!",
		"Rest of ye, don't get in the way!"
	}
end
