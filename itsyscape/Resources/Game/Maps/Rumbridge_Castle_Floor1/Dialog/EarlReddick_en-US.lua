local hasStartedQuest = _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_Started")
local hasAlmostBeenAssassinated = _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_BlamedSomeoneElse")
local hasBetrayedLyra = _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_BetrayedLyra")
local canTurnInLyra = Utility.Quest.isNextStep("SuperSupperSaboteur", "SuperSupperSaboteur_TurnedInLyra", _TARGET)
local hasTurnedInLyra = _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_TurnedInLyra")
local hasCompletedQuest = _TARGET:getState():has("Quest", "SuperSupperSaboteur")

local function turnInLyra()
	speaker "EarlReddick"
	message {
		"%person{Lyra}?! The friendly witch?!",
		"She's been a critical part of %location{Rumbridge} history,",
		"for over a hundred years!"
	}

	speaker "_TARGET"
	message {
		"It's true! I found poison in her shop",
		"and she confessed to wanting to assassinate you.",
		"She threatened me to stay silent."
	}

	speaker "EarlReddick"
	message {
		"We will search her shop at once!",
		"It's not like an adventurer to lie...!",
		"If we get evidence or get a confession ourselves,",
		"she will pay the price! No one is above the law!"
	}

	speaker "EarlReddick"
	message "Guards!"

	speaker "Guard1"
	message "Heard loud and clear, liege!"

	speaker "Guard2"
	message "Aye! Aye! We'll head out!"

	speaker "EarlReddick"
	message {
		"You will be handsomely rewarded.",
		"I will make sure of that myself."
	}
end

if hasStartedQuest then
	if not hasCompletedQuest then
		if canTurnInLyra then
			speaker "EarlReddick"
			message {
				"Well met, adventurer.",
				"Today may be my birthday,",
				"but I sit here with my guards in fear of my life."
			}

			speaker "_TARGET"
			message "About that..."

			local TURN_IN    = option "Turn in Lyra."
			local NEVERMIND  = option "Nevermind."

			local result = select {
				TURN_IN,
				NEVERMIND
			}

			if result == TURN_IN then
				speaker "_TARGET"
				message "(Do I really want to turn in %person{Lyra}?)"

				local YES = option "Yes, definitely, do it already!"
				local NO  = option "Let's think about it"

				local otherResult = select {
					YES, NO
				}

				if otherResult == YES then
					_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_TurnedInLyra")

					speaker "_TARGET"
					message "%person{Earl Reddick}, the rumoured assassin is %person{Lyra}!"

					turnInLyra()
				elseif otherResult == NO then
					speaker "_TARGET"
					message "Uh, nevermind."

					speaker "EarlReddick"
					message {
						"(The Earl stares into your soul.)",
						"If you hear something, say something.",
						"I will reward you handsomely for any information."
					}
				end
			elseif result == NEVERMIND then
				speaker "_TARGET"
				message {
					"Actually, I don't have a single thought",
					"in my tiny brain!"
				}
			end
		elseif hasTurnedInLyra or hasBetrayedLyra then
			speaker "EarlReddick"

			message {
				"Well met, adventurer.",
				"We are investigating %person{Lyra} as I speak.",
				"As soon as we have an answer, there will be justice."
			}
		elseif hasAlmostBeenAssassinated then
			speaker "EarlReddick"
			message {
				"Well met, adventurer.",
				"Almost being assassinated...",
				"Who would've thought demons had it out for me?!"
			}

			speaker "_TARGET"
			message "I haven't the faintest clue..."

			speaker "EarlReddick"
			message {
				"Well, if you ever find out more,",
				"please let me know."
			}

			if Utility.Quest.isNextStep("SuperSupperSaboteur", "SuperSupperSaboteur_BetrayedLyra", _TARGET) then
				local BETRAY = option "Betry Lyra and turn her in."
				local QUIET  = option "Keep quiet."

				local result = select {
					BETRAY,
					QUIET
				}

				if result == BETRAY then
					speaker "_TARGET"
					message "(Do I really want to betray %person{Lyra}?)"

					local YES = option "Yes, definitely, do it already!"
					local NO  = option "Let's think about it"

					local otherResult = select {
						YES, NO
					}

					if otherResult == YES then
						_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_BetrayedLyra")

						speaker "_TARGET"
						message {
							"%person{Earl Reddick}, I have some terrible news.",
							"The demons were summoned by %person{Lyra}.",
							"She wants to kill you."
						}

						turnInLyra()
					elseif otherResult == NO then
						speaker "EarlReddick"
						message "Is there something wrong?"
					end
				elseif result == QUIET then
					speaker "_TARGET"
					message "I need to go help %person{Chef Allon}..."

					speaker "EarlReddick"
					message "Thank you both for the work you've put in!"
				end
			end
		else
			speaker "EarlReddick"
			message {
				"Well met, adventurer.",
				"%person{Chef Allon} informed me you're assisting",
				"with my birthday cake!"
			}
		end
	else
		speaker "EarlReddick"
		message {
			"Adventurer, I owe you a debt.",
			"You prevented my assassination and",
			"made the most amazing %item{carrot cake} ever."
		}
	end
else
	speaker "EarlReddick"
	message {
		"Well met adventurer.",
		"Welcome to %location{Rumbridge}."
	}
end
