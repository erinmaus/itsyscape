speaker "Jenkins"

local squidAlive = true
do
	local director = _TARGET:getDirector()
	local gameDB = director:getGameDB()
	local squidResource = gameDB:getResource("IsabelleIsland_Port_UndeadSquid", "Peep")

	local Probe = require "ItsyScape.Peep.Probe"
	local hits = director:probe(_TARGET:getLayerName(), Probe.resource(squidResource))
	if #hits == 0 then
		squidAlive = false
	else
		local squid = hits[1]
		local status = squid:getBehavior("CombatStatus")
		if not status or status.currentHitpoints == 0 then
			squidAlive = false
		end
	end
end

if squidAlive then
	speaker "Jenkins"
	message "Bloody 'ell! No time for talkin', slay the squid, mate!"

	speaker "Squid"
	message "EEEEEEEEEEEEEEE'RGH! EEEEEEE!"
else
	speaker "Jenkins"
	message "Har har har! Ye did it! Let's return to port."

	local stage = _TARGET:getDirector():getGameInstance():getStage()
	stage:movePeep(_TARGET, "IsabelleIsland_Port", "Anchor_ReturnFromSea")
end
