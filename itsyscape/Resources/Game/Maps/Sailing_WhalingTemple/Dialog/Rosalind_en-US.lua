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
else
	message "Let's explore!"
end
