speaker "_SELF"

PLAYER_NAME  = _TARGET:getName()
SPEAKER_NAME = _SPEAKERS["_SELF"]:getName()

message {
	"Captain %person{${PLAYER_NAME}}! I saw you coming!",
	"The seas look promising."
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
	local TARGET_NAME
	speaker "_TARGET"
	message "Promising or not, let's get you ready, %person{${SPEAKER_NAME}}!"

	Utility.UI.openInterface(_TARGET, "SailorEquipment", false, _SPEAKERS["_SELF"])
	return
elseif result == DISMISS_SAILOR then
	speaker "_TARGET"
	message "I'm afraid you may have not seen this coming..."

	local YES = option "Yes, dismiss sailor"
	local NO  = option "No, keep sailor"

	if select { YES, NO } == YES then
		Utility.Peep.dismiss(_SPEAKERS["_SELF"])
	end
elseif result == NEVERMIND then
	return
end
