if not _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_PirateEncounterInitiated") then
	defer "Resources/Game/Maps/IsabelleIsland_FarOcean/Dialog/InitialBanter_en-US.lua"
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
				local pirate = hits[i]
				local status = pirate:getBehavior("CombatStatus")
				if status and status.currentHitpoints > 0 and not status.dead then
					local pirateMap = Utility.Peep.getMap(pirate)
					if pirateMap.id.value == Utility.Peep.getMap(_TARGET).id.value then
						piratesAlive = true
						break
					end
				end
			end
		end
	end

	if piratesAlive and false then
		defer "Resources/Game/Maps/IsabelleIsland_FarOcean/Dialog/CombatBanter_en-US.lua"
	else
		defer "Resources/Game/Maps/IsabelleIsland_FarOcean/Dialog/PostBanter_en-US.lua"
	end
end
