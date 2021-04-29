speaker "Isabelle"

PLAYER_NAME = _TARGET:getName()
message {
	"Welcome to %location{Isabelle Island}, %person{${PLAYER_NAME}}!",
	"I'm your host and merchant extraordinaire... %person{Isabelle}!"
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
			"I bought this island from %person{Vizier-King Yohn}.",
			"I wanted some peace and quiet from the city.",
			"Also, perhaps,this would be a good entrepreneurial endeavor.",
		}

		message {
			"Not to mention %location{Isabelle Island} is the last safe port",
			"between the %location{mainland} and the %location{Undead Sea}.",
			"As you found out firsthand, there are some of %person{Yendor's} horrors about further south."
		}

		message "However..."

		speaker "_TARGET"
		message "There's always that 'however'..."

		speaker "Isabelle"
		message "You're an adventurer, you know that!"

		message {
			"The stories were true: %hint{the island is cursed}.",
			"A thousand years ago %empty{some necromancer god}",
			"sought to slay the gods and lay ruin to the world."
		}

		message {
			"%empty{They} stirred %person{Yendor's servants}.",
			"Since then, no one has been able to put these angry undead to rest."
		}

		message {
			"I have resources and will %hint{handsomely reward} anyone who can help me bring fortune to this island."
		}

		do
			speaker "_TARGET"

			message "Well that's a lot to think about."
			message "Why couldn't it just be an infestation of bunnies?"

			speaker "Isabelle"
			message "Haha! Why couldn't it be?"
		end
	elseif result == HELP then
		message {
			"I'm glad you asked!",
			"I could use an adventurer such as yourself",
			"to put these enraged undead to rest."
		}

		message {
			"My advisor discovered three artefacts.",
			"A rotten %item{squid's skull}...",
			"...some %item{kursed ore}...",
			"...and %item{splinters} from an ancient driftwood tree."
		}

		message {
			"You're free to %hint{keep all treasures} you find.",
			"I just need these artefacts.",
			"I will also %hint{reward you with gold and fine resources}."
		}

		message "Are you willing to help me, %person{${PLAYER_NAME}}?"

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

			_TARGET:getState():give("Item", "Coins", 1000, {
				['item-bank'] = true
			})

			defer "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/IsabellePostStart_en-US.lua"

			break
		else
			message "I didn't hear you."
			Log.warn("Couldn't start quest 'Calm Before the Storm.'")
		end
	elseif result == QUIT then
		message "How rude! You better show some respect."
		message {
			"I won't let you leave this room",
			"until you clean up your act."
		}
	end
end
