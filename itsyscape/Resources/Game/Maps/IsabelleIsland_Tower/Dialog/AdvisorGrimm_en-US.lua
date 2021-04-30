if not _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_TalkedToIsabelle1") then
	PLAYER_NAME = _TARGET:getName()

	speaker "AdvisorGrimm"
	message {
		"Hello, %person{${PLAYER_NAME}}.",
		"Please see %person{Isabelle} in the room to the north."
	}
elseif not _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_TalkedToGrimm1") then
	defer "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/AdvisorGrimmStart_en-US.lua"
else
	defer "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/AdvisorGrimmPostStart_en-US.lua"
end
