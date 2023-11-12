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

local function playCookingAnimation()
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
end

PLAYER_NAME = _TARGET:getName()

local map = Utility.Peep.getMapScript(_TARGET)
local isQuestCutscene = map:getArguments() and map:getArguments()["super_supper_saboteur"] ~= nil

local hasStartedQuest = _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_Started")
local QUEST = Utility.Quest.build("SuperSupperSaboteur", _DIRECTOR:getGameDB())

if not _TARGET:getState():has("Item", "SuperSupperSaboteur_SecretCarrotCakeRecipeCard", 1, SEARCH_FLAGS) and
   _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_GotRecipe")
then
	speaker "_TARGET"
	message "I'm a bit clumsy and lost your secret recipe card!"

	speaker "ChefAllon"
	if _TARGET:getState():give("Item", "SuperSupperSaboteur_SecretCarrotCakeRecipeCard", 1, GIVE_FLAGS) then
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
		"Lucky for me, %person{Orlando} is a renowned food critic,",
		"and guess what? He put in a good word for you!"
	}

	local ISABELLE = option "Even after the fiasco with Isabelle?"
	local WHO_KNEW = option "I didn't know that!"

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
elseif not _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_TurnedInCake") then
	playCookingAnimation()

	speaker "ChefAllon"
	message {
		"I'm busy making supper!",
		"Being short-staffed bites!"
	}
elseif isQuestCutscene and _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_ButlerInspected") then
	speaker "_TARGET"
	message "The butler - he's dead!"

	speaker "ChefAllon"
	message {
		"Not %person{Lear}!",
		"Aaah! That dog must be the killer!",
	}

	message "And like that, it's gone!"

	message {
		"Let's regroup in the kitchen after",
		"I alert the guards!"
	}
elseif Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_TalkedToGuardCaptain", _TARGET) then
	_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_TalkedToGuardCaptain")

	speaker "GuardCaptain"
	message {
		"We didn't find any clues...",
		"%person{Lear} didn't even sustain any injuries!",
		"Are you sure you saw a dog?"
	}

	speaker "ChefAllon"
	message {
		"Yes! There was a dog!",
		"I couldn't make out much details,",
		"just that it was bigger, almost like a wolf."
	}

	speaker "GuardCaptain"
	message {
		"That sounds like the witch %person{Lyra's} dog, %person{Oliver}.",
		"I'll pay her a visit."
	}

	local CAN_I_GO = option "Can I go instead?"
	local GODSPEED = option "Godspeed!"
	local result = select {
		CAN_I_GO,
		GODSPEED
	}

	if result == CAN_I_GO then
		speaker "_TARGET"
		message {
			"Can I go and check this out?",
			"%person{Chef Allon} gave me a quest",
			"and I want to complete it!"
		}

		speaker "ChefAllon"
		message {
			"I say give " .. Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_OBJECT) .. " a chance.",
			Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_SUBJECT, "en-US", true) .. " " .. Utility.Text.getEnglishBe(_TARGET).present .. " an up-and-coming adventure.",
		}
	elseif result == GODSPEED then
		speaker "_TARGET"
		message {
			"Godspeed! Hope you find the killer...!"
		}

		speaker "ChefAllon"
		message {
			"I say give %person{${PLAYER_NAME}} a chance.",
			Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_SUBJECT, "en-US", true) .. " " .. Utility.Text.getEnglishBe(_TARGET).present .. " an up-and-coming adventure.",
		}
	end

	speaker "GuardCaptain"
	message {
		"Very well.",
		"Report back any information you acquire, %person{${PLAYER_NAME}}.",
		"I'll have guards posted in the %location{Shade district}."
	}

	if result == CAN_I_GO then
		speaker "_TARGET"
		message "Thank you!"
	else
		speaker "_TARGET"
		message "Well, if you insist..."
	end
elseif isQuestCutscene and _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_ButlerDied") then
	speaker "_TARGET"
	message "Phew, I never knew it would be so hard to go and bake a cake!"

	speaker "ChefAllon"
	message {
		"Music to my ears!",
		"The Earl will be happy!"
	}

	local player = Utility.Peep.getPlayerModel(_TARGET)
	if player then
		player:pokeCamera('shake', 0.25)
	end

	speaker "ButlerLear"
	message "AAAH! WHAT IS THAT?!"

	speaker "Oliver"
	message "WOOF! *bark*"

	speaker "ChefAllon"
	message "%person{Lear}, are you alright?!"

	speaker "_TARGET"
	message "Let's check on him!"

	_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_ButlerInspected")
end

if Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_TurnedInCake", _TARGET) or
   Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_GotYelledAtForGoldenCarrot", _TARGET) or
   Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_GotPermissionForGoldenCarrot", _TARGET)
then
	if _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_GotYelledAtForGoldenCarrot") and
	   not _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_GotPermissionForGoldenCarrot")
   then
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

		speaker "ChefAllon"
		message "Anything else?"
	end

	local hasCarrotCake = _TARGET:getState():has("Item", "CarrotCake", 1, TAKE_FLAGS) and _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_GotPermissionForGoldenCarrot")

	local RECIPE = option "Where do I find the ingredients for the recipe?"
	local BAKE   = option "Where do I bake the cake?"
	local ALONE  = option "I'll leave you alone!"
	local CAKE   = option "(Hand in the carrot cake.)"
	local result = select {
		RECIPE,
		BAKE,
		ALONE,
		(hasCarrotCake and CAKE) or nil
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
	elseif result == BAKE then
		speaker "_TARGET"
		message {
			"How do I bake the cake?",
			"I've %hint{only cooked simple things like fish} so far!"
		}

		speaker "ChefAllon"
		message {
			"I might be gettin' a little technical,",
			"but %hint{you can use an ingredient on a range}",
			"or %hint{'right-click' on a range and select 'cook-fancy'}!"
		}

		speaker "_TARGET"
		message {
			"That sounds like non-sense!",
			"What does %hint{right-click} even mean?!"
		}
	elseif result == CAKE then
		speaker "_TARGET"
		message "I made the carrot cake!"

		speaker "ChefAllon"
		message "Let me take a look, friend!"

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

if Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_ButlerDied", _TARGET) or
   Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_ButlerInspected", _TARGET)
then
	if isQuestCutscene then
		_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_ButlerDied")

		Utility.UI.closeAll(_TARGET)

		local cutscene = Utility.Map.playCutscene(map, "Rumbridge_Castle_ButlerDies", "StandardCutscene", _TARGET)
		cutscene:listen('done', function()
			Utility.UI.openGroup(
				_TARGET,
				Utility.UI.Groups.WORLD)

			Utility.Peep.getTemporaryStorage(_TARGET):getSection("SuperSupperSaboteur"):set("performNamedAction", "StartSuperSupperSaboteur")

			local stage = _TARGET:getDirector():getGameInstance():getStage()
			stage:movePeep(_TARGET, "Rumbridge_Castle", Utility.Peep.getPosition(_TARGET))
		end)
	else
		_TARGET:getState():take("KeyItem", "SuperSupperSaboteur_ButlerDied")
		_TARGET:getState():take("KeyItem", "SuperSupperSaboteur_ButlerInspected")

		local stage = _TARGET:getDirector():getGameInstance():getStage()
		stage:movePeep(_TARGET, "Rumbridge_Castle?super_supper_saboteur=1", Utility.Peep.getPosition(_TARGET))
	end
end

local needToLightCandle = Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_LitBirthdayCandle", _TARGET)
if Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_TurnedInLyra", _TARGET) then
	speaker "ChefAllon"
	message {
		"%person{Earl Reddick} is probably better to talk about",
		"anything about your investigation.",
		"After all, I'm just a chef!"
	}
elseif needToLightCandle then
	local hasBirthdayCandle = _TARGET:getState():has("Item", "SuperSupperSaboteur_UnlitBirthdayCandle", 1, SEARCH_FLAGS) or
	                          _TARGET:getState():has("Item", "SuperSupperSaboteur_LitBirthdayCandle", 1, SEARCH_FLAGS)
	local hasLitBirthdayCandle = _TARGET:getState():has("Item", "SuperSupperSaboteur_LitBirthdayCandle", 1, SEARCH_FLAGS)
	local hasUnlitBirthdayCandle = _TARGET:getState():has("Item", "SuperSupperSaboteur_UnlitBirthdayCandle", 1, SEARCH_FLAGS)
	local hasLitBirthdayCandleInInventory = _TARGET:getState():has("Item", "SuperSupperSaboteur_LitBirthdayCandle", 1, TAKE_FLAGS)
	local hasLitKursedCandleInInventory = _TARGET:getState():has("Item", "LitKursedCandle", 1, TAKE_FLAGS)

	if hasLitBirthdayCandleInInventory then
		local BIRTHDAY = option "Hand over lit birthday candle."
		local KURSE    = option "Hand over lit kursed candle."
		local NOTHING  = option "Actually, let me think about my options."
		
		local result = select {
			BIRTHDAY,
			hasLitKursedCandleInInventory and KURSE or NOTHING
		}

		if result == KURSE then
			speaker "_TARGET"
			message "(Am I sure about that? The Earl will die...)"

			local YES = option "He deserves it! Hand over the kursed candle."
			local NO  = option "On second thoughts, I'll hand in the birthday candle."

			local otherResult = select { YES, NO }
			if otherResult == YES then
				result = KURSE
			else
				result = BIRTHDAY
			end
		end

		if result == BIRTHDAY then
			_TARGET:getState():take("Item", "SuperSupperSaboteur_LitBirthdayCandle", 1, TAKE_FLAGS)
			_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_LitBirthdayCandle")
		elseif result == KURSE then
			_TARGET:getState():take("Item", "LitKursedCandle", 1, TAKE_FLAGS)
			_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_LitKursedCandle")
		elseif result == NOTHING then
			return
		end

		speaker "_TARGET"
		message "Here's the birthday candle!"
	elseif hasBirthdayCandle then
		if hasLitBirthdayCandle then
			speaker "_TARGET"
			message {
				"(Wait, the lit birthday candle isn't on me!",
				"It be in my bank or something.)"
			}
		elseif hasUnlitBirthdayCandle then
			local hasTinderbox = _TARGET:getState():has("Item", "Tinderbox", 1, TAKE_FLAGS)

			if hasTinderbox then
				speaker "_TARGET"
				message "(Wait, I need to light the candle!)"
			else
				speaker "_TARGET"
				message "(Wait, I need to a tinderbox to light the candle!)"
			end
		else
			speaker "_TARGET"
			message {
				"(Wait, the unlit birthday candle isn't on me!",
				"It be in my bank or something.",
				"Lemme go grab it and then light it.)"
			}
		end
	else
		local gotCandle = _TARGET:getState():give("Item", "SuperSupperSaboteur_UnlitBirthdayCandle", 1, GIVE_FLAGS)

		if gotCandle then
			speaker "ChefAllon"
			message {
				"Here's the %item{birthday candle}!",
				"You'll need a %item{tinderbox} to light it.",
				"Unfortunately, I'm only skilled in cooking.",
				"Hand it over when you light it!"
			}
		else
			speaker "ChefAllon"
			message {
				"Make more room in your inventory",
				"for the %item{birthday candle}!"
			}
		end
	end
end

if Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_Complete", _TARGET) then
		speaker "ChefAllon"
		message {
			"Excellent! Let's do this!",
			"Time to celebrate the Earl's birthday!",
			"I'll get him!"
		}

		local stage = _TARGET:getDirector():getGameInstance():getStage()
		stage:movePeep(_TARGET, "Rumbridge_Castle?super_supper_saboteur=1", Utility.Peep.getPosition(_TARGET))
end

local isHelpingLyra =
	Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_TalkedToLyra", _TARGET) or
	Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_GotConfessionFromLyra", _TARGET) or
	Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_TalkedToCapnRaven", _TARGET) or
	Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_MadeCandle", _TARGET) or
	Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_GotContracts", _TARGET) or
	Utility.Quest.isNextStep(QUEST, "SuperSupperSaboteur_BlamedSomeoneElse", _TARGET)
if isHelpingLyra then
	speaker "ChefAllon"
	message {
		"I'm almost done! Just the finishing touches...",
		"I'll let you know when I need you!"
	}
end
