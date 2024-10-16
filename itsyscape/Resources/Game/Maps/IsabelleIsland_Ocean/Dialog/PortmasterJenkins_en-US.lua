speaker "Jenkins"

local squid
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
		squid = hits[1]
		local status = squid:getBehavior("CombatStatus")
		if not status or status.currentHitpoints == 0 then
			squidAlive = false
		end
	end
end

if squidAlive then
	speaker "Jenkins"
	message {
		"Bloody 'ell!",
		"No time for talkin', slay the squid, mate!"
	}

	local player = Utility.Peep.getPlayerModel(_TARGET)
	if player then
		player:pokeCamera('shake', 0.5)
	end

	speaker "Squid"
	message "EEEEEEEEEEEEEEE'RGH! EEEEEEE!"
else
	speaker "Jenkins"
	message "Har har har! Ye did it!"

	local count, ratio
	do
		local ship = Utility.Peep.getMapScript(_TARGET)
		if ship:isCompatibleType(require "Resources.Game.Peeps.Maps.ShipMapPeep") then
			ratio = ship:getCurrentHealth() / ship:getMaxHealth()
			count = math.max(math.floor(ratio * 50), 10)
		else
			count = 10
		end
	end

	local director = _TARGET:getDirector()
	local gameDB = director:getGameDB()
	local chestResource = gameDB:getResource("IsabelleIsland_Port_RewardChest", "Prop")

	local Probe = require "ItsyScape.Peep.Probe"
	local chest = director:probe(_TARGET:getLayerName(), Probe.resource(chestResource))[1]
	if chest then
		message {
			"Y'know the squid had a belly full o' fish'n'goods.",
			"By Isabelle's command, it's all yers.",
			"Ye'll find a chest with the loot at the fishin' store."
		}

		message "Let's sail back to port, mate, and celebrate!"

		chest:poke('materialize', {
			count = count,
			dropTable = gameDB:getResource("IsabelleIsland_Port_UndeadSquid_Rewards", "DropTable"),
			peep = _TARGET,
			boss = squid,
			chest = chest
		})

		chest:poke('materialize', {
			count = 1,
			dropTable = gameDB:getResource("IsabelleIsland_Port_UndeadSquid_Rewards_Skull", "DropTable"),
			peep = _TARGET,
			boss = squid,
			chest = chest
		})

		_TARGET:getState():give("Skill", "Sailing", Utility.xpForResource(20) * ratio)
	end

	local stage = _TARGET:getDirector():getGameInstance():getStage()
	stage:movePeep(_TARGET, "IsabelleIsland_Port", "Anchor_ReturnFromSea")
end
