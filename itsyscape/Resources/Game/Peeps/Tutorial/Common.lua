--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Tutorial/Common.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local Probe = require "ItsyScape.Peep.Probe"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local Common = {}

Common.HINT_WAIT_TIME = 4

Common.EQUIP_HINT = {
	position = "center",
	id = "root",
	message = {
		gamepad = {
			button = "start",
			label = "Open ribbon"
		},
		standard = {
			button = "mouse_left",
			controller = "KeyboardMouse",
			label = "Look at the bottom right corner.\nClick on the inventory tab to continue."
		},
		mobile = {
			button = "tap",
			controller = "Touch",
			label = "Look at the bottom right corner.\nTap on the inventory tab to continue."
		}
	},
	open = function(target, state)
		state.time = love.timer.getTime() + Common.HINT_WAIT_TIME

		return function()
			local gamepadRibbonInterface = Utility.UI.getOpenInterface(target, "GamepadRibbon")
			local isGamepadRibbonOpen = gamepadRibbonInterface and gamepadRibbonInterface:getIsOpen()
			local isMouseRibbonOpen = Utility.UI.isOpen(target, "PlayerInventory")

			return love.timer.getTime() > state.time or isGamepadRibbonOpen or isMouseRibbonOpen
		end
	end
}

Common.EQUIP_GEAR = {
	{
		position = {
			gamepad = "center",
			standard = "up",
			mobile = "up"
		},
		id = {
			gamepad = "root",
			standard = "Ribbon-PlayerInventory",
			mobile = "Ribbon-PlayerInventory"
		},
		message = {
			gamepad = {
				button = "start",
				label = "Open ribbon"
			},
			standard = {
				button = "mouse_left",
				controller = "KeyboardMouse",
				label = "Open inventory tab"
			},
			mobile = {
				button = "tap",
				controller = "Touch",
				label = "Open inventory tab"
			}
		},
		open = function(target, state)
			return function()
				local gamepadRibbonInterface = Utility.UI.getOpenInterface(target, "GamepadRibbon")
				local isGamepadRibbonOpen = gamepadRibbonInterface and gamepadRibbonInterface:getIsOpen()
				local isMouseRibbonOpen = Utility.UI.isOpen(target, "PlayerInventory")

				state.wasGamepadRibbonOpen = isGamepadRibbonOpen
				state.wasMouseRibbonOpen = isMouseRibbonOpen

				return isGamepadRibbonOpen or isMouseRibbonOpen
			end
		end
	},
	{
		id = function(target, state)
			return function()
				local gamepadRibbonInterface = Utility.UI.getOpenInterface(target, "GamepadRibbon")
				local isGamepadRibbonOpen = gamepadRibbonInterface and gamepadRibbonInterface:getIsOpen()
				local isMouseRibbonOpen = Utility.UI.isOpen(target, "PlayerInventory")

				if not (isGamepadRibbonOpen or isMouseRibbonOpen) then
					return {
						gamepad = "root",
						standard = "Ribbon-PlayerInventory",
						mobile = "Ribbon-PlayerInventory"
					}
				end

				if isGamepadRibbonOpen and gamepadRibbonInterface:getCurrentTab() ~= gamepadRibbonInterface.TAB_PLAYER_INVENTORY then
					return "GamepadRibbon-PlayerInventory"
				end

				local inventory = Utility.Peep.getInventory(target)

				local firstIsabelliumItem
				local hasCurrentIsabelliumItem = false
				for _, item in ipairs(inventory) do
					if not firstIsabelliumItem and item:getID():match("^Isabellium") then
						firstIsabelliumItem = item
					end

					if state.currentIsabelliumItem and state.currentIsabelliumItem:getID() == item:getID() then
						hasCurrentIsabelliumItem = true
					end
				end

				local isabelliumItemID
				if hasCurrentIsabelliumItem then
					isabelliumItemID = state.currentIsabelliumItem:getID()
				elseif firstIsabelliumItem then
					isabelliumItemID = firstIsabelliumItem:getID()
					state.currentIsabelliumItem = firstIsabelliumItem
				end

				local id = string.format("Inventory-Item-%s", isabelliumItemID)

				return {
					gamepad = id,
					standard = id,
					mobile = id
				}
			end
		end,
		message = function(target, state)
			return function()
				local gamepadRibbonInterface = Utility.UI.getOpenInterface(target, "GamepadRibbon")
				local isGamepadRibbonOpen = gamepadRibbonInterface and gamepadRibbonInterface:getIsOpen()
				local isMouseRibbonOpen = Utility.UI.isOpen(target, "PlayerInventory")

				if not (isGamepadRibbonOpen or isMouseRibbonOpen) or (isGamepadRibbonOpen and gamepadRibbonInterface:getCurrentTab() ~= gamepadRibbonInterface.TAB_PLAYER_INVENTORY) then
					return {
						gamepad = {
							button = "leftshoulder",
							label = "Open inventory"
						},

						standard = {
							button = "mouse_left",
							controller = "KeyboardMouse",
							label = "Open inventory tab"
						},

						mobile = {
							button = "tap",
							controller = "Touch",
							label = "Open inventory tab"
						}
					}
				end

				local text
				if state.currentIsabelliumItem then
					text = {
						{ 1, 1, 1, 1},
						"Equip",
						{ 1, 1, 1, 1},
						" ",
						"ui.poke.item",
						Utility.Item.getInstanceName(state.currentIsabelliumItem)
					}
				else
					text = "Equip"
				end

				return {
					gamepad = {
						button = "a",
						label = text
					},

					standard = {
						button = "mouse_left",
						controller = "KeyboardMouse",
						label = text
					},

					mobile = {
						button = "tap",
						controller = "Touch",
						label = text
					}
				}
			end
		end,
		position = function(target, state)
			local gamepadRibbonInterface = Utility.UI.getOpenInterface(target, "GamepadRibbon")
			local isGamepadRibbonOpen = gamepadRibbonInterface and gamepadRibbonInterface:getIsOpen()
			local isMouseRibbonOpen = Utility.UI.isOpen(target, "PlayerInventory")

			if not (isGamepadRibbonOpen or isMouseRibbonOpen) then
				return {
					gamepad = "center",
					standard = "up",
					mobile = "up"
				}
			end

			return "up"
		end,
		open = function(target, state)
			return function()
				local gamepadRibbonInterface = Utility.UI.getOpenInterface(target, "GamepadRibbon")
				local isGamepadRibbonOpen = gamepadRibbonInterface and gamepadRibbonInterface:getIsOpen()
				local isMouseRibbonOpen = Utility.UI.isOpen(target, "PlayerInventory")

				local inventory = Utility.Peep.getInventory(target)

				local hasIsabelliumItem = false
				for _, item in ipairs(inventory) do
					if item:getID():match("^Isabellium") then
						hasIsabelliumItem = true
					end
				end

				local gamepadRibbonInterface = Utility.UI.getOpenInterface(target, "GamepadRibbon")
				local isGamepadRibbonOpen = gamepadRibbonInterface and gamepadRibbonInterface:getIsOpen()
				local isMouseRibbonOpen = Utility.UI.isOpen(target, "PlayerInventory")

				return (state.wasGamepadRibbonOpen and not isGamepadRibbonOpen) or not hasIsabelliumItem
			end
		end
	},
	{
		position =  "center",
		id = "root",
		message = {
			gamepad = {
				button = "none",
				label = "Looks like you dropped some of your gear!\nYou'll need to pick it up and equip it to continue.",
			},
			standard = {
				button = "none",
				label = "Looks like you dropped some of your gear!\nYou'll need to pick it up and equip it to continue.",
			},
			{
				button = "none",
				label = "Looks like you dropped some of your gear!\nYou'll need to pick it up and equip it to continue.",
			}
		},
		open = function(target, state)
			Utility.Peep.enable(target)

			return function()
				local director = target:getDirector()
				local stage = director:getGameInstance():getStage()
				local broker = director:getItemBroker()

				local ground = stage:getGround(Utility.Peep.getLayer(target))
				local items = ground and Utility.Peep.getInventory(ground)

				local hasIsabelliumItemOnGround = false
				if items then
					for _, item in ipairs(items) do
						local owner = broker:getItemTag(item, "owner")
						if owner == target and item:getID():match("^Isabellium") then
							hasIsabelliumItemOnGround = true
							break
						end
					end
				end

				local equippedItems = {
					Utility.Peep.getEquippedItem(target, Equipment.PLAYER_SLOT_HEAD) or false,
					Utility.Peep.getEquippedItem(target, Equipment.PLAYER_SLOT_BODY) or false,
					Utility.Peep.getEquippedItem(target, Equipment.PLAYER_SLOT_FEET) or false,
					Utility.Peep.getEquippedItem(target, Equipment.PLAYER_SLOT_HANDS) or false,
					Utility.Peep.getEquippedItem(target, Equipment.PLAYER_SLOT_TWO_HANDED) or false,
				}

				local hasEquippedFullIsabellium = true
				for _, item in ipairs(equippedItems) do
					if not item or not item:getID():match("^Isabellium") then
						hasEquippedFullIsabellium = false
						break
					end
				end

				state.hasEquippedFullIsabellium = hasEquippedFullIsabellium
				state.hasIsabelliumItemOnGround = hasIsabelliumItemOnGround
				state.time = state.time or (love.timer.getTime() + Common.HINT_WAIT_TIME)

				print("hasEquippedFullIsabellium", hasEquippedFullIsabellium, "not hasIsabelliumItemOnGround", not hasIsabelliumItemOnGround, "currentTime > startTime", love.timer.getTime() > state.time)
				return hasEquippedFullIsabellium or not hasIsabelliumItemOnGround or love.timer.getTime() > state.time
			end
		end
	},
	{
		position =  "center",
		id = "root",
		message = {
			gamepad = {
				button = "none",
				label = "Looks like you still need to equip some gear to continue!",
			},
			standard = {
				button = "none",
				label = "Looks like you still need to equip some gear to continue!",
			},
			{
				button = "none",
				label = "Looks like you still need to equip some gear to continue!",
			}
		},
		open = function(target, state)
			return function()
				local inventory = Utility.Peep.getInventory(target)

				local hasIsabelliumItem = false
				for _, item in ipairs(inventory) do
					if item:getID():match("^Isabellium") then
						hasIsabelliumItem = true
					end
				end

				state.time = state.time or (love.timer.getTime() + Common.HINT_WAIT_TIME)
				return state.hasEquippedFullIsabellium or not hasIsabelliumItem or love.timer.getTime() > state.time
			end
		end
	},
}

function Common.startRibbonTutorial(playerPeep, open)
	local state = {}
	Utility.UI.openInterface(
		playerPeep,
		"TutorialHint",
		false,
		{
			standard = "root",
			mobile = "root"
		},
		{
			gamepad = false,
			standard = {
				button = "none",
				controller = "KeyboardMouse",
				label = "Look at the bottom right corner.\nClick on the flashing icon to continue."
			},
			mobile = {
				button = "none",
				controller = "Touch",
				label = "Look at the bottom right corner.\nTap on the flashing icon to continue."
			}
		},
		function(target)
			state.time = state.time or love.timer.getTime()
			return love.timer.getTime() > state.time + Common.HINT_WAIT_TIME or (open and open())
		end,
		{ position = "center" })
end

function Common.startEquipTutorial(playerPeep, done)
	Common.startRibbonTutorial(playerPeep, Common.EQUIP_GEAR[1].open(playerPeep, {}))
	Utility.UI.tutorial(playerPeep, Common.EQUIP_GEAR, done)
end

function Common.showEquipHint(playerPeep, done)
	Utility.UI.openInterface(
		playerPeep,
		"TutorialHint",
		false,
		Common.EQUIP_HINT.id,
		Common.EQUIP_HINT.message,
		Common.EQUIP_HINT.open(playerPeep, state),
		{ position = Common.EQUIP_HINT.position, style = Common.EQUIP_HINT.style },
		done)
end

return Common
