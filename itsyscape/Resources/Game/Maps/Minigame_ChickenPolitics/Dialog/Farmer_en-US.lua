speaker "Farmer"

TARGET_NAME = _TARGET:getName()

local mapScript = Utility.Peep.getMapScript(_TARGET)
if mapScript.hasStarted and not mapScript.isDone then
	message "Tackle 'em chickens, %person{${TARGET_NAME}}!"
	return
else
	message "Ello, %person{${TARGET_NAME}}."
end

if not mapScript.isDone then
	local INFO        = option "Where am I?"
	local WHAT_DO     = option "What do I need to do to get out of here?"
	local PLAY        = option "Let's get started!"
	local LOOK_AROUND = option "I'm gonna look around first!"

	local result
	repeat
		result = select {
			INFO,
			WHAT_DO,
			PLAY,
			LOOK_AROUND
		}

		if result == INFO then
			message {
				"This is a crazy ol' chicken farm and the chickens have gotten a little political.",
				"See, they've split into the Pirates and the Navy factions, and we need to stop 'em."
			}

			speaker "_TARGET"
			message {
				"That's sounds crazy! Why would they do that?"
			}

			speaker "Farmer"
			message {
				"Ain't got a clue, friend.",
				"If you help us out,",
				"there's good rewards in it for ya..."
			}
		elseif result == WHAT_DO then
			message {
				"So ya see, ya need to tackle 'em chickens.",
				"So I'm about to bre'k the f'rth wall 'ere...",
			}

			message {
				"Hold the %hint{minigame dash button} to charge ya tackle.",
				"The longer you prep your tackle,",
				"the more powerful it'll be.",
				"%hint{By default, space is the dash button.}"
			}

			message {
				"The direction ya are movin' in will be",
				"the direction ya tackle the chickens from.",
				"%hint{Walking freely used keyboard is better.}"
			}

			speaker "_TARGET"
			message {
				"Got it!",
				"Hold the dash button to tackle the chickens...",
				"And I'll tackle them in the direction I'm moving!"
			}

			speaker "Farmer"
			message {
				"Yeah, that's 'ight, friend!",
				"Tackle as many chickens in o' minute as possible.",
				"An 'en ya good to go.",
			}

			message {
				"Ya'll get XP based on ya're weapon and stance,",
				" plus I'll give you some coins",
				"and other goodies for ya time."
			}
		elseif result == PLAY then
			defer "Resources/Game/Maps/Minigame_ChickenPolitics/Dialog/FarmerStart_en-US.lua"
			
			return
		elseif result == LOOK_AROUND then
			speaker "_TARGET"
			message "I'm gonna look around first!"

			speaker "Farmer"
			message {
				"Feel free.",
				"Come back 'ere when ya ready to help."
			}
		end
	until result == LOOK_AROUND
else
	message {
		"Thank ya for knockin' some",
		"sense into 'em chickens."
	}

	message {
		"Ya rewards are in the chest.",
		"Grab 'em or not, it's ya choice."
	}

	local RETURN_HOME = option "Ask to leave"
	local OOOOOH_LOOT = option "Check out the loot"

	local result = select {
		RETURN_HOME,
		OOOOOH_LOOT
	}

	if result == RETURN_HOME then
		message "Be seeing ya!"

		local stage = _TARGET:getDirector():getGameInstance():getStage()
		stage:movePeep(
			_TARGET,
			"IsabelleIsland_Tower",
			"Anchor_Clucker")
		return
	elseif result == OOOOOH_LOOT then
		message "Thank ya again! Be seein' me if ya wanna leave."
	end
end
