speaker "Orlando"

PLAYER_NAME = _TARGET:getName()
message {
	"'Ey, %person{${PLAYER_NAME}}!",
	"I'm %person{Isabelle's} big bro, %person{Orlando}."
}

local killedIsabelle = _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_IsabelleDefeated")

if killedIsabelle then
	message {
		"Sorry 'bout my sis being so loony.",
		"Ever since she got that amulet,",
		"she's been a bit strange, y'know?"
	}
end

local gaveFish = _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_GaveOrlandoFish")

local INFO   = option "What are you doing?"
local ACCESS = option "Can you let me into the mines?"
local KEY    = option "Can I have another wrought iron key?"
local QUIT   = option "Smell ya later!"

local result
while result ~= QUIT do
	if gaveFish then
		result = select {
			INFO,
			KEY,
			QUIT
		}
	else
		result = select {
			INFO,
			ACCESS,
			QUIT
		}
	end

	if result == INFO then
		speaker "Orlando"

		message {
			"I was %person{Isabelle's} first choice to protect the island...",
			"But I'm %hint{too in love} with %person{Rosalind} to risk my life!",
			"Oh %person{Rosalind}, how my heart burns for you!"
		}

		message {
			"So my lil sis got you to do her bidding!",
			"Not that I'm complaining...!",
			"Getting to live to woo %person{Rosalind} is great for me!"
		}

		speaker "_TARGET"
		message {
			"Wow, you're pretty lame."
		}

		speaker "Orlando"
		message {
			"If love is lame, I'd be lame any day!"
		}
	elseif result == ACCESS then
		speaker "Orlando"

		local FLAGS = { ['item-inventory'] = true }
		local hasFish = _TARGET:getState():has("Item", "CookedSardine", 1, FLAGS)
		if hasFish and _TARGET:getState():take("Item", "CookedSardine", 1, FLAGS) then
			message {
				"A cooked sardine, my favorite!",
				"Thank you."
			}

			if _TARGET:getState():give("Item", "IsabelleIsland_AbandonedMine_WroughtBronzeKey", 1, FLAGS) and
			   _TARGET:getState():give("KeyItem", "CalmBeforeTheStorm_GaveOrlandoFish")
			then
				gaveFish = true

				message {
					"Here you go, a %item{wrought bronze key}.",
					"Now you can access %location{the mines}!",
					"Close the door behind yourself to prevent any creeps from escaping."
				}

				message {
					"Make sure you have some food for yourself!",
					"The creeps are tough!",
					"I'll help you out when I can. But...!",
					"Don't think I'm gonna risk my neck for you!"
				}
			else
				message {
					"I'm still hungry; bring me another!"
				}

				Log.warn("Failed to give Orlando fish.")
			end
		else
			message {
				"Yes...! But you must bring me my favorite food!",
				"I demand a cooked %item{sardine}.",
				"Standing around with my head in the clouds...",
				"It's hungry work!"
			}

			speaker "_TARGET"

			message {
				"This better not be a fetch quest!"
			}

			speaker "Orlando"

			message {
				"Haha, it's easy! My sis gave you a small allowance.",
				"Head north, towards %location{the port}. Buy a %item{fishing rod} and catch a %item{sardine} in the ocean.",
				"Cook it on a fire and bring it to me."
			}

			message {
				"Alternatively, I heard %hint{slaying squids can give lots of fish}. %person{Jenkins} knows more."
			}
		end
	elseif result == KEY then
		local GIVE_FLAGS = { ['item-inventory'] = true }
		local SEARCH_FLAGS = {
			['item-equipment'] = true,
			['item-inventory'] = true,
			['item-bank'] = true
		}

		speaker "Orlando"
		if not _TARGET:getState():has("Item", "IsabelleIsland_AbandonedMine_WroughtBronzeKey", 1, SEARCH_FLAGS) then
			if _TARGET:getState():give("Item", "IsabelleIsland_AbandonedMine_WroughtBronzeKey", 1, GIVE_FLAGS) then
				message { 
					"Here you go!"
				}
			else
				message {
					"Seems you don't have enough room in your inventory.",
					"Clean out some garbage and come back."
				}
			end
		else
			message {
				"You already have one.",
				"If it's not in your bag, maybe it's in your bank.",
				"There's a banker in %location{the tower},",
				"if you don't remember."
			}
		end
	end
end

speaker "Orlando"
message {
	"Good sense of humor, %person{${PLAYER_NAME}}!",
	"Now if only %person{Rosalind} would appreciate my jokes... Ahh..."
}
