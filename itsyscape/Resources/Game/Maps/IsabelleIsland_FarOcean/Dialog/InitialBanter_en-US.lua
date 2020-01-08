PLAYER_NAME = _TARGET:getName()

speaker "CapnRaven"

message { 
	"Avast, %person{Jenkins}! We know yer that merchant's portmaster!",
	"Give us yer %item{loot} and ye can sail another day."
}

speaker "Jenkins"

message {
	"How could ye do this? We use'd t'be mates, %person{Cap'n Raven}!"
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
	"${PLAYER_NAME}, help 'em out! %hint{Attack 'em pirates, mate!}"
}

speaker "_TARGET"

message {
	"Got it!"
}

Utility.UI.openInterface(
	_TARGET,
	"VideoTutorial",
	true,
	{
		{
			video = "Resources/Game/Videos/Tutorial/Static.ogv",
			text = "Welcome to the ItsyRealm combat tutorial!\n\n" ..
				"Click on the TV to the left to see a bigger example of the tutorial.\n\n" ..
				"Use the next & previous buttons to navigate.\n\n" ..
				"Click the 'X' button in the top-right corner any time to return to the game."
		},
		{
			video = "Resources/Game/Videos/Tutorial/Camera.ogv",
			text =
				"Press and drag the middle mouse button to move the camera.\n\n" ..
				"Scroll the middle mouse button to zoom in or out.\n\n" ..
				"Left click to perform the default action.\n\n" ..
				"Right click to see all available options."
		},
		{
			video = "Resources/Game/Videos/Tutorial/Equipment.ogv",
			text = 
				"Click on equipment in your inventory tab to equip it.\n\n" ..
				"To dequip items, click on the item in the equipment tab.\n\n" ..
				"There's three primary classes of equipment (magic, archery, and melee). Choose wisely!"
		},
		{
			video = "Resources/Game/Videos/Tutorial/Combat.ogv",
			text = 
				"Bind powers to the strategy bar by right clicking on a spot.\n\n" ..
				"Left click on the power before your next attack to use it.\n\n" ..
				"Powers have cooldowns and other requirements to use.\n\n" ..
				"You automatically perform basic attacks otherwise.\n\n",
		},
		{
			video = "Resources/Game/Videos/Tutorial/Food.ogv",
			text =
				"After taking damage, use food and other items to heal.\n\n" ..
				"If you die, you'll wake up at the last spot you slept at.\n\n" ..
				"(Sleeping at a bed also saves your progress and restores your stats.)"
		}
	})
