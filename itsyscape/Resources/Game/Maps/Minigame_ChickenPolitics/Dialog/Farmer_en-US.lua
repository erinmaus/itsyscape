speaker "Farmer"

TARGET_NAME = _TARGET:getName()

local mapScript = Utility.Peep.getMapScript(_TARGET)
if mapScript.hasStarted then
	message "Tackle 'em chickens, %person{${TARGET_NAME}}!"
	return
else
	message "Ello, %person{${TARGET_NAME}}."
end

do
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
				"If you help us out, there's good rewards in it for ya..."
			}
		elseif result == WHAT_DO then
			message {
				"So ya see, ya need to tackle 'em chickens. So I'm about to bre'k the f'rth wall 'ere...",
				"Hold the %hint{dash button (normally the SPACE key)}, to charge ya tackle.",
				"The longer you prep your tackle, the more powerful it'll be. But the longer ya'll be looking like a loon.",
				"The direction ya are movin' in will be the direction ya tackle the chickens from."
			}

			speaker "_TARGET"
			message {
				"Got it! So I've got to %hint{hold the dash button, normally the SPACE key, to tackle the chickens}.",
				"And I'll tackle them %hint{in the direction I'm moving}."
			}

			speaker "Farmer"
			message {
				"Yeah, that's 'ight, friend!",
				"Tackle as many chickens in a couple o' minutes as possible an ya good to go.",
				"Ya'll get combat XP based on ya're weapon and stance, plus I'll give you some coins and other goodies for ya time."
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
end
