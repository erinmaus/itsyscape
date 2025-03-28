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
Common.HINT_WAIT_SHUFFLE_TIME = 2

Common.WAIT_OPEN_FUNCTION = function(target, state)
	state.time = nil

	return function()
		state.time = state.time or (love.timer.getTime() + Common.HINT_WAIT_TIME)
		return love.timer.getTime() > state.time or (state.ui and not Utility.UI.isOpen(target, state.ui))
	end
end

Common.CONTROLS_UI_MOVE_CLASSES = {
	position = "up",
	id = "NewPlayer-Classes",
	message = {
		gamepad = {
			button = "leftstick",
			action = { "none", "horizontal" },
			speed = Common.HINT_WAIT_SHUFFLE_TIME / 4,
			label = "Left stick to select"
		},
		standard = {
			button = "mouse_left",
			controller = "KeyboardMouse",
			label = "Left click to select"
		},
		mobile = {
			button = "tap",
			controller = "Touch",
			label = "Tap to select"
		}
	},
	open = Common.WAIT_OPEN_FUNCTION
}

Common.CONTROLS_UI_MOVE_DIALOG = {
	position = "up",
	id = "DialogBox",
	message = {
		gamepad = {
			button = "leftstick",
			action = { "none", "vertical" },
			speed = Common.HINT_WAIT_SHUFFLE_TIME / 4,
			label = "Left stick to select"
		},
		standard = {
			button = "mouse_left",
			controller = "KeyboardMouse",
			label = "Left click to select"
		},
		mobile = {
			button = "tap",
			controller = "Touch",
			label = "Tap to select"
		}
	},
	open = Common.WAIT_OPEN_FUNCTION
}

Common.CONTROLS_MOVE_HINT = {
	position = "center",
	id = "root",
	message = {
		gamepad = {
			button = "leftstick",
			action = { "left", "up", "right", "down"},
			speed = Common.HINT_WAIT_SHUFFLE_TIME / 4,
			label = "Left stick to move"
		},
		standard = {
			button = { "keyboard_w", "keyboard_a", "keyboard_s", "keyboard_d" },
			controller = "KeyboardMouse",
			label = "WASD to move"
		},
		mobile = {
			button = "tap",
			controller = "Touch",
			label = "Tap to move"
		}
	},
	open = Common.WAIT_OPEN_FUNCTION
}

Common.CONTROLS_CAMERA_HINT = {
	position = "center",
	id = "root",
	message = {
		gamepad = {
			button = "rightstick",
			action = { "left", "up", "right", "down"},
			speed = Common.HINT_WAIT_SHUFFLE_TIME / 4,
			label = "Right stick to move camera"
		},
		standard = {
			button = { "mouse_scroll", "keyboard_arrows" },
			controller = "KeyboardMouse",
			speed = Common.HINT_WAIT_SHUFFLE_TIME / 2,
			label = "Middle mouse button or arrow keys to move camera"
		},
		mobile = {
			button = "tap",
			controller = "Touch",
			label = "Tap and hold to move camera"
		}
	},
	open = Common.WAIT_OPEN_FUNCTION
}

Common.CONTROLS_INTERACT_HINT = {
	position = "center",
	id = "root",
	message = {
		gamepad = {
			button = { "a", "x" },
			speed = Common.HINT_WAIT_TIME / 2,
			label = {
				a = { "ui.text", "To perform action" },
				x = { "ui.text", "To switch target" }
			}
		},
		standard = {
			button = "mouse_left",
			controller = "KeyboardMouse",
			label = "To interact"
		},
		mobile = {
			button = "tap",
			controller = "Touch",
			label = "Tap to interact"
		}
	},
	open = Common.WAIT_OPEN_FUNCTION
}

Common.CONTROLS_POKE_HINT = {
	position = "center",
	id = "root",
	message = {
		gamepad = {
			button = "y",
			label = "To see more options"
		},
		standard = {
			button = "mouse_right",
			controller = "KeyboardMouse",
			speed = Common.HINT_WAIT_SHUFFLE_TIME / 2,
			label = "To see more options"
		},
		mobile = {
			button = "tap",
			controller = "Touch",
			label = "Long tap to see more options"
		}
	},
	open = Common.WAIT_OPEN_FUNCTION
}

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
				local hasIsabelliumItemOnGround = Common.hasPeepDroppedIsabellium(target)
				local hasEquippedFullIsabellium = Common.hasPeepEquippedFullIsabellium(target)

				state.hasEquippedFullIsabellium = hasEquippedFullIsabellium
				state.hasIsabelliumItemOnGround = hasIsabelliumItemOnGround
				state.time = state.time or (love.timer.getTime() + Common.HINT_WAIT_TIME)

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
				local hasIsabelliumItem = Common.peepHasIsabelliumInInventory(target)

				state.time = state.time or (love.timer.getTime() + Common.HINT_WAIT_TIME)
				return state.hasEquippedFullIsabellium or not hasIsabelliumItem or love.timer.getTime() > state.time
			end
		end
	},
}

function Common.showNewPlayerUIHint(playerPeep, done)
	Utility.UI.tutorial(playerPeep, { Common.CONTROLS_UI_MOVE_CLASSES }, done, { ui = "DemoNewPlayer" })
end

function Common.showDialogUIHint(playerPeep, done)
	Utility.UI.tutorial(playerPeep, { Common.CONTROLS_UI_MOVE_DIALOG }, done, { ui = "DialogBox" })
end

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
	Utility.Peep.enable(playerPeep)
end

function Common.showEquipHint(playerPeep, done)
	Utility.UI.openInterface(
		playerPeep,
		"TutorialHint",
		false,
		Common.EQUIP_HINT.id,
		Common.EQUIP_HINT.message,
		Common.EQUIP_HINT.open(playerPeep, {}),
		{ position = Common.EQUIP_HINT.position, style = Common.EQUIP_HINT.style },
		done)
end

function Common.showBasicControlsHint(playerPeep, done)
	local hints = {
		Common.CONTROLS_MOVE_HINT,
		Common.CONTROLS_INTERACT_HINT
	}

	Utility.UI.tutorial(playerPeep, hints, done)
	Utility.Peep.enable(playerPeep)
end

function Common.showMovementControlsHint(playerPeep, done)
	local hints = {
		Common.CONTROLS_MOVE_HINT,
		Common.CONTROLS_CAMERA_HINT
	}

	Utility.UI.tutorial(playerPeep, hints, done)
	Utility.Peep.enable(playerPeep)
end

function Common.peepHasIsabelliumInInventory(playerPeep)
	local inventory = Utility.Peep.getInventory(playerPeep)
	for _, item in ipairs(inventory) do
		if item:getID():match("^Isabellium") then
			return true
		end
	end

	return false
end

function Common.hasPeepEquippedFullIsabellium(playerPeep)
	local equippedItems = {
		Utility.Peep.getEquippedItem(playerPeep, Equipment.PLAYER_SLOT_HEAD) or false,
		Utility.Peep.getEquippedItem(playerPeep, Equipment.PLAYER_SLOT_BODY) or false,
		Utility.Peep.getEquippedItem(playerPeep, Equipment.PLAYER_SLOT_FEET) or false,
		Utility.Peep.getEquippedItem(playerPeep, Equipment.PLAYER_SLOT_HANDS) or false,
		Utility.Peep.getEquippedItem(playerPeep, Equipment.PLAYER_SLOT_TWO_HANDED) or false,
	}

	for _, item in ipairs(equippedItems) do
		if not item or not item:getID():match("^Isabellium") then
			return false
		end
	end

	return true
end

function Common.hasPeepDroppedItems(playerPeep, pattern)
	local stage = playerPeep:getDirector():getGameInstance():getStage()
	local broker = playerPeep:getDirector():getItemBroker()

	local layer = Utility.Peep.getLayer(playerPeep)
	local ground = stage:getGround(layer)
	if not ground then
		Log.warnOnce("Cannot update gather item step; no ground for layer '%d' (player = '%s').", layer, playerPeep:getName())
		return
	end

	local inventory = Utility.Peep.getInventory(ground)
	local filteredInventory = {}
	local hasDroppedItem = false
	for _, item in ipairs(inventory) do
		local owner = broker:getItemTag(item, "owner")
		if owner == playerPeep and (not pattern or item:getID():match(pattern)) then
			table.insert(filteredInventory, item)
			hasDroppedItem = true
		end
	end

	return hasDroppedItem, filteredInventory
end

function Common.hasPeepDroppedIsabellium(playerPeep)
	return Common.hasPeepDroppedItems(playerPeep, "^Isabellium")
end

function Common.listenForAttack(playerPeep, done)
	local director = playerPeep:getDirector()

	local scout = director:probe(
		playerPeep:getLayerName(),
		Probe.namedMapObject("YendorianScout"),
		Probe.instance(Utility.Peep.getPlayerModel(playerPeep)))[1]

	local orlando = director:probe(
		playerPeep:getLayerName(),
		Probe.namedMapObject("Orlando"),
		Probe.instance(Utility.Peep.getPlayerModel(playerPeep)))[1]

	local knightCommander = director:probe(
		playerPeep:getLayerName(),
		Probe.namedMapObject("KnightCommander"),
		Probe.instance(Utility.Peep.getPlayerModel(playerPeep)))[1]

	local scoutTarget
	if scout then
		local position = Utility.Peep.getPosition(scout)
		scoutTarget = Utility.spawnPropAtPosition(scout, "Target_Default", position.x, position.y, position.z)
		scoutTarget = scoutTarget and scoutTarget:getPeep()

		if scoutTarget then
			scoutTarget:setTarget(scout, "Attack the scout!")
		end

		local function postReceiveAttack()
			if orlando and not orlando:hasBehavior(CombatTargetBehavior) then
				Utility.Peep.attack(orlando, scout, math.huge)
				Utility.Peep.setMashinaState(orlando, "tutorial-attack-general")
			end

			if knightCommander and not knightCommander:hasBehavior(CombatTargetBehavior) then
				Utility.Peep.attack(knightCommander, scout, math.huge)
				Utility.Peep.setMashinaState(knightCommander, "tutorial-attack-general")
			end

			scout:silence("postReceiveAttack", postReceiveAttack)
		end

		scout:listen("postReceiveAttack", postReceiveAttack)
	end

	local numTimesAttacked = 0
	local previousTarget = nil

	local SPAM_MESSAGE_THRESHOLD = 3

	local notifiedPlayer = false

	local silence

	local function die()
		previousTarget:silence("die", die)

		silence()

		if done then
			done()
		end

		if orlando then
			Utility.Peep.setMashinaState(knightCommander, "tutorial-follow-player")
		end

		if knightCommander then
			Utility.Peep.setMashinaState(knightCommander, "tutorial-follow-player")
		end

		local mapScript = Utility.Peep.getMapScript(playerPeep)
		if mapScript then
			mapScript:pushPoke("finishPreparingTutorial", playerPeep)
		end
	end

	local function performAttackAction(_, e)
		if e.action:is("Attack") then
			if numTimesAttacked == 0 then
				Utility.Peep.notify(playerPeep, "You'll automatically deal blows until one of you is slain.")
			end

			numTimesAttacked = numTimesAttacked + 1

			if numTimesAttacked > SPAM_MESSAGE_THRESHOLD then
				numTimesAttacked = 1

				Utility.Peep.notify(playerPeep, "You don't need to keep engaging! That's not going to work!", notifiedPlayer)
				notifiedPlayer = true
			end
		end
	end

	local function performInitiateAttack()
		if scoutTarget then
			Utility.Peep.poof(scoutTarget)
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

return Common
