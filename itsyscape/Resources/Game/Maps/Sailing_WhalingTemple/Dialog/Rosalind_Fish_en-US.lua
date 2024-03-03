local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local PreTutorialCommon = require "Resources.Game.Peeps.PreTutorial.V2Common"

local INVENTORY_FLAGS = {
	['item-inventory'] = true
}

local EQUIPMENT_FLAGS = {
	['item-equipment'] = true
}

speaker "Rosalind"

if not _TARGET:getState():has("KeyItem", "PreTutorial_KilledMaggot") then
	_TARGET:addBehavior(DisabledBehavior)

	message {
		"Looks like we found some fish!",
		"And there's maggots we can slay and use as bait."
	}

	local hasToyWeaponEquipped = _TARGET:getState():has("Item", "ToyWand", 1, EQUIPMENT_FLAGS) or
	                             _TARGET:getState():has("Item", "ToyLongsword", 1, EQUIPMENT_FLAGS) or
	                             _TARGET:getState():has("Item", "ToyBommerang", 1, EQUIPMENT_FLAGS)

	local function listenForAttack()
		_TARGET:removeBehavior(DisabledBehavior)
		PreTutorialCommon.listenForAttack(_TARGET)
		_TARGET:getState():give("KeyItem", "PreTutorial_FoundFish")
	end

	if not hasToyWeaponEquipped then
		local hint, toy
		if _TARGET:getState():has("Item", "ToyWand", 1, INVENTORY_FLAGS) then
			hint = PreTutorialCommon.EQUIP_TOY_WAND
			toy = "wand"
		elseif _TARGET:getState():has("Item", "ToyLongsword", 1, INVENTORY_FLAGS) then
			hint = PreTutorialCommon.EQUIP_TOY_LONGSWORD
			toy = "longsword"
		elseif _TARGET:getState():has("Item", "ToyBommerang", 1, INVENTORY_FLAGS) then
			hint = PreTutorialCommon.EQUIP_TOY_BOOMERANG
			toy = "boomerang"
		else
			message {
				"You should probably %hint{make a weapon}",
				"before fighting a maggot."
			}

			return
		end

		message "Do you need me to show you how to equip your weapon?"

		local YES = option(string.format("Yes, show me how to equip the %s.", toy))
		local NO  = option(string.format("No, I can equip the %s on my own.", toy))

		local result = select { YES, NO }

		if result == YES then
			PreTutorialCommon.startRibbonTutorial(_TARGET, hint, "PlayerInventory", listenForAttack)
		else
			listenForAttack()
		end
	else
		message {
			"Looks like you've got a weapon equipped.",
			"Let's slay some maggots!"
		}

		listenForAttack()
	end
elseif not _TARGET:getState():has("KeyItem", "PreTutorial_Fished") then
	_TARGET:addBehavior(DisabledBehavior)

	if _TARGET:getState():has("Item", "WimpyFishingRod", 1, INVENTORY_FLAGS) or
	   _TARGET:getState():has("Item", "WimpyFishingRod", 1, EQUIPMENT_FLAGS) or
	   _TARGET:getState():give("Item", "WimpyFishingRod", 1, INVENTORY_FLAGS)
	then
		message {
			"Here's a %item{fishing rod}.",
			"If you run out of %item{bait}, just kill more maggots!"
		}
	else
		message {
			"Your bag is full!",
			"Make some room so I can give you a %item{fishing rod}."
		}
	end

	_TARGET:removeBehavior(DisabledBehavior)
end
