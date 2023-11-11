local wasBetrayed = _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_BetrayedLyra")
local wasTurnedIn = _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_TurnedInLyra")

if wasBetrayed then
	speaker "Lyra"
	message {
		"I'm bidding my time while I plot to murder you.",
		"You think these bars can keep me in?",
		"Think again."
	}

	speaker "Oliver"
	message "Grr! Woof!"
elseif wasTurnedIn then
	speaker "Lyra"
	message {
		"I won't be here long.",
		"There's more important matters at hand",
		"than serving my sentence."
	}

	speaker "Oliver"
	message "Woof!"
end
