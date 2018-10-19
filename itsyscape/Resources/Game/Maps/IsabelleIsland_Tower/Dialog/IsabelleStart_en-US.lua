speaker "Isabelle"

PLAYER_NAME = _TARGET:getName()
message {
	"Welcome to Isabelle Island, ${PLAYER_NAME}!",
	"I'm your host and friendly merchant extraordinaire, Isabelle."
}

local INFO = option "Can you tell me about this place?"
local HELP = option "Do you need help?"
local QUIT = option "Smell you later!"

local result
while result ~= QUIT do
	result = select {
		INFO,
		HELP,
		QUIT
	}

	if result == INFO then
		message {
			"I bought this island from Vizier-King Yohn.",
			"I wanted some peace and quiet from the city, and also thought this would be a good entrepreneurial endeavor.",
		}

		message {
			"It's just off the coast of Rumbridge, and used to be a place for weary sailors to ease their bodies and minds."
		}

		message "However..."

		do
			speaker "_TARGET"
			message "There's always that 'however'..."

			speaker "Isabelle"
			message "You're an adventurer, you know that!"
		end

		message {
			"The stories were true: the island is cursed.",
			"A hundred years ago some powerful necromancer came to the island.",
			"Rumors say they sought to live forever."
		}

		message {
			"They brought ruin to the island, and since then no one has been able to rid the island of their undead servants."
		}

		message {
			"I have resources and will handsomely reward anyone who can help me bring fortune to this island."
		}

		do
			speaker "_TARGET"

			message "Well that's a lot to think about."
			message "Why couldn't it just be an infestation of bunnies?"

			speaker "Isabelle"
			message "Haha! Why couldn't it be?"
		end
	elseif result == HELP then
		message "I'm glad you asked!"

		message {
			"I could use an adventurer such as yourself to claim the island.",
			"For Vizier-King Yohn, of course, but also for me."
		}

		message {
			"I've done years of research and need to eradicate sources of necromanic energy. Specifically...",
			"Some cursed ore...",
			"...the remains of an ancient driftwood tree...",
			"...and a rotten squid's skull."
		}

		message {
			"You're free to keep all valuable treasures you find, except for those few I need.",
			"And I'll give you a hefty amount of gold should you succeed."
		}

		message "Are you willing to help me, ${PLAYER_NAME}?"

		speaker "_TARGET"
		do
			message "Enticing..."

			local YES = option "Yes!"
			local DEFINTELY = option "Definitely!"
			local ABSOLUTELY = option "Absolutely!"

			local option = select {
				YES,
				DEFINTELY,
				ABSOLUTELY
			}

			if option == YES then
				message "I'd love to help!"
			elseif option == DEFINTELY then
				message "I'd definitely love to help!"
			elseif option == ABSOLUTELY then
				message "I'd absolutely love to help!"
			end
		end

		speaker "Isabelle"
		if _TARGET:getState():give("KeyItem", "CalmBeforeTheStorm_Start") then
			message "Excellent!"

			defer "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/IsabellePostStart_en-US.lua"

			break
		else
			message "I didn't hear you."
			Log.warn("Couldn't start quest 'Calm Before the Storm.'")
		end
	elseif result == QUIT then
		message "How rude! You better show some respect."
		message "I won't let you leave this room until you clean up your act."
	end
end
