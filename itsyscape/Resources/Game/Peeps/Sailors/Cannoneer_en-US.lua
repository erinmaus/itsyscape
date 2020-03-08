speaker "_SELF"

PLAYER_NAME  = _TARGET:getName()
SPEAKER_NAME = _SPEAKERS["_SELF"]:getName()

message {
	"Ahoy, Captain %person{${PLAYER_NAME}}!",
	"Jumping to blow some foes to smithereens, captain!"
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
	message "Well have I got the right gear for you, %person{${SPEAKER_NAME}}!"

	Utility.UI.openInterface(_TARGET, "SailorEquipment", false, _SPEAKERS["_SELF"])
	return
elseif result == DISMISS_SAILOR then
	speaker "_TARGET"
	message "There's not going to be much more 'splosions for you now..."

	local YES = option "Yes, dismiss sailor"
	local NO  = option "No, keep sailor"

	if select { YES, NO } == YES then
		Utility.Peep.dismiss(_SPEAKERS["_SELF"])
	end
elseif result == NEVERMIND then
	return
end
