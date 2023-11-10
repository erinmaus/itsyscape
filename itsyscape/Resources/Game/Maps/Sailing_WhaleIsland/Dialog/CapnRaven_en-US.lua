PLAYER_NAME = _TARGET:getName()

speaker "CapnRaven"
message {
	"'Ey, ye owe me one, y'hear, %person{${PLAYER_NAME}}?",
	"Lemme know when ye wanna return to %location{Rumbridge port}."
}

local RETURN_TO_PORT = option "Return to port"
local NEVERMIND      = option "Nevermind"

local result = select {
	RETURN_TO_PORT,
	NEVERMIND
}

if result == RETURN_TO_PORT then
	speaker "_TARGET"
	message "Let's go."

	local stage = _TARGET:getDirector():getGameInstance():getStage()
	stage:movePeep(
		_TARGET,
		"Rumbridge_Port",
		"Anchor_Spawn")
elseif result == NEVERMIND then
	speaker "_TARGET"
	message "I think I'll stay for now."
end
