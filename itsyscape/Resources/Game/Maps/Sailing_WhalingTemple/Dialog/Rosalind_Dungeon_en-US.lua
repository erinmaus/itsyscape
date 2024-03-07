local Probe = require "ItsyScape.Peep.Probe"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
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
elseif not _TARGET:getState():has("KeyItem", "PreTutorial_CollectedAzatiteShards") then
	local isYenderlingAlive
	do
		local yenderling = _SPEAKERS["Yenderling"]
		isYenderlingAlive = not yenderling or not (yenderling:hasBehavior(CombatStatusBehavior) and yenderling:getBehavior(CombatStatusBehavior).dead)
	end

	if isYenderlingAlive then
		if _TARGET:getState():has("KeyItem", "PreTutorial_SlayedYenderling") then
			if not _TARGET:getState():has("Item", "AzatiteShard", 5, INVENTORY_FLAGS) then
				speaker "Rosalind"
				message "We need to slay the yenderling and get some %item{azatite shards}!"
			else
				-- This shouldn't generally happen...
				_TARGET:getState():give("KeyItem", "PreTutorial_CollectedAzatiteShards")
				return
			end
		else
			speaker "_TARGET"
			message "I better help %person{Rosalind} slay the yenderling!"
		end
	else
		speaker "Rosalind"
		message "Let's get some azatite shards!"
	end
elseif not _TARGET:getState():has("KeyItem", "PreTutorial_MinedCopper") then
	if Utility.Peep.isInPassage(_TARGET, "Passage_Mine") then
		speaker "Rosalind"

		if _TARGET:getState():has("Item", "BronzePickaxe", 1, INVENTORY_FLAGS) or
		   _TARGET:getState():has("Item", "BronzePickaxe", 1, EQUIPMENT_FLAGS)
		then
			-- Nothing.
		elseif not _TARGET:getState():give("Item", "BronzePickaxe", 1, INVENTORY_FLAGS) then
			message {
				"Looks like your inventory is full!",
				"I can't give you a bronze pick-axe."
			}

			defer "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Drop_en-US.lua"
			return
		else
			message {
				"Here's a bronze pick-axe.",
				"You can use it to mine some copper!"
			}
		end

		if _TARGET:getState():has("Item", "Hammer", 1, INVENTORY_FLAGS) then
			-- Nothing.
		elseif not _TARGET:getState():give("Item", "Hammer", 1, INVENTORY_FLAGS) then
			message {
				"Looks like your inventory is full!",
				"I can't give you a hammer."
			}

			defer "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Drop_en-US.lua"
			return
		else
			message {
				"And here's a hammer!",
				"You'll need this later to smith the weird alloy."
			}
		end

		if (_TARGET:getState():has("Item", "BronzePickaxe", INVENTORY_FLAGS) or
		   _TARGET:getState():has("Item", "BronzePickaxe", EQUIPMENT_FLAGS)) and
			_TARGET:getState():has("Item", "Hammer", INVENTORY_FLAGS)
		then
			message "Go ahead! Mine some copper!"
		end
	elseif Utility.Peep.isInPassage(_TARGET, "Passage_ToMine") then
		speaker "Rosalind"

		message {
			"Looks like there's some copper up ahead!",
			"Copper itself is useless for armor,",
			"but you can smelt azatite and copper."
		}

		message {
			"Azatite and copper make something called",
			"a weird alloy, which can be made into armor.",
			"It's not the best armor, but better than nothing!"
		}

		message {
			"Let's go mine some!"
		}

		_TARGET:getState():give("KeyItem", "PreTutorial_TalkedAboutMine")
	elseif Utility.Peep.isInPassage(_TARGET, "Passage_ToBossDoor") then
		speaker "Rosalind"

		message {
			"Let's not get ahead of ourselves!",
			"You need some armor!"
		}
	else
		speaker "Rosalind"
		message {
			"Azatite is rare...",
			"It's thought to be from Azathoth.",
		}

		message {
			"The Old One, Yendor, made Azathoth in Her image.",
			"There hasn't been a way to Azathoth in centuries, if not longer."
		}

		message "Obviously, a yenderling might have some connection, but..."
		message "...it's still strange that azatite showed up now, of all times."

		message {
			"Sorry for the rambling,",
			"it's just unsettling to see azatite on the Realm."
		}

		message {
			"Anyway... Let's go!",
			"There's a furnace up ahead and some ore.",
			"Looks like we might be able to make you armor!"
		}

		_TARGET:removeBehavior(DisabledBehavior)
	end
elseif not _TARGET:getState():has("KeyItem", "PreTutorial_SmeltedWeirdBars") then
	message {
		"Good job! Mining is hard work!",
		"You can %hint{smelt some weird alloy bars} at the furnace."
	}

	message "You might need to mine some more ore to make a full set of armor."
	message "You'll need to mine %hint{five ores} total to make enough bars."
elseif not _TARGET:getState():has("KeyItem", "PreTutorial_SmithedUpAndComingHeroItem") then
	message {
		"Now that you have a %item{weird alloy bar},",
		"you can smith some armor with",
		"the %hint{hammer} at the anvils."
	}

	message {
		"You'll need to make four pieces of armor:",
		"a helmet, gloves, platebody, and boots."
	}
elseif not _TARGET:getState():has("KeyItem", "PreTutorial_SmithedUpAndComingHeroArmor") then
	local hasCopper = _TARGET:getState():has("Item", "CopperOre", 1, INVENTORY_FLAGS)
	local hasInputs = _TARGET:getState():has("Item", "AzatiteShard", 1, INVENTORY_FLAGS) or
	                  _TARGET:getState():has("Item", "WeirdAlloyBar", 1, INVENTORY_FLAGS)
	local hasAllArmor = _TARGET:getState():has("KeyItem", "PreTutorial_SmithedUpAndComingHeroHelmet") and
	                    _TARGET:getState():has("KeyItem", "PreTutorial_SmithedUpAndComingHeroGloves") and
	                    _TARGET:getState():has("KeyItem", "PreTutorial_SmithedUpAndComingHeroPlatebody") and
	                    _TARGET:getState():has("KeyItem", "PreTutorial_SmithedUpAndComingHeroBoots")

	if not hasInputs and not hasAllArmor then
		_TARGET:getState():give("KeyItem", "PreTutorial_GetMoreAzatiteShards")

		message {
			"Looks like you ran out of the stuff",
			"to make your new set of armor!"
		}

		if _TARGET:getState():give("Item", "AzatiteShard", 5, INVENTORY_FLAGS) then
			message {
				"I happen to have some more %item{azatite shards}!",
				"Here's five I found."
			}
		else
			message {
				"I found some more %item{azatite shards},",
				"but your inventory is full."
			}

			defer "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Drop_en-US.lua"
			return
		end

		if hasCopper then
			message {
				"Smelt some more %item{weird alloy bars}",
				"using the copper you have and the shards I gave you."
			}
		else
			message {
				"You'll need to %hint{mine some more} %item{copper ore}",
				"and then smelt some more %item{weird alloy bars}."
			}
		end

		message "Then you can smith the rest of the armor!"
	else
		message "Let's make that armor!"
	end
end
