if Utility.Quest.isNextStep("SuperSupperSaboteur", "SuperSupperSaboteur_FoundEvidence", _TARGET) then
	speaker "_TARGET"
	message {
		"I hate to do this..."
	}

	if _TARGET:getState():give("Item", "SuperSupperSaboteur_Poison", 1, { ['item-inventory'] = true, ['item-drop-excess'] = true }) then
		_TARGET:getState():give("KeyItem", "SuperSupperSaboteur_FoundEvidence")

		speaker "Coffin"
		message "(You look in the coffin. You find a poison.)"
	else
		speaker "Coffin"
		message {
			"(You look in the coffin. You find a poison.)",
			"(But you fumble the poison and drop it back into the coffin.)"
		}
	end
elseif _TARGET:getState():has("KeyItem", "SuperSupperSaboteur_FoundEvidence") then
	speaker "_TARGET"
	message "There's nothing else in here..."
else
	speaker "_TARGET"
	message "I don't have a reason to search the coffin!"
end
