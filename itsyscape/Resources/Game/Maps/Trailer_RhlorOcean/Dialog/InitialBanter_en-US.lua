PLAYER_NAME = _TARGET:getName()

speaker "CapnRaven"

message { 
	"Avast, %person{Jenkins}!",
	"We know yer that merchant's portmaster!",
	"Give us yer %item{loot} and ye can sail another day."
}

speaker "Jenkins"

message {
	"How could ye do this?",
	"We use'd t'be mates, %person{Cap'n Raven}!"
}

speaker "CapnRaven"

message "That t'was before ye threw off yer hat."
message "Now give us yer valuables and out of the little respect I still have fer ye, I'll let ye live."

speaker "Jenkins"

message {
	"%person{Archer Who-Ever} and %person{Wizard Who-Cares},",
	"slay these piratey scum!",
	"Do what yer paid to, mates!"
}

local director = _TARGET:getDirector()
local gameDB = director:getGameDB()
local function attack(mercenaryName, pirateName)
	local Probe = require "ItsyScape.Peep.Probe"

	local mercenary
	do
		local mercenaryResource = gameDB:getResource(mercenaryName, "Peep")

		local hits = director:probe(_TARGET:getLayerName(), Probe.resource(mercenaryResource))
		if hits then
			mercenary = hits[1]
		end
	end

	local pirate
	do
		local hits = director:probe(_TARGET:getLayerName(), Probe.namedMapObject(pirateName))
		if hits then
			pirate = hits[1]
		end
	end

	if mercenary and pirate then
		Utility.Peep.attack(mercenary, pirate)

		local actor = pirate:getBehavior("ActorReference")
		local status = pirate:getBehavior("CombatStatus")
		if actor and actor.actor and status and status.currentHitpoints > 0 and not status.dead then
			local actor = actor.actor
			actor:flash("Message", 1, "Arrr, ye scallywag!")
		end
	else
		Log.warn("Couldn't find mercenary %s or pirate %s!", mercenaryName, pirateName)
	end
end

attack("IsabelleIsland_FarOcean_Wizard", "Pirate1")
attack("IsabelleIsland_FarOcean_Archer", "Pirate2")

_TARGET:getState():give("KeyItem", "CalmBeforeTheStorm_PirateEncounterInitiated")

speaker "CapnRaven"
message {
	"Have it yer way, fool!"
}

speaker "Jenkins"

message {
	"%person{${PLAYER_NAME}}, help 'em out!",
	"%hint{Attack 'em pirates, mate!}"
}

speaker "_TARGET"

message {
	"Got it!"
}
