speaker "_SELF"

PLAYER_NAME = _TARGET:getName()

message {
	"Oi, uh, %person{Captain ${PLAYER_NAME}}!",
	"Please don't make me go on the boat!"
}

local CHANGE_EQUIPMENT = option "Equip sailor"
local DISMISS_SAILOR   = option "Dismiss sailor"
local NEVERMIND        = option "Nevermind"

local result = select {
	CHANGE_EQUIPMENT,
	DISMISS_SAILOR,
	NEVERMIND
}

if result == CHANGE_EQUIPMENT then
	speaker "_TARGET"
	message "Stop your whining! Let's get you prepared for sailing!"

	Utility.UI.openInterface(_TARGET, "SailorEquipment", false, _SPEAKERS["_SELF"])
	return
elseif result == DISMISS_SAILOR then
	speaker "_TARGET"
	message "I'm gonna find someone better!"

	speaker "_SELF"
	message "Thank goodness!"

	local YES = option "Yes, dismiss sailor"
	local NO  = option "No, keep sailor"

	if select { YES, NO } == YES then
		Utility.Peep.dismiss(_SPEAKERS["_SELF"])
	end
elseif result == NEVERMIND then
	return
end
