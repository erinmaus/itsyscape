local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local PreTutorialCommon = require "Resources.Game.Peeps.PreTutorial.V2Common"

local INVENTORY_FLAGS = {
	['item-inventory'] = true
}

speaker "Rosalind"

if not _TARGET:getState():has("KeyItem", "PreTutorial_FoundTrees") then
	_TARGET:addBehavior(DisabledBehavior)

	message {
		"Looks like we found some trees!",
		"These might just work to repair the ship."
	}

	if not _TARGET:getState():give("Item", "BronzeHatchet", 1, INVENTORY_FLAGS) then
		message {
			"Somehow your bag is full!",
			"I can't give you a bronze hatchet.",
			"Make some room and talk to me again."
		}

		_TARGET:removeBehavior(DisabledBehavior)
	else
		message {
			"Here's a bronze hatchet.",
			"Let's cut down some of those trees!"
		}

		PreTutorialCommon.startRibbonTutorial(_TARGET, PreTutorialCommon.EQUIP_BRONZE_HATCHET, "PlayerInventory", function()
			_TARGET:removeBehavior(DisabledBehavior)
			_TARGET:getState():give("KeyItem", "PreTutorial_FoundTrees")
		end)
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

			_TARGET:removeBehavior(DisabledBehavior)
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

	if _TARGET:getState():has("Item", "Knife", 1, INVENTORY_FLAGS) or _TARGET:getState():give("Item", "Knife", 1, INVENTORY_FLAGS) then
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

		_TARGET:removeBehavior(DisabledBehavior)
	end
else
	message {
		"With that %item{upcoming hero's weapon} you crafted,",
		"it should be safe to move forward.",
		"Let's see what else is out there."
	}
end
