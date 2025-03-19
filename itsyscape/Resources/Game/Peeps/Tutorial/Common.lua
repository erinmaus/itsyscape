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
local Weapon = require "ItsyScape.Game.Weapon"
local Probe = require "ItsyScape.Peep.Probe"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local Common = {}

Common.HINT_WAIT_TIME = 100

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

		open = function(target)
			return function()
				local interface = Utility.UI.getOpenInterface(target, "GamepadRibbon")
				return (interface and interface:getIsOpen()) or Utility.UI.isOpen(target, "PlayerInventory")
			end
		end
	}
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
	Common.startRibbonTutorial(playerPeep, Common.EQUIP_GEAR[1].open(playerPeep))
	Utility.UI.tutorial(playerPeep, Common.EQUIP_GEAR, done)
end

return Common
