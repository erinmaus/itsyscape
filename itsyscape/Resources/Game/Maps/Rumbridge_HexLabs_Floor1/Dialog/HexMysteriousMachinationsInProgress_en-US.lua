local hasStartedQuest = _TARGET:getState():has("KeyItem", "MysteriousMachinations_Start")
local QUEST = Utility.Quest.build("MysteriousMachinations", _DIRECTOR:getGameDB())

if not hasStartedQuest then
	speaker "_TARGET"
	message {
		"Can I help you with anything?",
		"I'm always looking for a quest!"
	}

	speaker "Hex"
	message "You are exactly the person I need!"

	message {
		"I'm trying to uncover the secrets of Old One's tech!",
		"Before the Old Ones left a thousand years ago,",
		"Prisium, the Great Intelligence left behind hyper-dimensional tech."
	}

	message {
		"I want to build an %hint{Old One's Tesseract}...",
		"It's a computer, much like %person{Emily}...",
		"Only a bajillion times more advanced!"
	}

	message {
		"I have a suspicion a working %hint{Tesseract}",
		"can be found on %location{Azathoth},",
		"the Realm's shadowy mirror dimension."
	}

	message {
		"But %location{Azathoth} is dangerous and I'm not a fighter!",
		"So I need you to explore that dimension and report your findings."
	}

	Utility.Quest.promptToStart(
		"MysteriousMachinations",
		_TARGET,
		_SPEAKERS["Hex"])
elseif Utility.Quest.isNextStep(QUEST, "MysteriousMachinations_FindRuinsNearLeafyLake", _TARGET) then
	local state = _TARGET:getState()
	local flags = { ['item-inventory'] = true }
	local hasBattery = state:has("Item", "MysteriousMachinations_Battery", 1, flags)
	local hasPowerButton = state:has("Item", "MysteriousMachinations_PowerButton", 1, flags)

	if not hasBattery or not hasPowerButton then
		speaker "Hex"
		message {
			"Awesome! So there's some ruins near %location{Leafy Lake}.",
			"You should've passed by on your way here."
		}

		message {
			"I'll need you to install a %item{battery} and %item{power button}.",
			"If you need any help, well, figure it out! Bwahaha!",
			"Antilogika requires the right headspace!"
		}

		local gaveItems = true
		if not hasBattery then
			gaveItems = gaveItems and state:give("Item", "MysteriousMachinations_Battery", 1, flags)
		end

		if not hasPowerButton then
			gaveItems = gaveItems and state:give("Item", "MysteriousMachinations_PowerButton", 1, flags)
		end

		if not gaveItems then
			message "You need to make space for this stuff!"
		else
			message {
				"Here's the %item{battery} and %item{power button}.",
				"Report back what you find!"
			}
		end
	else
		speaker "Hex"

		message {
			"Head to %location{Leafy Lake}, just south of here.",
			"Install the %item{battery} and %item{power button} at the ruins,",
			"then report back your findings!"
		}

		message "I'm just soooOOOooo excited!"
	end
else
	speaker "Hex"
	message {
		"I can't help you right now.",
		"Maybe %hint{check your Nominomicon}?"
	}
end
