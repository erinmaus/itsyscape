local isLyraInJail = _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_BetrayedLyra")
local isGoingToDie = _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_LitKursedCandle")

PLAYER_NAME = _TARGET:getName()

local map = Utility.Peep.getMapScript(_TARGET)
local tick = map:incrementSuperSupperSaboteurDialogTick()

local TICK_TALK = 1
local TICK_CAKE = 2

-- Death route
local TICK_DIE     = 3
local TICK_CRY     = 4

-- Death route (double-cross)
local TICK_ATTACK  = 5

-- Happy route
local TICK_THANKS = 3

if tick == TICK_TALK then
	speaker "ChefAllon"
	message {
		"Happy birthday, %person{Earl Reddick}!",
		"%person{${PLAYER_NAME}} made a positively delicious cake",
		"to top off that extravagant dinner!"
	}

	speaker "EarlReddick"
	message {
		"Hard to think that anything can top you,",
		"%person{Chef Allon}!"
	}

	speaker "_TARGET"
	message "Well, why don't you give it a taste and find out?"

	speaker "EarlReddick"
	message "A little full of yourself, eh? Let's see it!"
elseif tick == TICK_CAKE then
	speaker "EarlReddick"
	message "This is astounding!"

	speaker "_TARGET"
	message "I'm most humbled to hear it!"

	speaker "ChefAllon"
	message "I knew I could trust you, %person{${PLAYER_NAME}}!"

	if isGoingToDie then
		speaker "_TARGET"
		message "(...I wonder how long he has?)"
	end
end

if isGoingToDie then
	if tick == TICK_DIE then
		speaker "EarlReddick"
		message "Urrrrgh... I don't think it's settling..."

		speaker "ChefAllon"
		message {
			"Did %person{${PLAYER_NAME}} mess up the recipe?!",
			"I double checked...!"
		}

		speaker "EarlReddick"
		message "No... it's not... that..."

		speaker "_TARGET"
		message "(Well, that was quick.)"

		speaker "ChefAllon"
		message "Earl? Are you okay? My liege?"

		speaker "GuardCaptain"
		speaker "%person{Earl Reddick}?! Are you ok?"
	elseif tick == TICK_CRY then
		if isLyraInJail then
			speaker "ChefAllon"
			message {
				"How did %person{Lyra} still pull this off?!",
				"That witch!"
			}

			speaker "GuardCaptain"
			message {
				"My liege, nooooooo!",
				"She must be using some evil magic as we speak!",
				"I will have her head!"
			}
		else
			if _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_GotContracts") then
				speaker "_TARGET"
				message {
					"Maybe the assassin was under our noses!",
					"The demons were a distriction!",
					"It was %person{Chef Allon}!"
				}
			else
				speaker "_TARGET"
				message {
					"Maybe the assassin was under our noses!",
					"It was %person{Chef Allon}!"
				}
			end
		end
	elseif tick == TICK_ATTACK then
		speaker "GuardCaptain"
		message "You bastard! We trusted you!"

		speaker "ChefAllon"
		message {
			"No, it wasn't me!",
			"Maybe it was the adventurer?!"
		}

		speaker "GuardCaptain"
		message {
			"You're in charge of the food!",
			"So it's your fault!",
			"That adventurer probably gave the Earl a fatal case of food poisoning at worst!"
		}

		speaker "ChefAllon"
		message {
			"So arrest " .. Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_OBJECT) .. ", not me!"
		}

		speaker "GuardCaptain"
		message {
			"You know as well as I do that adventurers are protected under Good Samaritan decrees!",
			"But you sure as hell aren't!"
		}
	end
else
	if tick == TICK_THANKS then
		speaker "EarlReddick"
		message {
			"And lastly, I'd like to give my thanks...",
			"%person{${PLAYER_NAME}}, you saved me and made a wonderful cake!"
		}

		message "%person{Chef Allon}, your dinner was top-notch, as always!"

		message "%person{Guard captain}, you and your peeps tirelessly keep me safe!"

		message "Now, let's call it a day!"
	end
end
