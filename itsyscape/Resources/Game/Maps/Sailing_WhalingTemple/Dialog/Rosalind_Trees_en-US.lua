local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local PreTutorialCommon = require "Resources.Game.Peeps.PreTutorial.V2Common"

local INVENTORY_FLAGS = {
	['item-inventory'] = true
}

local EQUIPMENT_FLAGS = {
	['item-inventory'] = true
}

speaker "Rosalind"

if not _TARGET:getState():has("KeyItem", "PreTutorial_FoundTrees") then
	_TARGET:addBehavior(DisabledBehavior)

	message {
		"Looks like we found some trees!",
		"These might just work to repair the ship."
	}

	if _TARGET:getState():has("Item", "BronzeHatchet", 1, INVENTORY_FLAGS) or
	   _TARGET:getState():has("Item", "BronzeHatchet", 1, EQUIPMENT_FLAGS) or
	   _TARGET:getState():give("Item", "BronzeHatchet", 1, INVENTORY_FLAGS)
	then
		message {
			"Here's a bronze hatchet.",
			"Let's cut down some of those trees!"
		}

		message "Let me show you how to equip that axe..."

		PreTutorialCommon.startRibbonTutorial(_TARGET, PreTutorialCommon.EQUIP_BRONZE_HATCHET, "PlayerInventory", function()
			_TARGET:getState():give("KeyItem", "PreTutorial_FoundTrees")
			_TARGET:removeBehavior(DisabledBehavior)
		end)
	else
		message {
			"Somehow your bag is full!",
			"I can't give you a bronze hatchet.",
			"Make some room and talk to me again."
		}

		defer "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Drop_en-US.lua"
	end
elseif not _TARGET:getState():has("KeyItem", "PreTutorial_ChoppedTree") then
	_TARGET:addBehavior(DisabledBehavior)

	if _TARGET:getState():has("Item", "ShadowLogs", 1, INVENTORY_FLAGS) then
		message {
			"Looks like you got some %item{shadow logs}!",
			"These might make a good weapon..."
		}

		if _TARGET:getState():give("Item", "Knife", 1, INVENTORY_FLAGS) then
			message {
				"Here's a %item{knife}.",
				"You can use it to %hint{craft wooden weapons} from the shadow logs."
			}

			PreTutorialCommon.startRibbonTutorial(_TARGET, PreTutorialCommon.CRAFT_TOY_WEAPON, "PlayerInventory", function()
				_TARGET:removeBehavior(DisabledBehavior)
			end)
		else
			message {
				"I can't give you a %item{knife} because your bag is full!",
				"Make some room by dropping an item and then talk to me."
			}

			defer "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Drop_en-US.lua"
		end

		_TARGET:getState():give("KeyItem", "PreTutorial_ChoppedTree")
	else
		message {
			"Let's not get ahead of ourselves!",
			"We need to chop some logs to repair the ship."
		}

		_TARGET:removeBehavior(DisabledBehavior)
	end
elseif not _TARGET:getState():has("KeyItem", "PreTutorial_CraftedWeapon") then
	_TARGET:addBehavior(DisabledBehavior)

	message {
		"We should probably craft you a weapon.",
		"Only %empty{Fate} knows what's further along!"
	}

	if not _TARGET:getState():has("Item", "ShadowLogs", 1, INVENTORY_FLAGS) then
		message "You'll need to chop some more logs to make a weapon."

		_TARGET:removeBehavior(DisabledBehavior)
	elseif _TARGET:getState():has("Item", "Knife", 1, INVENTORY_FLAGS) then
		message {
			"You can use the %item{knife} I gave you to",
			"%hint{craft wooden weapons} from the shadow logs."
		}

		PreTutorialCommon.startRibbonTutorial(_TARGET, PreTutorialCommon.CRAFT_TOY_WEAPON, "PlayerInventory", function()
			_TARGET:removeBehavior(DisabledBehavior)

			if _TARGET:getState():has("Item", "ToyWand", 1, INVENTORY_FLAGS) or
			   _TARGET:getState():has("Item", "ToyLongsword", 1, INVENTORY_FLAGS) or
			   _TARGET:getState():has("Item", "ToyBommerang", 1, INVENTORY_FLAGS)
			then
				PreTutorialCommon.makeRosalindTalk(_TARGET, "TalkAboutTrees")
			end
		end)
	elseif _TARGET:getState():give("Item", "Knife", 1, INVENTORY_FLAGS) then
		message {
			"Here's a %item{knife}.",
			"You can use it to %hint{craft wooden weapons} from the shadow logs."
		}

		PreTutorialCommon.startRibbonTutorial(_TARGET, PreTutorialCommon.CRAFT_TOY_WEAPON, "PlayerInventory", function()
			_TARGET:removeBehavior(DisabledBehavior)
			PreTutorialCommon.makeRosalindTalk(_TARGET, "TalkAboutTrees")
		end)
	else
		message {
			"I can't give you a %item{knife} because your bag is full!",
			"Make some room by dropping an item and then talk to me."
		}

		defer "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Drop_en-US.lua"
	end
else
	message {
		"With that %item{up-and-coming hero's weapon} you crafted,",
		"it should be safe to move forward.",
		"Let's see what else is out there."
	}
end
