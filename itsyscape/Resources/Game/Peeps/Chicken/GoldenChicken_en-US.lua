speaker "_TARGET"
message "I wonder what I should do..."

local KISS  = option "Kiss golden chicken"
local PET   = option "Pet golden chicken"
local TALK  = option "Talk to golden chicken"
local SCARE = option "Scare golden chicken"

local result = select {
	KISS,
	PET,
	TALK,
	SCARE
}

if result == KISS then
	message {
		"This is gonna be a bad idea...",
		"*kiss*"
	}

	local playerPeep = _SPEAKERS["_TARGET"]
	local playerActor = playerPeep:getBehavior("ActorReference")
	playerActor = playerActor and playerActor.actor
	if playerActor then
		local CacheRef = require "ItsyScape.Game.CacheRef"
		local animation = CacheRef(
			"ItsyScape.Graphics.AnimationResource",
			"Resources/Game/Animations/Human_ActionPet_1/Script.lua")

		playerActor:playAnimation('x-cutscene', 10, animation)
	end

	speaker "Chicken"
	message {
		"(What the cluck does this human think",
			Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_SUBJECT) ..
			" " ..
			Utility.Text.getEnglishBe(_TARGET).present ..
			" doing?)",
		"CLUCK!!!"
	}

	Utility.Peep.attack(_SPEAKERS["Chicken"], _TARGET, math.huge)
elseif result == PET then
	message {
		"I don't know about this...",
		"*pet*"
	}

	local playerPeep = _SPEAKERS["_TARGET"]
	local playerActor = playerPeep:getBehavior("ActorReference")
	playerActor = playerActor and playerActor.actor
	if playerActor then
		local CacheRef = require "ItsyScape.Game.CacheRef"
		local animation = CacheRef(
			"ItsyScape.Graphics.AnimationResource",
			"Resources/Game/Animations/Human_ActionPet_1/Script.lua")

		playerActor:playAnimation('x-cutscene', 10, animation)
	end

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
		player:pokeCamera('shake', 0.5)
	end

	speaker "Chicken"
	message "Cluck!!!"

	_SPEAKERS["Chicken"]:poke('dropEgg', "SuperSupperSaboteur_GoldenEgg")
end
