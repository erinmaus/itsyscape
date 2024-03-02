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

local Common = {}

Common.HINT_WAIT_TIME = 5

local INVENTORY_FLAGS = {
	['item-inventory'] = true
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
				return not target:getState():has('Item', "BronzeHatchet", 1, INVENTORY_FLAGS)
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
		end

		if target then
			Utility.Peep.poof(target)
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

return Common
