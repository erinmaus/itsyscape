PLAYER_NAME = _TARGET:getName()
speaker "ChefAllon"
message "Welcome to my three-star kitchen, %person{${PLAYER_NAME}}!"

local hasStartedQuest = _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_Started")
local hasCompletedQuest = _TARGET:getState():has("Quest", "SuperSupperSaboteur")

local WHO     = option "Who are you?"
local COOK    = option "What's cooking?"
local QUEST
do
	if hasStartedQuest then
		QUEST = option "Let's talk about Super Supper Saboteur."
	else
		QUEST = option "Need a hand?"
	end
end
local NVM     = option "It's too hot in here!"

local result
repeat
	if hasCompletedQuest then
		result = select {
			WHO,
			COOK,
			NVM
		}
	else
		result = select {
			WHO,
			COOK,
			QUEST,
			NVM
		}
	end

	if result == WHO then
		speaker "ChefAllon"
		message {
			"I'm one of the bestest chefs in the Realm!",
			"Critics may try, but they never have a single",
			"complaint about my food."
		}

		message {
			"The great %person{Earl Reddick} gives me the freedom",
			"to explore the culinary world without limitations!",
			"He's fond of food and is far from a picky eater."
		}
	elseif result == COOK then
		speaker "ChefAllon"
		message {
			"Currently, I'm prepping %person{Earl Reddick}'s dinner.",
			"But I've heard whispers of an assassin",
			"planning to kill him and in turn frame me!"
		}

		speaker "_TARGET"
		message "Wow! Are you sure?"

		speaker "ChefAllon"
		message {
			"Secrets don't stay secret",
			"on the lips of drunk pirates.",
			"Rumors spread like wildfire in the port."
		}
	elseif result == QUEST then
		defer "Resources/Game/Maps/Rumbridge_Castle/Dialog/SuperSupperSaboteurInProgress_en-US.lua"
	elseif result == NVM then
		speaker "_TARGET"
		message "It's too hot in here!"

		speaker "ChefAllon"
		message {
			"Well, you know what they say!",
			"If it's too hot the kitchen..."
		}
	end
until result == NVM
