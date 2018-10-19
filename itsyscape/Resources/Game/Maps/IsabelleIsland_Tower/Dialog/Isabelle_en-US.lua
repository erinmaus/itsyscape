if not _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_Start") then
	defer "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/IsabelleStart_en-US.lua"
elseif not _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_TalkedToIsabelle1") then
	defer "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/IsabellePostStart_en-US.lua"
else
	speaker "Isabelle"
	message "Sorry, I'm busy right now."
end
