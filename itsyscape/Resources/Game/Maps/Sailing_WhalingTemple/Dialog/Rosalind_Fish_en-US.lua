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

if not _TARGET:getState():has("KeyItem", "PreTutorial_KilledMaggot") then
	_TARGET:addBehavior(DisabledBehavior)

	message {
		"Looks like we found some fish!",
		"And there's maggots we can slay and use as bait."
	}

	local hasToyWeaponEquipped = _TARGET:getState():has("Item", "ToyWand", 1, EQUIPMENT_FLAGS) or
	                             _TARGET:getState():has("Item", "ToyLongsword", 1, EQUIPMENT_FLAGS) or
	                             _TARGET:getState():has("Item", "ToyBoomerang", 1, EQUIPMENT_FLAGS)

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
		elseif _TARGET:getState():has("Item", "ToyBoomerang", 1, INVENTORY_FLAGS) then
			hint = PreTutorialCommon.EQUIP_TOY_BOOMERANG
			toy = "boomerang"
		else
			message {
				"You should probably %hint{make a weapon}",
				"before fighting a maggot."
			}

			listenForAttack()
			_TARGET:removeBehavior(DisabledBehavior)
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

		_TARGET:removeBehavior(DisabledBehavior)
	else
		message {
			"Your bag is full!",
			"Make some room so I can give you a %item{fishing rod}."
		}

		defer "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Drop_en-US.lua"
	end
elseif not _TARGET:getState():has("KeyItem", "PreTutorial_CookedFish") then
	_TARGET:addBehavior(DisabledBehavior)

	local hasTinderbox = _TARGET:getState():has("Item", "Tinderbox", 1, INVENTORY_FLAGS)

	if hasTinderbox or
	   _TARGET:getState():give("Item", "Tinderbox", 1, INVENTORY_FLAGS)
	then
		if _TARGET:getState():has("Item", "ShadowLogs", 1, INVENTORY_FLAGS) then
			if hasTinderbox then
				message "Let me show you how to light a fire to cook the %item{sardine}."
			else
				message {
					"Here's a %item{tinderbox}!",
					"Let me show you how to light a fire to cook the %item{sardine}."
				}
			end

			PreTutorialCommon.startRibbonTutorial(
				_TARGET,
				PreTutorialCommon.LIGHT_FIRE,
				"PlayerInventory")
		else
			if hasTinderbox then
				message {
					"Cut some trees for logs,",
					"then we can light a fire!"
				}
			else
				message {
					"Here's a %item{tinderbox}!",
					"Cut some trees for logs,",
					"then we can light a fire!"
				}
			end

			Utility.Quest.listenForItem(_TARGET, "ShadowLogs", function()
				PreTutorialCommon.makeRosalindTalk(_TARGET, "TalkAboutFish")
			end)

			_TARGET:removeBehavior(DisabledBehavior)
		end
	else
		message {
			"Your bag is full!",
			"Make some room so I can give you a %item{tinderbox}."
		}

		defer "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Drop_en-US.lua"
	end
else
	local hasBurntSardine = _TARGET:getState():has("Item", "BurntSardine", 1, INVENTORY_FLAGS)
	local hasCookedSardine = _TARGET:getState():has("Item", "CookedSardine", 1, INVENTORY_FLAGS)

	if hasCookedSardine then
		message {
			"Looks like you cooked the sardine!",
			"Good job!"
		}
	elseif hasBurntSardine then
		message {
			"Looks like you burnt the sardine!",
			"You should try again!"
		}
	end

	message {
		"Cooked fish and other food",
		"%hint{heals you when you eat it}."
	}

	message "You should definitely carry a few pieces of cooked fish as we push forward."

	message "Only %empty{Fate} knows what's up ahead!"
end
