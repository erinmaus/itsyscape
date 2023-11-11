local TICK_DEMONS_ENTRY  = 1
local TICK_DEMONS_ATTACK = 2
local TICK_EARL_DIE      = 3
local TICK_DEMONS_DIE    = 4
local TICK_PLAYER        = 5

local map = Utility.Peep.getMapScript(_TARGET)
local isQuestCutscene = map:getArguments() and map:getArguments()["super_supper_saboteur"] ~= nil

if not isQuestCutscene then
	return
end

if Utility.Quest.isNextStep("SuperSupperSaboteur", "SuperSupperSaboteur_BlamedSomeoneElse", _TARGET) then
	local tick = map:incrementSuperSupperSaboteurDialogTick()

	if tick == TICK_DEMONS_ENTRY then
		speaker "EarlReddick"
		message {
			"It's the assassins!",
			"The whispers were true!",
			"And on my birthday of all days?!"
		}

		speaker "Demon"
		message "Hisssss! You scum! You Bastiliean!"

		speaker "Hellhound"
		message "ROAR! BARK!"

		speaker "Guard1"
		message "We'll save you, liege!"

		speaker "Guard2"
		message "Yeah, you heard 'em!"
	elseif tick == TICK_DEMONS_ATTACK then
		speaker "Guard1"
		message "Get away from him!"

		speaker "Hellhound"
		message "ROAR!!!"

		speaker "Demon"
		message "Hisssss! You mortals can't tell us what to do!"
	elseif tick == TICK_EARL_DIE then
		speaker "EarlReddick"
		message {
			"I'm going to die!",
			"And I'm not even at retirement age!"
		}

		speaker "Demon"
		message "Burn! Die! In the name of Gammon!"

		speaker "Hellhound"
		message "BARK!"
	elseif tick == TICK_DEMONS_DIE then
		speaker "Guard1"
		message "Die, demon spawn!"

		speaker "Guard2"
		message "(I feel bad hurting a dog, even if it's from the Daemon Realm...)"
	elseif tick == TICK_PLAYER then
		PLAYER_NAME = _TARGET:getName()

		speaker "EarlReddick"
		message {
			"Bastiel! I thought I was a goner!",
			"Thank you, my loyal guards!"
		}

		speaker "Guard1"
		message "Anything for you, sir!"

		speaker "Guard2"
		message "Absolutely!"

		speaker "_TARGET"
		message {
			"What happened here?!",
			"I heard a commotion and ran here as fast as I could!",
			"Are those demons?!"
		}

		speaker "EarlReddick"
		message {
			"Good heavens, it's you %person{${PLAYER_NAME}}!",
			"My guards saved me from these demonic assassins!",
			"Thank Bastiel we have that %location{monastery} near us!"
		}

		speaker "Guard1"
		message {
			"Who knows what would happen if those demons",
			"were at their full strength!"
		}

		speaker "_TARGET"
		message "Well, good news is - supper is almost ready!"

		speaker "EarlReddick"
		message {
			"Nothing makes me happier than food!",
			"I need something to eat after this near-death experience!"
		}

		speaker "_TARGET"
		message {
			"Let me check with %person{Chef Allon}",
			"and put the finishing touches on the cake...",
			"Then it's time to celebrate!"
		}

		speaker "EarlReddick"
		message "Well said! Summon me when all is ready!"

		_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_BlamedSomeoneElse")
	end
end
