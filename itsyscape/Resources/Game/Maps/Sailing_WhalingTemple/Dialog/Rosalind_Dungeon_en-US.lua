local Probe = require "ItsyScape.Peep.Probe"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local PreTutorialCommon = require "Resources.Game.Peeps.PreTutorial.V2Common"

local INVENTORY_FLAGS = {
	['item-inventory'] = true
}

local EQUIPMENT_FLAGS = {
	['item-equipment'] = true
}

speaker "Rosalind"

if not _TARGET:getState():has("KeyItem", "PreTutorial_CookedFish") then
	message {
		"We should cook some fish before going further.",
		"Gods know what's out there..."
	}
elseif not _TARGET:getState():has("KeyItem", "PreTutorial_SleptAtBed") then
	message {
		"Looks like there's a makeshift bed here.",
		"If you get knocked out you'll find yourself back at the last bed you slept at."
	}

	speaker "_TARGET"
	message {
		"How would I end up at the last place I slept at?!",
		"If I get knocked out what stops me from getting killed?!"
	}

	speaker "Rosalind"
	message {
		"%empty{Fate} works in mysterious ways.",
		"Who knows, maybe you'll just die instead!",
		"But better be safe than sorry!"
	}

	message {
		"Plus you'll get a good rest and restore your health!",
		"Isn't that great?"
	}
elseif not _TARGET:getState():has("KeyItem", "PreTutorial_FoundYenderling") then
	speaker "_TARGET"
	message "What in the Realm is that?!"

	speaker "Yenderling"
	message {
		"Screeee! Screeeeee!",
		"(Your end is my beginning, mortals.)"
	}

	speaker "Rosalind"
	message {
		"That's a yenderling! Ignore it!",
		"It will project intrusive thoughts into your head."
	}

	speaker "Yenderling"
	message {
		"Screee!",
		"(Just give in. Give up. Let the madness take you.)",

	}

	speaker "_TARGET"
	message {
		"(Horrifying images of death and",
		"decay race through your mind.)",
		"I'm scared...!"
	}

	speaker "Rosalind"
	message {
		"So am I!",
		"Let's show this monster what",
		"humans are capable of!"
	}

	speaker "Yenderling"
	message {
		"ScreEEEEeeeeEEEE!",
		"(There is no hope. Just lay down your weapons.)",
		"(Just let me beat you to death.)"
	}

	_TARGET:getState():give("KeyItem", "PreTutorial_FoundYenderling")
end
