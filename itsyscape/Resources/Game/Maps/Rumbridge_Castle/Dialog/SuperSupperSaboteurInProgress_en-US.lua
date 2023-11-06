local SEARCH_FLAGS = {
	['item-equipment'] = true,
	['item-inventory'] = true,
	['item-bank'] = true
}

local GIVE_FLAGS = {
	['item-inventory'] = true
}

local hasStartedQuest = _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_Started")
local QUEST = Utility.Quest.build("SuperSupperSaboteur", _DIRECTOR:getGameDB())

if not _TARGET:getState():has("Item", "SuperSupperSaboteur_SecretCarrotCakeRecipeCard", 1, SEARCH_FLAGS) and
   _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_GotRecipe")
then
	speaker "_TARGET"
	message "I'm a bit clumsy and lost your secret recipe card!"

	if _TARGET:getState():give("Item", "SuperSupperSaboteur_SecretCarrotCakeRecipeCard", 1, GIVE_FLAGS) then
		speaker "ChefAllon"

		message {
			"I knew this would happen!",
			"Here's a copy I made!"
		}

		message {
			"If you haven't started already,",
			"I'd suggest finding the golden carrot!",
			"The Rumbridge farmers have been growing one."
		}
	else
		message {
			"I knew this would happen!",
			"But to give you another, you'll have to make room",
			"in your inventory - it's full!"
		}
	end
end

if not hasStartedQuest then
	speaker "_TARGET"
	message "Need a hand?"

	local hasCompletedCalmBeforeTheStorm = _TARGET:getState():has("Quest", "CalmBeforeTheStorm")
	if not hasCompletedCalmBeforeTheStorm then
		speaker "ChefAllon"
		message {
			"You may be an adventurer,",
			"but that doesn't mean you're a chef.",
			"Maybe work on your reputation first."
		}

		return
	end

	speaker "ChefAllon"
	message {
		"Well! I'm prepping dinner for %person{Earl Reddick's} birthday,",
		"but being short-staffed I have no time",
		"to prepare his favorite dessert: carrot cake!"
	}

	speaker "ChefAllon"
	message {
		"Lucky for me, %person{Orlando} is a renown food critic,",
		"and guess what? He put in a good word for you!"
	}

	local ISABELLE = "Even after the fiasco with Isabelle?"
	local WHO_KNEW = "I didn't know that!"

	local result = select {
		ISABELLE,
		WHO_KNEW
	}

	if result == ISABELLE then
		speaker "_TARGET"
		message {
			"Even after the fiasco with %person{Isabelle}?"
		}

		speaker "ChefAllon"
		message {
			"%person{Isabelle}, shmi-sabelle.",
			"Food critics are who I care about,",
			"not a pretentious merchant with more money than sense."
		}
	elseif result == WHO_KNEW then
		speaker "_TARGET"
		message "I didn't know %person{Orlando} did that!"

		speaker "ChefAllon"
		message {
			"Apparently, you cooked the best sardine %person{Orlando}",
			"has ever had, and boy is the guy picky!"
		}
	end

	message {
		"So! I can prepare the dinner!",
		"But I need you to gather the finest ingredients",
		"to make the best carrot cake in the Realm!"
	}

	Utility.Quest.promptToStart(
		"SuperSupperSaboteur",
		_TARGET,
		_SPEAKERS["ChefAllon"])
elseif Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_GotRecipe", _TARGET) then
	speaker "_TARGET"
	message {
		"I'd be more than happy to help!",
		"Can't resist a good quest!"
	}

	speaker "ChefAllon"
	message {
		"That's wonderful to hear!",
		"Who knows? Maybe you're destined to be a rising cooking hero!"
	}

	if _TARGET:getState():give("Item", "SuperSupperSaboteur_SecretCarrotCakeRecipeCard", 1, GIVE_FLAGS) then
		_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_GotRecipe")

		message {
			"Anyway, let's see... %hint{Here's my secret recipe card!}",
			"If you lose it was adventurers are wont to do,",
			"then I can make you another - but I won't be happy about it!"
		}

		message "I'd suggest starting with the golden carrot!"
	else
		message {
			"You need to make room in your inventory",
			"for %hint{my secret recipe card}!",
			"There's a handy bank chest in the %location{castle basement}.",
			"%hint{Use the ladder in the south closet to get down there!}"
		}
	end
elseif _TARGET:getState():has("SuperSupperSaboteur_GotYelledAtForGoldenCarrot") then
	speaker "_TARGET"
	message {
		"The golden carrot farmer won't let me",
		"pick his prized carrot!"
	}

	speaker "ChefAllon"
	message {
		"Just tell him it's for the Earl's birthday!",
		"Everyone in Rumbridge loves the Earl,",
		"so he'll be happy to oblige!"
	}
else
	local allonPeep = _SPEAKERS["ChefAllon"]
	local allonActor = allonPeep:getBehavior("ActorReference")
	allonActor = allonActor and allonActor.actor
	if allonActor then
		local CacheRef = require "ItsyScape.Game.CacheRef"
		local animation = CacheRef(
			"ItsyScape.Graphics.AnimationResource",
			"Resources/Game/Animations/Human_ActionCook_1/Script.lua")

		allonActor:playAnimation('x-cutscene', 10, animation)
	end

	speaker "ChefAllon"
	message {
		"Sorry, I'm too busy making supper!",
		"How about you check your %hint{Nominomicon}",
		"if you need help? It's a handy book!"
	}
end
