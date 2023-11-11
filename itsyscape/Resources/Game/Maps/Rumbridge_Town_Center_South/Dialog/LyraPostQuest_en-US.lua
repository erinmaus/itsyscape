local isEarlAlive = _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_LitBirthdayCandle")

if isEarlAlive then
	speaker "Lyra"
	message {
		"You don't have the %hint{iron will} needed",
		"to save the world, you fool."
	}

	speaker "_TARGET"
	message "I just couldn't kill him!"

	speaker "Lyra"
	message {
		"I have other plans.",
		"This mysterious society threatens my %empty{Lord}!",
		"Who knows what they're capable of!"
	}

	speaker "_TARGET"
	message "Maybe there's another solution."

	speaker "Oliver"
	message "Woof!"

	speaker "Lyra"
	message {
		"It seems %person{Oliver} agrees with you.",
		"Maybe we will work together in the future.",
		"But heed me now - if I must end you, I will",
		"not hesitate."
	}
else
	speaker "Lyra"
	message {
		"Between you ruining %person{Isabelle's} plans,",
		"and us ruining %person{Earl Reddick's}, we're",
		"two steps ahead of the mysterious society they",
		"both were in contact with."
	}

	speaker "_TARGET"
	message {
		"Do you know anything about these people?",
		"Even though they're mysterious'n'all?"
	}

	speaker "Lyra"
	message {
		"No, they're a slippery bunch.",
		"%hint{Even divination with Antilogika}",
		"%hint{fails to provide info of much use.}",
	}

	message {
		"All I know is they are out for %empty{The Empty King},",
		"and as a member of witch society,",
		"I must not let that stand."
	}

	message {
		"But heed my warning...",
		"We have definitely made enemies of them.",
		"The whispers in the winds say as much."
	}

	speaker "Oliver"
	message "*wimper*"
end
