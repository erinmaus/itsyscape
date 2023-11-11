local map = Utility.Peep.getMapResource(_TARGET)

local SEARCH_FLAGS = {
	['item-inventory'] = true,
	['item-bank'] = true
}

local hasKursedCandle = _TARGET:getState():has("Item", "UnlitKursedCandle", 1, SEARCH_FLAGS) or
                        _TARGET:getState():has("Item", "LitKursedCandle", 1, SEARCH_FLAGS)

if Utility.Quest.isNextStep("SuperSupperSaboteur", "SuperSupperSaboteur_TalkedToCapnRaven", _TARGET) then
	if map.name == "Rumbridge_Port" then
		speaker "Lyra"
		message {
			"%person{Cap'n Raven} is here at %location{the pub}.",
			"We've got to convince her!"
		}
	elseif map.name == "Rumbridge_Castle" then
		speaker "Lyra"
		message "Be careful! You'll blow our cover!"
	else
		speaker "Lyra"
		message {
			"Let's head to the %location{Rumbridge port}",
			"and talk to %person{Cap'n Raven}."
		}
	end
elseif Utility.Quest.isNextStep("SuperSupperSaboteur", "SuperSupperSaboteur_MadeCandle", _TARGET) then
	if hasKursedCandle then
		_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_MadeCandle")

		speaker "Lyra"
		message {
			"Yay, you made the candle!",
			"Now it's time to execute the plan.",
			"Let's head back to %location{my shop in the Shade district}."
		}

		speaker "_TARGET"
		message "Sure thing!"
	elseif map.name == "Sailing_WhaleIsland" then
		speaker "Lyra"
		message "Let's find that whale carcass!"
	else
		speaker "Lyra"
		message {
			"We need to return to the %location{mysterious island}",
			"and make that candle!"
		}
	end
else
	speaker "Lyra"
	message "Let's head back to %location{my shop in the Shade district}."
end
