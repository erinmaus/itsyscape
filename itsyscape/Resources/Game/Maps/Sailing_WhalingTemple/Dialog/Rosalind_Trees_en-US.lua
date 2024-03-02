local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"

local INVENTORY_FLAGS = {
	['item-inventory'] = true
}

local function startTutorial(hint, done)
	local time = love.timer.getTime()
	Utility.UI.openInterface(
		_TARGET,
		"TutorialHint",
		false,
		"root",
		not _MOBILE and "Look at the bottom right corner.\nClick on the flashing icon to continue." or "Look at the bottom right corner.\nTap on the flashing icon to continue.",
		function()
			return love.timer.getTime() > time + 5
		end,
		{ position = 'center' })

	Utility.UI.tutorial(_TARGET, tutorial, done)
end

local function showCraftingTutorial()
	local requirementsTime, quantityTime
	local CRAFT_TIP = {
		{
			position = 'up',
			id = "Ribbon-PlayerInventory",
			message = not _MOBILE and "Click here to access your inventory." or "Tap here to access your inventory.",
			open = function(target)
				return function()
					return Utility.UI.isOpen(target, "PlayerInventory")
				end
			end,
		},
		{
			position = 'up',
			id = "Inventory-ShadowLogs",
			message = not _MOBILE and "Click on the shadow logs to open the craft window." or "Tap on the shadow logs to open the craft window.",
			open = function(target)
				return function()
					return not target:getState():has("Item", "ShadowLogs", 1, INVENTORY_FLAGS) or Utility.UI.isOpen(target, "CraftWindow")
				end
			end
		},
		{
			position = 'up',
			id = "CraftWindow",
			message = not _MOBILE and "Click on one of the weapons." or "Tap on one of the weapons",
			open = function(target)
				return function()
					local open, index = Utility.UI.isOpen(target, "CraftWindow")
					if open then
						local interface = Utility.UI.getOpenInterface(target, "CraftWindow", index)
						return interface.currentAction ~= nil
					end

					return true
				end
			end
		},
		{
			position = 'up',
			id = "Craft-Requirements",
			message = "Take a look at the requirements to craft this weapon.",
			open = function(target)
				return function()
					requirementsTime = requirementsTime or love.timer.getTime()
					return not Utility.UI.isOpen(target, "CraftWindow") or love.timer.getTime() > requirementsTime + 5
				end
			end
		},
		{
			position = 'up',
			id = "Craft-QuantityInput",
			message = "Double check to make sure you're making the right amount of things!",
			open = function(target)
				return function()
					quantityTime = quantityTime or love.timer.getTime()
					return not Utility.UI.isOpen(target, "CraftWindow") or ove.timer.getTime() > quantityTime + 5
				end
			end
		},
		{
			position = 'up',
			id = "Craft-MakeIt!",
			message = not _MOBILE and "Once you're happy, click here to craft the weapon!" or "Once you're happy, tap here to craft the weapon!",
			open = function(target)
				return function()
					return not Utility.UI.isOpen(target, "CraftWindow")
				end
			end
		},
	}

	showTutorial(CRAFT_TIP, function()
		_TARGET:getState():give("KeyItem", "PreTutorial_CraftedWeapon")
		_TARGET:removeBehavior(DisabledBehavior)
	end)
end

local function showEquipTutorial()
	local INVENTORY_TIP = {
		{
			position = 'up',
			id = "Ribbon-PlayerInventory",
			message = not _MOBILE and "Click here to access your inventory." or "Tap here to access your inventory.",
			open = function(target)
				return function()
					return Utility.UI.isOpen(target, "PlayerInventory")
				end
			end,
		},
		{
			position = 'up',
			id = "Inventory-BronzeHatchet",
			message = not _MOBILE and "Click on the bronze hatchet to equip it." or "Tap on the bronze hatchet to equip it.",
			open = function(target)
				return function()
					return not target:getState():has('Item', "BronzeHatchet", 1, INVENTORY_FLAGS)
				end
			end
		}
	}

	startTutorial(INVENTORY_TIP, function()
		_TARGET:getState():give("KeyItem", "PreTutorial_FoundTrees")
		_TARGET:removeBehavior(DisabledBehavior)
	end)
end

speaker "Rosalind"
if not _TARGET:getState():has("KeyItem", "PreTutorial_FoundTrees") then
	_TARGET:addBehavior(DisabledBehavior)

	message {
		"Looks like we found some trees!",
		"These might just work to repair the ship."
	}

	if not _TARGET:getState():give("Item", "BronzeHatchet", 1) then
		message {
			"Somehow your bag is full!",
			"I can't give you a bronze hatchet.",
			"Make some room and talk to me again."
		}
	else
		message {
			"Here's a bronze hatchet.",
			"Let's cut down some of those trees!"
		}
	end

	showEquipTutorial()
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

			showCraftingTutorial()
		else
			message {
				"I can't give you a %item{knife} because your bag is full!",
				"Make some room by dropping an item and then talk to me."
			}

			_TARGET:removeBehavior(DisabledBehavior)
		end
	else
		message {
			"Let's not get ahead of ourselves!",
			"We need to chop some logs to repair the ship."
		}

		_TARGET:removeBehavior(DisabledBehavior)
	end
elseif not _TARGET:getState():has("KeyItem", "PreTutorial_CraftedWeapon") then
	message {
		"We should probably craft you a weapon.",
		"Only %empty{Fate} knows what's further along!"
	}
elseif not _TARGET:getState():has("KeyItem", "PreTutorial_CookedFish") then
	message "We should cook the fish."
end
