speaker "Rosalind"

local INVENTORY_FLAGS = {
	['item-inventory'] = true,
	['item-equipment'] = true
}

local ITEMS = {
	{
		id = "BronzeHatchet",
		keyItem = "PreTutorial_FoundTrees",
		message = {
			"Looks like you lost your %item{bronze hatchet}.",
			"Here's another!"
		}
	},
	{
		id = "Knife",
		keyItem = "PreTutorial_ChoppedTree",
		message = {
			"Seems the %item{knife} fell out of your bag.",
			"Here's another!"
		}
	},
	{
		id = "WimpyFishingRod",
		keyItem = "PreTutorial_KilledMaggot",
		message = {
			"Seems you're missing the %item{fishing rod}.",
			"Here you go!"
		}
	},
	{
		id = "Tinderbox",
		keyItem = "PreTutorial_Fished",
		message = {
			"Can't light fires without a %item{tinderbox}!",
			"Don't be a pyromaniac!"
		}
	},
	{
		id = "BronzePickaxe",
		keyItem = "PreTutorial_CollectedAzatiteShards",
		message = {
			"Huh, where'd your %item{bronze pickaxe} go?",
			"Here's another!"
		}
	},
	{
		id = "Hammer",
		keyItem = "PreTutorial_CollectedAzatiteShards",
		message = {
			"You can't smith without a %item{hammer}!",
			"Here you go!"
		}
	}
}

local gaveAllItems = true
for _, item in ipairs(ITEMS) do
	if not _TARGET:getState():has("Item", item.id, 1, INVENTORY_FLAGS) and
	   _TARGET:getState():has("KeyItem", item.keyItem)
	then
		if _TARGET:getState():give("Item", item.id, 1, INVENTORY_FLAGS) then
			message(item.message)
		else
			gaveAllItems = false
			break
		end
	end
end

if not gaveAllItems then
	message {
		"I have something to give you,",
		"but your inventory is full.",
		"Make some space and talk to me again."
	}

	defer "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Drop_en-US.lua"
	return
end

if Utility.Quest.isNextStep("PreTutorial", "PreTutorial_FoundTrees", _TARGET) and
   Utility.Peep.isInPassage(_TARGET, "Passage_Trees")
then
	defer "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Trees_en-US.lua"
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_CraftedWeapon", _TARGET) then
	defer "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Trees_en-US.lua"
elseif _TARGET:getState():has("KeyItem", "PreTutorial_SmithedUpAndComingHeroItem") and
       not _TARGET:getState():has("KeyItem", "PreTutorial_SmithedUpAndComingHeroArmor")
then
	defer "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Dungeon_en-US.lua"
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_Teleported", _TARGET) and
   Utility.Peep.isInPassage(_TARGET, "Passage_BossArena")
then
	defer "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Portal_en-US.lua"
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_FoundTrees", _TARGET) then
	message {
		"We should be looking for %hint{fish and trees}.",
		"Let's also make sure the island is safe."
	}
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_ChoppedTree", _TARGET) then
	message {
		"We need to cut a tree for logs.",
		"The logs can repair the ship and %hint{also make weapons}, among other things."
	}
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_CraftedWeapon", _TARGET) then
	message {
		"Using a %item{knife} and the %item{logs}, you can %hint{craft a decent-enough weapon}.",
		"These trees are infected by Yendor's influence and have %hint{special properties} other trees do not."
	}
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_FoundFish", _TARGET) then
	message "Now that we found some trees we can chop, let's look for some fish!"
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_KilledMaggot", _TARGET) then
	message "Maggots should provide %item{bait}, which we %item{can use to fish}!"
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_Fished", _TARGET) then
	message {
		"With the %item{bait} from the maggot you slayed and that %item{fishing rod},",
		"you can fish up some %item{sardines} from the brackish water here!"
	}
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_CookedFish", _TARGET) then
	message {
		"If you light a fire, you can cook the fish on the fire.",
		"On the mainland, you can also use %item{ranges}, which are far superior."
	}
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_ExploreDungeon", _TARGET) then
	if not _TARGET:getState():has("KeyItem", "PreTutorial_SleptAtBed") then
		message "You probably should rest before we move forward."
	else
		message "Let's forge ahead and explore the underground now that you're rested up."
	end
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_SlayedYenderling", _TARGET) then
	message "We should %hint{slay the yenderling}!"
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_CollectedAzatiteShards", _TARGET) then
	message "Collect the %item{azatite shards}! Then we can make some armor."
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_MinedCopper", _TARGET) then
	message "You should mine some copper in the underground with the %item{bronze pickaxe} I gave you!"
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_SmeltedWeirdBars", _TARGET) then
	message "With the %item{azatite shards} and %item{copper ore}, you can smelt %item{weird alloy bars} at the %location{furnace}."
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_SmithedUpAndComingHeroArmor", _TARGET) then
	message "Using the %item{weird alloy bars}, you can smith some armor. If you %hint{run out of shards}, I got ya!"
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_FoundInjuredYendorian", _TARGET) then
	message "Let's see what's further in the underground."
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_DefeatedInjuredYendorian", _TARGET) then
	message "No time for talking! We gotta take down that Yendorian soldier!"
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_InformedJenkins", _TARGET) then
	message "Now that the fight is over, %person{Jenkins} and %person{Orlando} need to know what happened."
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_TurnedInSupplies", _TARGET) then
	message "We'll need supplies to repair the ship. Make sure you have some and get them to %person{Jenkins}."
elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_Teleported", _TARGET) then
	message "Let's head to the portal at %location{the temple ruins} north of the docks."
else
	message "Let's explore!"
end
