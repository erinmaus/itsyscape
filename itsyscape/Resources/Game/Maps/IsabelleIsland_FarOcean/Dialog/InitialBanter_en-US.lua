PLAYER_NAME = _TARGET:getName()

speaker "CapnRaven"

message { 
	"Avast, Jenkins! We know yer that merchant's portmaster!",
	"Give us yer loot and ye can sail another day."
}

speaker "Jenkins"

message {
	"How could ye do this? We use'd t'be mates, Cap'n Raven!"
}

speaker "CapnRaven"

message {
	"We stopped being mates when ye threw off yer hat.",
	"Now give us yer valuables and out of the little respect I still have fer ye, I'll let ye live."
}

speaker "Jenkins"

message {
	"Archer Whats-Yer-Name and Wizard Whatever-Yer-Name-Is, slay these piratey scum!",
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
		if actor and actor.actor then
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
	"${PLAYER_NAME}, help 'em out!"
}

speaker "_TARGET"

message {
	"Got it!"
}
