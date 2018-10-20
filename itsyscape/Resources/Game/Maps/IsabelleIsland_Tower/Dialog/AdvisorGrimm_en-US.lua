if not _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_TalkedToGrimm1") then
	defer "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/AdvisorGrimmStart_en-US.lua"
else
	defer "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/AdvisorGrimmPostStart_en-US.lua"
end
