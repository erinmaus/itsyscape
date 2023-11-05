local hasStartedQuest = _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_Started")

if not hasStartedQuest then
	speaker "_TARGET"
	message "Is there any way I can help?"

	local hasCompletedCalmBeforeTheStorm = _TARGET:getState():has("Quest", "CalmBeforeTheStorm")
	if not hasCompletedCalmBeforeTheStorm then
		speaker "ChefAllon"
		message {
			"You may be an adventurer,",
			"but that doesn't mean you're a chef.",
			"Maybe work on your reputation first."
		}

		return
	end

	speaker "ChefAllon"
	message {
		"Well! %person{Advisor Grimm} is a renown food critic,",
		"and guess what? He put in a good word for you!"
	}

	message {
		"I can prepare the dinner,",
		"but you can help with the dessert.",
		"I need you to bake me a carrot cake."
	}

	message {
		"But not just any carrot cake!",
		"Only the finest ingredients will do."
	}

	Utility.Quest.promptToStart(
		"SuperSupperSaboteur",
		_TARGET,
		_SPEAKERS["ChefAllon"])
else
	speaker "_TARGET"
	message "Sure, I'm a passable chef!"

	speaker "ChefAllon"
	message "Amaze balls!"
end
