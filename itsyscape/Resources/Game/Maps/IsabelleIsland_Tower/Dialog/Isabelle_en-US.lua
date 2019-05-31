if not _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_Start") then
	defer "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/IsabelleStart_en-US.lua"
elseif not _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_TalkedToIsabelle1") then
	defer "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/IsabellePostStart_en-US.lua"
elseif _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_GotAllItems") and
       not _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_TalkedToIsabelle2")
then
	defer "Resources/Game/Maps/IsabelleIsland_Tower/Dialog/IsabelleGotAllItems_en-US.lua"
elseif _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_IsabelleDefeated")
then
	speaker "Isabelle"
	message "The Drakkenson will avenge me, you mite."

	speaker "_TARGET"
	message "Sure they will. Sure they will..."
else
	speaker "Isabelle"
	message "Sorry, I'm busy right now."
end
