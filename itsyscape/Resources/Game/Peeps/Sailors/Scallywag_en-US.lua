speaker "_SELF"

PLAYER_NAME = _TARGET:getName()
message {
	"'Eck, there " ..
		Utility.Text.getPronoun(_TARGET, Utility.Text.PRONOUN_SUBJECT) ..
		" " ..
		Utility.Text.getEnglishBe(_TARGET).present ..
		"!",
	"How's it be, Captain %person{${PLAYER_NAME}}? %hint{*burp*}"
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
	message "Hold your beer, let's get you ready!"

	Utility.UI.openInterface(_TARGET, "SailorEquipment", false, _SPEAKERS["_SELF"])
	return
elseif result == DISMISS_SAILOR then
	speaker "_TARGET"
	message "I've changed, there's a strict no alcohol policy on my boat!"

	speaker "_SELF"
	message "Really?! 'At's insane, mate!"

	local YES = option "Yes, dismiss sailor"
	local NO  = option "No, keep sailor"

	if select { YES, NO } == YES then
		Utility.Peep.dismiss(_SPEAKERS["_SELF"])
	end
elseif result == NEVERMIND then
	return
end
