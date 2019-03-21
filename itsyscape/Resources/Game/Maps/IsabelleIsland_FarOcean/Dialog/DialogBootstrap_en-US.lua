if not _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_PirateEncounterInitiated") then
	defer "Resources/Game/Maps/IsabelleIsland_FarOcean/Dialog/InitialBanter_en-US.lua"
	_TARGET:getState():give("KeyItem", "CalmBeforeTheStorm_PirateEncounterInitiated")
else
	local piratesAlive = true
	do
		local director = _TARGET:getDirector()
		local gameDB = director:getGameDB()
		local pirateResource = gameDB:getResource("IsabelleIsland_FarOcean_Pirate", "Peep")

		local Probe = require "ItsyScape.Peep.Probe"
		local hits = director:probe(_TARGET:getLayerName(), Probe.resource(pirateResource))
		if #hits == 0 then
			piratesAlive = false
		else
			piratesAlive = false

			for i = 1, #hits do
				local pirate = hits[1]
				local status = pirate:getBehavior("CombatStatus")
				if not status or (status.currentHitpoints > 0 and not status.dead) then
					piratesAlive = true
					break
				end
			end
		end
	end

	if piratesAlive then
		defer "Resources/Game/Maps/IsabelleIsland_FarOcean/CombatBanter_en-US.lua"
	else
		defer "Resources/Game/Maps/IsabelleIsland_FarOcean/PostBanter_en-US.lua"
	end
end
