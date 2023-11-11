local hasStartedQuest = _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_Started")
local hasAlmostBeenAssassinated = _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_BlamedSomeoneElse")
local hasBetrayedLyra = _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_BetrayedLyra")
local hasCompletedQuest = _TARGET:getState():has("Quest", "SuperSupperSaboteur")

print("hasStartedQuest", hasStartedQuest)
print("hasAlmostBeenAssassinated", hasAlmostBeenAssassinated)
print("hasBetrayedLyra", hasBetrayedLyra)
print("hasCompletedQuest", hasCompletedQuest)

if hasStartedQuest then
	if not hasCompletedQuest then
		if hasBetrayedLyra then
			speaker "EarlReddick"

			message {
				"Well met, adventurer.",
				"We are investigating %person{Lyra] as I speak.",
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
				local BETRAY = option "Turn in Lyra."
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
