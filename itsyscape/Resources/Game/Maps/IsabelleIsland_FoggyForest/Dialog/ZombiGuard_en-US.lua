speaker "Zombi"

message "Ugggggggh."

do
	local INFO = option "What's with that tree?"
	local QUIT = option "You're creepy."

	local result
	while result ~= QUIT do
		result = select {
			INFO,
			QUIT
		}

		if result == INFO then
			message {
				"That's the ancient driftwood.",
				"Used t'be the oldest oak tree in the Realm.",
				"But %empty{The Empty King} kursed it."
			}

			message {
				"You gotta use a %item{copper hatchet} t'cut it down.",
				"That's all I know. I don't have a big brain."
			}

			speaker "_TARGET"

			message "Do you have any brains?"

			speaker "Zombi"

			message {
				"Brains, where? Mmmmm.",
				"You're making me hungry."
			}

			message {
				"If you gimme brains,",
				"I can give you a %item{copper hatchet}...",
				"Y'know other zombi sometimes have open minds."
			}

			local FLAGS = {
				['item-inventory'] = true
			}

			if _TARGET:getState():has("Item", "ZombiBrains", 1, FLAGS) then
				local YES = option "Sure, take these brains."
				local NO  = option "No, these brains are mine!"

				local brainResult = select {
					YES,
					NO
				}

				if brainResult == YES then
					_TARGET:getState():take("Item", "ZombiBrains", 1, FLAGS)
					_TARGET:getState():give("Item", "CopperHatchet", 1, FLAGS)
					message "There ya go."
				else
					message "Brains..."
				end
			end
		elseif result == QUIT then
			speaker "_TARGET"
			message "I'm outta here, you're creepy!"

			speaker "Zombi"
			message {
				"That'd hurt if I had a heart.",
				"But %person{Brandon} ate mine."
			}
		end
	end
end
