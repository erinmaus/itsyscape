speaker "Orlando"

PLAYER_NAME = _TARGET:getName()

if not Utility.Quest.didStart("Tutorial") then
	message {
		"'EY, %person${PLAYER_NAME:upper()}! ARE YOU OKAY?!"
	}

	speaker "_TARGET"
	message "..."

	speaker "Orlando"
	message {
		"Good! Pick up those items."
	}

	_TARGET:getState():give("KeyItem", "Tutorial_Start")
elseif Utility.Quest.isNextStep("Tutorial_GatheredItems") then
	message "Pick up those items!"
elseif Utility.Quest.isNextStep("Tutorial_EquipItems") then
	message "Equip those items!"
end
