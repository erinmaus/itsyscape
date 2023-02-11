if not _TARGET:getState():has("KeyItem", "CalmBeforeTheStorm_PirateEncounterInitiated") then
	defer "Resources/Game/Maps/IsabelleIsland_FarOcean/Dialog/InitialBanter_en-US.lua"
else
	local piratesAlive = true
	local cthulhuSpawned = false
	do
		local director = _TARGET:getDirector()
		local gameDB = director:getGameDB()
		local pirateResource = gameDB:getResource("IsabelleIsland_FarOcean_Pirate", "Peep")

		local Probe = require "ItsyScape.Peep.Probe"

		do
			local hits = director:probe(_TARGET:getLayerName(), Probe.resource(pirateResource))
			if #hits == 0 then
				piratesAlive = false
			else
				piratesAlive = false

				for i = 1, #hits do
					local pirate = hits[i]
					local status = pirate:getBehavior("CombatStatus")
					if status and status.currentHitpoints > 0 and not status.dead then
						local pirateMap = Utility.Peep.getMapResource(pirate)
						if pirateMap.id.value == Utility.Peep.getMapResource(_TARGET).id.value then
							piratesAlive = true
							break
						end
					end
				end
			end
		end

		local cthulhuResource = gameDB:getResource("IsabelleIsland_FarOcean_Cthulhu", "Peep")
		do
			local hits = director:probe(_TARGET:getLayerName(), Probe.resource(cthulhuResource))
			if #hits > 0 then
				cthulhuSpawned = true
			end
		end
	end

	if _DEBUG then
		piratesAlive = false
	end

	if piratesAlive then
		defer "Resources/Game/Maps/IsabelleIsland_FarOcean/Dialog/CombatBanter_en-US.lua"
	elseif not cthulhuSpawned then
		defer "Resources/Game/Maps/IsabelleIsland_FarOcean/Dialog/PostBanter_en-US.lua"
	else
		defer "Resources/Game/Maps/IsabelleIsland_FarOcean/Dialog/PostCthulhuBanter_en-US.lua"
	end
end
