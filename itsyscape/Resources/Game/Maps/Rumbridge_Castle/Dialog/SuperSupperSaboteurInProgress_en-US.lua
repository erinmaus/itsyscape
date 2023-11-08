local SEARCH_FLAGS = {
	['item-equipment'] = true,
	['item-inventory'] = true,
	['item-bank'] = true
}

local TAKE_FLAGS = {
	['item-inventory'] = true
}

local GIVE_FLAGS = {
	['item-inventory'] = true
}

local INGREDIENTS = {
	"SuperSupperSaboteur_OldGirlsMilk",
	"SuperSupperSaboteur_OldGirlsButter",
	"SuperSupperSaboteur_DandelionFlour",
	"SuperSupperSaboteur_GoldenEgg",
	"VegetableOil",
	"DarkBrownSugar",
	"SuperSupperSaboteur_GoldenCarrot",
	"RegalPecan"
}

local INGREDIENT_MISSING_MESSAGES = {
	{
		"The milk is wrong!",
		"The secret ingredient is %item{Old Girl's milk}."
	},
	{
		"This is the wrong butter!",
		"You needed to use butter churned from",
		"%item{Old Girl's milk}."
	},
	{
		"This isn't %item{dandelion flour}!"
	},
	{
		"That's not the right egg!",
		"The only egg worthy of the Earl is the %item{golden egg}!"
	},
	{
		"Only %item{vegetable oil} gives the cake the right moistness!"
	},
	{
		"%item{Dark brown sugar} is a must!",
		"Whatever sugar you used is wrong!"
	},
	{
		"Chef Allon's golden carrot cake",
		"cannot live up to its name",
		"without the %item{golden carrot}!"
	},
	{
		"Although other pecans might be easier to get,",
		"or maybe you tried some creative direction,",
		"only %item{regal pecans} complement the flavor profile!"
	}
}

local map = Utility.Peep.getMapScript(_TARGET)
local isQuestCutscene = map:getArguments() and map:getArguments()["super_supper_saboteur"]

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
elseif not _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_TurnedInCake") then
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
	local CAKE   = option "(Hand in the carrot cake.)"
	print(_TARGET:getState():has("Item", "CarrotCake", 1, TAKE_FLAGS))
	local result = select {
		RECIPE,
		ALONE,
		(_TARGET:getState():has("Item", "CarrotCake", 1, TAKE_FLAGS) and CAKE) or nil
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
	elseif result == CAKE then
		speaker "_TARGET"
		message "I made the carrot cake!"

		speaker "ChefAllon"
		message "Excellent, friend! Let me take a look..."

		local carrotCakes = Utility.Item.getItemsInPeepInventory(_TARGET, "CarrotCake")

		local foundCarrotCake
		for _, carrotCakeItem in ipairs(carrotCakes) do
			local userdata = carrotCakeItem:getUserdata("ItemIngredientsUserdata")
			if userdata then
				local hasAllIngredients = true
				for _, ingredient in ipairs(INGREDIENTS) do
					if not userdata:hasIngredient(ingredient) then
						hasAllIngredients = false
						break
					end
				end

				if hasAllIngredients then
					foundCarrotCake = carrotCakeItem
					break
				end
			end
		end

		if foundCarrotCake then
			message "Excellent, you followed the recipe exactly!"

			local tookItem = _TARGET:getState():take("Item", "CarrotCake", 1, { ['item-inventory'] = true, ['item-instances'] = { foundCarrotCake } })
			if not tookItem then
				Log.warn("Chef Allon ouldn't take carrot cake from player '%s'.", _TARGET:getName())
				message "Let's try that again."
			else
				_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_TurnedInCake")
			end
		else
			if #carrotCakes > 1 then
				message {
					"I only needed one cake! But...",
					"They're all wrong!",
					"Let's see what was wrong with the first cake..."
				}
			end

			local firstCarrotCake = carrotCakes[1]

			local userdata = firstCarrotCake:getUserdata("ItemIngredientsUserdata")
			if not userdata then
				message "None of the ingredients were right!"
			else
				for i = 1, #INGREDIENTS do
					if userdata:hasIngredient(INGREDIENTS[i]) then
						message(INGREDIENT_MISSING_MESSAGES[i])
					end
				end
			end
		end
	elseif result == ALONE then
		return
	end
end

if Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_ButlerDied", _TARGET) then
	if isQuestCutscene then
		Utility.UI.closeAll(_TARGET)

		local cutscene = Utility.Map.playCutscene(map, "Rumbridge_Castle_ButlerDies", "StandardCutscene", _TARGET)
		cutscene:listen('done', function()
			Utility.UI.openGroup(
				_TARGET,
				Utility.UI.Groups.WORLD)
		end)
	else
		local stage = _TARGET:getDirector():getGameInstance():getStage()
		stage:movePeep(_TARGET, "Rumbridge_Castle?super_supper_saboteur=1", Utility.Peep.getPosition(_TARGET))
	end
end
