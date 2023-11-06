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

	message "If you need any help, feel free to ask me!"
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
		"I'm busy making supper!",
		"Being short-staffed bites!"
	}
end

if Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_TurnedInCake", _TARGET) or
   Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_GotYelledAtForGoldenCarrot", _TARGET) or
   Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_GotPermissionForGoldenCarrot", _TARGET)
then
	local RECIPE = option "Where do I find the ingredients for the recipe?"
	local ALONE  = option "I'll leave you alone!"
	local result = select {
		RECIPE,
		ALONE
	}

	if result == RECIPE then
		speaker "_TARGET"
		message {
			"I'm lost!",
			"There's so many ingredients,",
			"where do I even start?"
		}

		speaker "ChefAllon"
		message "Well, let's see..."

		message {
			"%person{Old Girl} is the prized Rumbridge cow.",
			"She can be found in the %location{Rumbridge farms},",
			"east of %location{the castle} and north of %location{Leafy Lake}."
		}

		message {
			"You'll find dandies around the lake.",
			"Fresh %item{dandelion flour} is a must!"
		}

		message {
			"The %person{golden chicken} at the farm lays",
			"%item{golden eggs}, but she may be a troublesome one.",
			"There's a reason it's a prized kind of egg!"
		}

		message {
			"The %item{golden carrot} is the farmer's magnus opus.",
			"But convincing him should be easy!",
			"Everyone loves %person{the Earl}."
		}

		message {
			"Lastly, %item{vegetable oil} can be obtained from mining.",
			"%item{Brown sugars} are dropped by chocoroaches.",
			"And %item{royal pecans} can be %hint{foraged from pecan trees}."
		}

		speaker "_TARGET"
		message {
			"That's a lot!",
			"This better be worth it!"
		}

		speaker "ChefAllon"
		message "Trust me, the Earl will reward you handsomely!"
	elseif result == ALONE then
		return
	end
end
