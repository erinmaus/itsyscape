speaker "_TARGET"
message "I wonder what I should do..."

local KISS  = option "Kiss golden chicken"
local HUG   = option "Hug golden chicken"
local TALK  = option "Talk to golden chicken"
local SCARE = option "Scare golden chicken"

local result = select {
	KISS,
	HUG,
	TALK,
	SCARE
}

if result == KISS then
	message {
		"This is gonna be a bad idea...",
		"*kiss*"
	}

	Utility.Peep.attack(_SPEAKERS["Chicken"], _TARGET, math.huge)
elseif result == HUG then
	message {
		"I don't know about this...",
		"*hug*"
	}

	speaker "Chicken"
	message { "CLUCK!", "CLUCK!", "CLUCK!!" }

	Utility.Peep.attack(_SPEAKERS["Chicken"], _TARGET, math.huge)
elseif result == TALK then
	message {
		"Hello, golden chicken!",
		"Do you wanna give me an egg?"
	}

	speaker "Chicken"
	message "Cluck."

	_SPEAKERS["Chicken"]:poke('dropEgg', "Egg")
elseif result == SCARE then
	message "BOO!"

	local player = Utility.Peep.getPlayerModel(_TARGET)
	if player then
		player:pokeCamera('shake')
	end

	speaker "Chicken"
	message "Cluck!!!"

	_SPEAKERS["Chicken"]:poke('dropEgg', "SuperSupperSaboteur_GoldenEgg")
end
