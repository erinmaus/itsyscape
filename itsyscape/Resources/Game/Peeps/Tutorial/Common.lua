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
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

local Common = {}

Common.HINT_WAIT_TIME = 4
Common.HINT_WAIT_SHUFFLE_TIME = 2

Common.WAIT_OPEN_FUNCTION = function(t, f)
	t = t or Common.HINT_WAIT_TIME

	return function(target, state)
		state.time = nil

		if f then
			f = f(target, state)
		end

		return function()
			if f and f() then
				return true
			end

			state.time = state.time or (love.timer.getTime() + t)
			return love.timer.getTime() > state.time or (state.ui and not Utility.UI.isOpen(target, state.ui))
		end
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
	open = Common.WAIT_OPEN_FUNCTION()
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
	open = Common.WAIT_OPEN_FUNCTION()
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
	open = Common.WAIT_OPEN_FUNCTION()
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
	open = Common.WAIT_OPEN_FUNCTION()
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
	open = Common.WAIT_OPEN_FUNCTION()
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
	open = Common.WAIT_OPEN_FUNCTION()
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
		return false, {}
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

function Common._attackTutorialPerformAttackAction(state, _, e)
	if e.action:is("Attack") then
		if state.numTimesAttacked == 0 then
			Utility.Peep.notify(state.player, "You'll automatically deal blows until one of you is slain.")
		end

		state.numTimesAttacked = state.numTimesAttacked + 1

		if state.numTimesAttacked > state.spamMessageThreshold then
			state.numTimesAttacked = 1

			Utility.Peep.notify(state.player, "You don't need to keep engaging! That's not going to work!", state.notifiedPlayer)
			state.notifiedPlayer = true
		end
	end
end

function Common._attackTutorialPerformInitiateAttack(state)
	if state.scoutTarget then
		Utility.Peep.poof(state.scoutTarget)
	end

	local currentTarget = state.player:getBehavior(CombatTargetBehavior)
	currentTarget = currentTarget and currentTarget.actor and currentTarget.actor:getPeep()

	if state.previousTarget ~= currentTarget then
		if state.previousTarget then
			state.previousTarget:silence("die", Common._attackTutorialDie)
		end

		if currentTarget then
			currentTarget:listen("die", Common._attackTutorialDie, state)
		end

		state.previousTarget = currentTarget
		state.numTimesAttacked = 1
	end
end

function Common._attackTutorialSilence(state)
	state.player:silence("actionPerformed", Common._attackTutorialPerformAttackAction)
	state.player:silence("initiateAttack", Common._attackTutorialPerformInitiateAttack)
	state.player:silence("move", Common._attackTutorialSilence)
end

function Common._attackTutorialDie(state)
	if state.previousTarget then
		state.previousTarget:silence("die", Common._attackTutorialDie)
	end

	Common._attackTutorialSilence(state)

	if state.done then
		state.done()
	end

	local mapScript = Utility.Peep.getMapScript(state.player)
	if mapScript then
		mapScript:pushPoke("finishPreparingTutorial", state.player)
	end
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

	local state = {
		player = playerPeep,
		scout = scout,
		orlando = orlando,
		knightCommander = knightCommander,
		numTimesAttacked = 0,
		previousTarget = false,
		spamMessageThreshold = 3,
		notifiedPlayer = false,
		done = done
	}

	local scoutTarget
	if scout then
		local position = Utility.Peep.getPosition(scout)
		scoutTarget = Utility.spawnPropAtPosition(scout, "Target_Default", position.x, position.y, position.z)
		scoutTarget = scoutTarget and scoutTarget:getPeep()

		if scoutTarget then
			scoutTarget:setTarget(scout, "Attack the scout!")
		end

		state.scoutTarget = scoutTarget
	end

	playerPeep:listen("actionPerformed", Common._attackTutorialPerformAttackAction, state)
	playerPeep:listen("initiateAttack", Common._attackTutorialPerformInitiateAttack, state)
	playerPeep:listen("move", Common._attackTutorialSilence, state)
end

function Common._fishTutorialPerformFishAction(state, _, e)
	if e.action:is("Fish") then
		Utility.Peep.poof(state.fishTarget)

		if state.numTimesFished == 0 then
			Utility.Peep.notify(state.player, "You'll automatically fish until you catch the fish or run out of bait.")
		end

		state.numTimesFished = state.numTimesFished + 1

		if state.numTimesFished > state.spamMessageThreshold then
			state.numTimesAttacked = 1

			Utility.Peep.notify(state.player, "You don't need to keep trying to fish! That won't work!", state.notifiedPlayer)
			state.notifiedPlayer = true
		end
	end
end

function Common._fishTutorialSilence(state)
	state.player:silence("actionPerformed", Common._fishTutorialPerformFishAction)
	state.player:silence("resourceObtained", Common._fishTutorialSilence)
	state.player:silence("move", Common._fishTutorialSilence)
end


function Common.listenForFish(playerPeep, done)
	local director = playerPeep:getDirector()

	local fish = director:probe(
		playerPeep:getLayerName(),
		Probe.resource("Prop", "LightningStormfish_Default"))

	local fishTargets = director:probe(
		playerPeep:getLayerName(),
		Probe.resource("Prop", "Target_Default"),
		Probe.instance(Utility.Peep.getPlayerModel(playerPeep)))

	for _, target in ipairs(fishTargets) do
		Utility.Peep.poof(target)
	end

	local specificFish
	for _, f in ipairs(fish) do
		local health = f:getBehavior(PropResourceHealthBehavior)
		if health and health.currentProgress < health.maxProgress then
			specificFish = f
			break
		end
	end

	-- Fallback if all stormfish are somehow fished.
	specificFish = f or fish[love.math.random(#fish)]

	local state = {
		player = playerPeep,
		fish = specificFish,
		numTimesFished = 0,
		spamMessageThreshold = 3,
		notifiedPlayer = false,
		done = done
	}

	local fishTarget
	if fish then
		local position = Utility.Peep.getPosition(specificFish)
		fishTarget = Utility.spawnPropAtPosition(specificFish, "Target_Default", position.x, position.y, position.z)
		fishTarget = fishTarget and fishTarget:getPeep()
		Utility.Peep.makeInstanced(fishTarget, playerPeep)

		if fishTarget then
			fishTarget:setTarget(specificFish, "Use your fishing rod and bait to catch the fish.")
		end

		state.fishTarget = fishTarget
	end

	playerPeep:listen("actionPerformed", Common._fishTutorialPerformFishAction, state)
	playerPeep:listen("resourceObtained", Common._fishTutorialSilence, state)
	playerPeep:listen("move", Common._fishTutorialSilence, state)
end

Common.FIRST_GOOD_ITEMS = {
	"^Isabellium",
	"Rune$",
	"Stormfish$",
	"^WaterWorm$",
	"FishingRod$"
}

Common.SECOND_GOOD_ITEMS = {
	"^Isabellium",
	"Rune$",
	"^WaterWorm$",
	"FishingRod$",
	"^CookedLightningStormfish$",
}

Common.THIRD_GOOD_ITEMS = {
	"^Isabellium",
	"Rune$",
	"^WaterWorm$",
	"FishingRod$"
}

function Common.isJunkItem(item, goodItemIDs)
	local isJunkItem = true
	for _, otherItemID in ipairs(goodItemIDs) do
		if item:getID():match(otherItemID) then
			isJunkItem = false
			break
		end
	end

	return isJunkItem and item or nil
end

Common.DROP_ITEMS_TUTORIAL = {
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

				local firstJunkItem, secondJunkItem, thirdJunkItem
				for _, item in ipairs(inventory) do
					firstJunkItem = firstJunkItem or Common.isJunkItem(item, Common.FIRST_GOOD_ITEMS)
					secondJunkItem = secondJunkItem or Common.isJunkItem(item, Common.SECOND_GOOD_ITEMS)
					thirdJunkItem = thirdJunkItem or Common.isJunkItem(item, Common.THIRD_GOOD_ITEMS)
				end

				local junkItem = firstJunkItem or secondJunkItem or thirdJunkItem
				if not junkItem then
					junkItem = inventory[#inventory]
				end

				state.currentJunkItem = junkItem
				local id = junkItem and string.format("Inventory-Item-%s", junkItem:getID()) or false

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
				if state.currentJunkItem then
					text = {
						{ 1, 1, 1, 1},
						"Drop",
						{ 1, 1, 1, 1},
						" ",
						"ui.poke.item",
						Utility.Item.getInstanceName(state.currentJunkItem)
					}
				else
					text = "Drop"
				end

				return {
					gamepad = {
						button = "y",
						label = text
					},

					standard = {
						button = "mouse_right",
						controller = "KeyboardMouse",
						label = text
					},

					mobile = {
						button = "tap",
						controller = "Long touch",
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
				local mouseRibbonInterface = Utility.UI.getOpenInterface(target, "PlayerInventory")
				local isMouseRibbonOpen = not not mouseRibbonInterface

				if not (isMouseRibbonOpen or isGamepadRibbonOpen) then
					return true
				end

				if isGamepadRibbonOpen and gamepadRibbonInterface:getProbedInventoryItem() then
					return true
				end

				if isMouseRibbonOpen and mouseRibbonInterface:getProbedInventoryItem() then
					return true
				end

				return false
			end
		end
	},
	{
		position =  "up",
		id = function(target, state)
			return function()
				local gamepadRibbonInterface = Utility.UI.getOpenInterface(target, "GamepadRibbon")
				local isGamepadRibbonOpen = gamepadRibbonInterface and gamepadRibbonInterface:getIsOpen()
				local mouseRibbonInterface = Utility.UI.getOpenInterface(target, "PlayerInventory")
				local isMouseRibbonOpen = not not mouseRibbonInterface

				if not (isMouseRibbonOpen or isGamepadRibbonOpen) then
					return false
				end

				local probedGamepadItem = isGamepadRibbonOpen and gamepadRibbonInterface:getProbedInventoryItem()
				local probedMouseItem = isMouseRibbonOpen and mouseRibbonInterface:getProbedInventoryItem()
				local probedItem = probedMouseItem or probedGamepadItem

				if not probedItem then
					return {
						gamepad = false,
						standard = false,
						touch = false
					}
				end

				local id = string.format("PokeMenu-Drop-%s", probedItem:getID())
				return {
					gamepad = id,
					standard = id,
					touch = id
				}
			end
		end,
		message = {
			gamepad = {
				button = "a",
				label = "Drop",
			},
			standard = {
				button = "mouse_left",
				controller = "KeyboardMouse",
				label = "Drop",
			},
			{
				button = "tap",
				controller = "Touch",
				label = "Drop",
			}
		},
		open = function(target, state)
			Utility.Peep.enable(target)

			return function()
				local gamepadRibbonInterface = Utility.UI.getOpenInterface(target, "GamepadRibbon")
				local isGamepadRibbonOpen = gamepadRibbonInterface and gamepadRibbonInterface:getIsOpen()
				local mouseRibbonInterface = Utility.UI.getOpenInterface(target, "PlayerInventory")
				local isMouseRibbonOpen = not not mouseRibbonInterface

				if not (isMouseRibbonOpen or isGamepadRibbonOpen) then
					return true
				end

				if isGamepadRibbonOpen and not gamepadRibbonInterface:getProbedInventoryItem() then
					return true
				end

				if isMouseRibbonOpen and not mouseRibbonInterface:getProbedInventoryItem() then
					return true
				end

				return false
			end
		end
	}
}

function Common.showDropItemTutorial(playerPeep, done)
	Utility.UI.tutorial(playerPeep, Common.DROP_ITEMS_TUTORIAL, done)
end

Common.YIELD_HINT = {
	{
		position = {
			gamepad = "center",
			standard = "center",
			mobile = "center"
		},
		id = {
			gamepad = "root",
			standard = "root",
			mobile = "root"
		},
		message = {
			gamepad = {
				button = "rightshoulder",
				label = "Open combat ring"
			},
			standard = {
				button = "keyboard_tab",
				controller = "KeyboardMouse",
				label = "Open combat ring"
			},
			mobile = {
				button = "tap",
				controller = "Touch",
				label = "Open combat ring"
			}
		},
		open = function(target, state)
			return function()
				local gamepadCombatHUD = Utility.UI.getOpenInterface(target, "GamepadCombatHUD")
				local proCombatHUD = Utility.UI.getOpenInterface(target, "ProCombatHUD")

				local isOpen = (gamepadCombatHUD and gamepadCombatHUD:getIsOpen()) or
				               (proCombatHUD and proCombatHUD:getIsOpen())

				return isOpen
			end
		end
	},
	{
		position = {
			gamepad = "up"
		},
		style = {
			gamepad = "circle"
		},
		id = {
			gamepad = "GamepadCombatHUD-Menu"
		},
		message = {
			gamepad = {
				button = "leftstick",
				action = { "left", "up", "right", "down"},
				speed = Common.HINT_WAIT_SHUFFLE_TIME / 4,
				label = "Rotate left stick to select"
			}
		},
		open = Common.WAIT_OPEN_FUNCTION(nil, function(target, state)
			return function()
				local gamepadCombatHUD = Utility.UI.getOpenInterface(target, "GamepadCombatHUD")
				return not (gamepadCombatHUD and gamepadCombatHUD:getIsOpen())
			end
		end)
	},
	{
		position = "up",
		id = function(target, state)
			return function()
				local gamepadCombatHUD = Utility.UI.getOpenInterface(target, "GamepadCombatHUD")
				local proCombatHUD = Utility.UI.getOpenInterface(target, "ProCombatHUD")

				if gamepadCombatHUD and gamepadCombatHUD:getIsOpen() then
					return {
						gamepad = "BaseCombatHUD-flee",
						standard = "BaseCombatHUD-flee",
						touch = "BaseCombatHUD-flee"
					}
				end

				return {
					gamepad = false,
					controller = false,
					mouse = false
				}
			end
		end,
		message = {
			gamepad = {
				button = "a",
				label = {
					{ 1, 1, 1, 1 },
					"Yield against",
					{ 1, 1, 1, 1 },
					" ",
					"ui.poke.actor",
					"Dummy"
				}
			},
			standard = {
				button = "mouse_left",
				controller = "KeyboardMouse",
				label = {
					{ 1, 1, 1, 1 },
					"Yield against",
					{ 1, 1, 1, 1 },
					" ",
					"ui.poke.actor",
					"Dummy"
				}
			},
			standard = {
				button = "tap",
				controller = "Touch",
				label = {
					{ 1, 1, 1, 1 },
					"Yield against",
					{ 1, 1, 1, 1 },
					" ",
					"ui.poke.actor",
					"Dummy"
				}
			}
		},
		open = function(target, state)
			return function()
				local gamepadCombatHUD = Utility.UI.getOpenInterface(target, "GamepadCombatHUD")
				local proCombatHUD = Utility.UI.getOpenInterface(target, "ProCombatHUD")

				local isOpen = (gamepadCombatHUD and gamepadCombatHUD:getIsOpen()) or
				               (proCombatHUD and proCombatHUD:getIsOpen())

				return not (isOpen and target:hasBehavior(CombatTargetBehavior))
			end
		end	
	}
}

function Common.showYieldHint(playerPeep, done)
	Utility.UI.tutorial(playerPeep, Common.YIELD_HINT, done)
	Utility.Peep.enable(playerPeep)
end

Common.EAT_HINT = {
	{
		position = {
			gamepad = "center",
			standard = "center",
			mobile = "center"
		},
		id = {
			gamepad = "root",
			standard = "root",
			mobile = "root"
		},
		message = {
			gamepad = {
				button = "rightshoulder",
				label = "Open combat ring"
			},
			standard = {
				button = "keyboard_tab",
				controller = "KeyboardMouse",
				label = "Open combat ring"
			},
			mobile = {
				button = "tap",
				controller = "Touch",
				label = "Open combat ring"
			}
		},
		open = function(target, state)
			return function()
				local gamepadCombatHUD = Utility.UI.getOpenInterface(target, "GamepadCombatHUD")
				local proCombatHUD = Utility.UI.getOpenInterface(target, "ProCombatHUD")

				local isOpen = (gamepadCombatHUD and gamepadCombatHUD:getIsOpen()) or
				               (proCombatHUD and proCombatHUD:getIsOpen())

				return isOpen
			end
		end
	},
	{
		position = "up",
		id = function(target, state)
			return function()
				local gamepadCombatHUD = Utility.UI.getOpenInterface(target, "GamepadCombatHUD")
				local proCombatHUD = Utility.UI.getOpenInterface(target, "ProCombatHUD")

				if gamepadCombatHUD and gamepadCombatHUD:getIsOpen() then
					return {
						gamepad = "BaseCombatHUD-food",
						standard = "BaseCombatHUD-food",
						touch = "BaseCombatHUD-food"
					}
				end

				return {
					gamepad = false,
					controller = false,
					mouse = false
				}
			end
		end,
		message = {
			gamepad = {
				button = "a",
				label = "Open food ring"
			},
			standard = {
				button = "mouse_left",
				controller = "KeyboardMouse",
				label = "Open food ring"
			},
			standard = {
				button = "tap",
				controller = "Touch",
				label = "Open food ring"
			}
		},
		open = function(target, state)
			return function()
				local gamepadCombatHUD = Utility.UI.getOpenInterface(target, "GamepadCombatHUD")
				local proCombatHUD = Utility.UI.getOpenInterface(target, "ProCombatHUD")

				local isOpen = (gamepadCombatHUD and gamepadCombatHUD:getIsOpen()) or
				               (proCombatHUD and proCombatHUD:getIsOpen())

				return not (isOpen and target:hasBehavior(CombatTargetBehavior))
			end
		end	
	},
	{
		position = "up",
		id = function(target, state)
			return function()
				local gamepadCombatHUD = Utility.UI.getOpenInterface(target, "GamepadCombatHUD")
				local proCombatHUD = Utility.UI.getOpenInterface(target, "ProCombatHUD")

				if gamepadCombatHUD and gamepadCombatHUD:getIsOpen() then
					return {
						gamepad = "BaseCombatHUD-Food-CookedLightningStormfish",
						standard = "BaseCombatHUD-Food-CookedLightningStormfish",
						touch = "BaseCombatHUD-Food-CookedLightningStormfish"
					}
				end

				return {
					gamepad = false,
					controller = false,
					mouse = false
				}
			end
		end,
		message = {
			gamepad = {
				button = "a",
				label = {
					{ 1, 1, 1, 1 },
					"Eat",
					{ 1, 1, 1, 1 },
					" ",
					"ui.poke.item",
					"Cooked lightning stormfish"
				}
			}
		},
		open = function(target, state)
			state.initialFoodCount = target:getState():count("Item", "CookedLightningStormfish")

			return function()
				local gamepadCombatHUD = Utility.UI.getOpenInterface(target, "GamepadCombatHUD")
				local proCombatHUD = Utility.UI.getOpenInterface(target, "ProCombatHUD")

				if not (gamepadCombatHUD and gamepadCombatHUD:getIsOpen()) then
					return true
				end

				local currentFoodCount = target:getState():count("Item", "CookedLightningStormfish")
				return state.initialFoodCount == 0 or currentFoodCount < state.initialFoodCount
			end
		end	
	}
}

function Common.showEatHint(playerPeep, done)
	Utility.UI.tutorial(playerPeep, Common.EAT_HINT, done)
	Utility.Peep.enable(playerPeep)
end

return Common
