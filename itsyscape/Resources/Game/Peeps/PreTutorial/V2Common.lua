--------------------------------------------------------------------------------
-- Resources/Game/Peeps/PreTutorial/V2Common.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local Common = {}

Common.HINT_WAIT_TIME = 5

local INVENTORY_FLAGS = {
	['item-inventory'] = true
}

local EQUIPMENT_FLAGS = {
	['item-equipment'] = true
}

Common.EQUIP_BRONZE_HATCHET = {
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
				return target:getState():has('Item', "BronzeHatchet", 1, EQUIPMENT_FLAGS)
			end
		end
	}
}

Common.EQUIP_TOY_WAND = {
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
		id = "Inventory-ToyWand",
		message = not _MOBILE and "Click on the wand to equip it." or "Tap on the wand to equip it.",
		open = function(target)
			return function()
				return target:getState():has('Item', "ToyWand", 1, EQUIPMENT_FLAGS)
			end
		end
	}
}

Common.EQUIP_TOY_LONGSWORD = {
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
		id = "Inventory-ToyLongsword",
		message = not _MOBILE and "Click on the longsword to equip it." or "Tap on the longsword to equip it.",
		open = function(target)
			return function()
				return target:getState():has('Item', "ToyLongsword", 1, EQUIPMENT_FLAGS)
			end
		end
	}
}

Common.EQUIP_TOY_BOOMERANG = {
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
		id = "Inventory-ToyBoomerang",
		message = not _MOBILE and "Click on the boomerang to equip it." or "Tap on the boomerang to equip it.",
		open = function(target)
			return function()
				return target:getState():has('Item', "ToyBoomerang", 1, EQUIPMENT_FLAGS)
			end
		end
	}
}

Common.CRAFT_TOY_WEAPON = {
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
		open = function(target, state)
			return function()
				state.time = state.time or love.timer.getTime()
				return not Utility.UI.isOpen(target, "CraftWindow") or love.timer.getTime() > state.time + Common.HINT_WAIT_TIME
			end
		end
	},
	{
		position = 'up',
		id = "Craft-QuantityInput",
		message = "Double check to make sure you're making the right amount of things!",
		open = function(target, state)
			return function()
				state.time = state.time or love.timer.getTime()
				return not Utility.UI.isOpen(target, "CraftWindow") or love.timer.getTime() > state.time + Common.HINT_WAIT_TIME
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
	}
}

function Common.startRibbonTutorial(playerPeep, tutorial, ui, done)
	local state = {}
	Utility.UI.openInterface(
		playerPeep,
		"TutorialHint",
		false,
		"root",
		not _MOBILE and "Look at the bottom right corner.\nClick on the flashing icon to continue." or "Look at the bottom right corner.\nTap on the flashing icon to continue.",
		function(target)
			state.time = state.time or love.timer.getTime()
			return love.timer.getTime() > state.time + Common.HINT_WAIT_TIME or (ui and Utility.UI.isOpen(playerPeep, ui))
		end,
		{ position = 'center' })

	Utility.UI.tutorial(playerPeep, tutorial, done)
end

function Common.listenForAction(playerPeep, action, target, firstMessage, otherMessage)
	local numTimesChopped = 0

	local SPAM_MESSAGE_THRESHOLD = 3

	local notifiedPlayer = false

	local function _performAction(_, e)
		if e.action:is(action) then
			if numTimesChopped == 0 then
				Utility.Peep.notify(playerPeep, firstMessage)
			end

			numTimesChopped = numTimesChopped + 1
			if numTimesChopped > SPAM_MESSAGE_THRESHOLD then
				numTimesChopped = 1

				Utility.Peep.notify(playerPeep, otherMessage, notifiedPlayer)
				notifiedPlayer = true
			end

			if target then
				Utility.Peep.poof(target)
			end
		end
	end

	local function _move()
		playerPeep:silence("actionPerformed", _performAction)
		playerPeep:silence("move", _move)
		playerPeep:silence("resourceObtained", _move)
	end

	playerPeep:listen("actionPerformed", _performAction)
	playerPeep:listen("resourceObtained", _move)
	playerPeep:listen("move", _move)
end

function Common.listenForAttack(playerPeep)
	local director = playerPeep:getDirector()

	local maggots = director:probe(
		playerPeep:getLayerName(),
		Probe.resource("Peep", "PreTutorial_Maggot"))

	table.sort(maggots, function(a, b)
		local aDistance = (Utility.Peep.getPosition(a) - Utility.Peep.getPosition(playerPeep)):getLengthSquared()
		local bDistance = (Utility.Peep.getPosition(b) - Utility.Peep.getPosition(playerPeep)):getLengthSquared()

		return aDistance < bDistance
	end)

	local maggot = maggots[1]
	local maggotTarget
	if maggot then
		local position = Utility.Peep.getPosition(maggot)
		maggotTarget = Utility.spawnPropAtPosition(maggot, "Target_Default", position.x, position.y, position.z)
		maggotTarget = maggotTarget and maggotTarget:getPeep()

		if maggotTarget then
			maggotTarget:setTarget(maggot, _MOBILE and "Tap the maggot to attack it!" or "Click on the maggot to attack it!")
		end
	end

	local numTimesAttacked = 0
	local previousTarget = nil

	local SPAM_MESSAGE_THRESHOLD = 3

	local notifiedPlayer = false

	local silence

	local function die()
		previousTarget:silence("die", die)

		playerPeep:getState():give("KeyItem", "PreTutorial_KilledMaggot")
		silence()
	end

	local function performAttackAction(_, e)
		if e.action:is("Attack") then
			if numTimesAttacked == 0 then
				Utility.Peep.notify(playerPeep, "You'll automatically deal blows until the foe is slain.")
			end

			numTimesAttacked = numTimesAttacked + 1

			if numTimesAttacked > SPAM_MESSAGE_THRESHOLD then
				numTimesAttacked = 1

				Utility.Peep.notify(playerPeep, _MOBILE and "You only need to tap once to attack!" or "You only need to click once to attack!", notifiedPlayer)
				notifiedPlayer = true
			end
		end
	end

	local function performInitiateAttack()
		if maggotTarget then
			Utility.Peep.poof(maggotTarget)
		end

		local currentTarget = playerPeep:getBehavior(CombatTargetBehavior)
		currentTarget = currentTarget and currentTarget.actor and currentTarget.actor:getPeep()

		if previousTarget ~= currentTarget then
			if previousTarget then
				previousTarget:silence("die", die)
			end

			if currentTarget then
				currentTarget:listen("die", die)
			end

			previousTarget = currentTarget
			numTimesAttacked = 1
		end
	end

	silence = function()
		playerPeep:silence("actionPerformed", performAttackAction)
		playerPeep:silence("initiateAttack", performInitiateAttack)
		playerPeep:silence("move", silence)
	end

	playerPeep:listen("actionPerformed", performAttackAction)
	playerPeep:listen("initiateAttack", performInitiateAttack)
end

function Common.makeRosalindTalk(playerPeep, name)
	local director = playerPeep:getDirector()
	local game = director:getGameInstance()
	local gameDB = director:getGameDB()

	local rosalind = director:probe(
		playerPeep:getLayerName(),
		Probe.resource("Peep", "IsabelleIsland_Rosalind"))[1]

	if not rosalind then
		return
	end

	local mapObjectResource = Utility.Peep.getMapObject(rosalind)
	if not mapObjectResource then
		return
	end

	local namedAction = gameDB:getRecord("NamedPeepAction", {
		Name = name,
		Peep = mapObjectResource
	})

	if not namedAction then
		return
	end

	local action = Utility.getAction(game, namedAction:get("Action"), false, false)
	if not action then
		return
	end


	Utility.UI.openInterface(playerPeep, "DialogBox", true, action.instance, rosalind)
end

function Common.startDropItemTutorial(playerPeep, done)
	local inventory = playerPeep:getBehavior(InventoryBehavior)
	inventory = inventory and inventory.inventory
	if not inventory then
		return
	end

	local broker = inventory:getBroker()
	local count = broker:countItems(inventory)
	if count < inventory:getMaxInventorySpace() then
		-- The player has available room.
		return
	end

	local itemToDrop
	do
		local itemCounts = {}
		for item in broker:iterateItems(inventory) do
			local id = item:getID()
			local count = itemCounts[id] or 0
			count = count + 1

			if count >= 2 then
				itemToDrop = item
				break
			end

			itemCounts[id] = count
		end
	end

	if not itemToDrop then
		-- Try and drop last item in inventory.
		for item in broker:iterateItems(inventory) do
			itemToDrop = item
		end
	end

	if not itemToDrop then
		-- ???
		Log.warn("Player '%s' doesn't have any items to drop...?")
		return
	end

	local itemName = Utility.Item.getInstanceName(itemToDrop)

	local tutorial = {
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
			id = string.format("Inventory-%s", itemToDrop:getID()),
			message = not _MOBILE and "Right-click on the item to open the poke menu." or "Long tap on the item to open the poke menu.",
			open = function(target)
				return function()
					if broker:countItems(inventory) < inventory:getMaxInventorySpace() then
						return true
					end

					local open, index = Utility.UI.isOpen(target, "PlayerInventory")
					if open then
						local interface = Utility.UI.getOpenInterface(target, "PlayerInventory", index)
						return interface.lastProbedItem and interface.lastProbedItem:getID() == itemToDrop:getID()
					end

					return true
				end
			end
		},
		{
			position = 'up',
			id = string.format("PokeMenu-Drop-%s", itemName),
			message = not _MOBILE and "Click on the drop action option to drop the item." or "Tap on the drop action to drop the item.",
			open = function(target)
				return function()
					if broker:countItems(inventory) < inventory:getMaxInventorySpace() then
						return true
					end

					local open, index = Utility.UI.isOpen(target, "PlayerInventory")
					if open then
						local interface = Utility.UI.getOpenInterface(target, "PlayerInventory", index)
						return not interface.lastProbedItem or interface.lastProbedItem:getID() ~= itemToDrop:getID()
					end

					return true
				end
			end
		}
	}

	Common.startRibbonTutorial(playerPeep, tutorial, "PlayerInventory", done)
end

return Common
