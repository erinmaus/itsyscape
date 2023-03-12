--------------------------------------------------------------------------------
-- ItsyScape/UI/Keybinds.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Keybind = require "ItsyScape.UI.Keybind"

local Keybinds = {}

local function add(name, defaultBinding)
	local existing = _CONF.keybinds or {} 
	local keybind = Keybind(name, existing[name] or defaultBinding)

	table.insert(Keybinds, keybind)
	Keybinds[name] = keybind
end

-- Player 1 movement
add('PLAYER_1_MOVE_UP',    'w')
add('PLAYER_1_MOVE_DOWN',  's')
add('PLAYER_1_MOVE_LEFT',  'a')
add('PLAYER_1_MOVE_RIGHT', 'd')
add('PLAYER_1_FLEE',       'escape')
add('PLAYER_1_FOCUS',      'tab')
add('PLAYER_1_CAMERA',     '/')
add('PLAYER_1_CHAT',       'return')

-- Camera
add('CAMERA_UP',    'up')
add('CAMERA_DOWN',  'down')
add('CAMERA_LEFT',  'left')
add('CAMERA_RIGHT', 'right')

-- Strategy bar
add('STRATEGY_BAR_SLOT_1',  '1')
add('STRATEGY_BAR_SLOT_2',  '2')
add('STRATEGY_BAR_SLOT_3',  '3')
add('STRATEGY_BAR_SLOT_4',  '4')
add('STRATEGY_BAR_SLOT_5',  '5')
add('STRATEGY_BAR_SLOT_6',  '6')
add('STRATEGY_BAR_SLOT_7',  '7')
add('STRATEGY_BAR_SLOT_8',  '8')
add('STRATEGY_BAR_SLOT_9',  '9')
add('STRATEGY_BAR_SLOT_10', '0')

-- Minigames
add('MINIGAME_DASH', 'space')

-- Debug
if _DEBUG then
	add('DEBUG_TRIGGER_1', 'rshift f5')
	add('DEBUG_TRIGGER_2', 'rshift f6')
	add('DEBUG_TRIGGER_3', 'rshift f7')
	add('DEBUG_TRIGGER_4', 'rshift f8')
end

-- Sailing
add('SAILING_ACTION_PRIMARY', 'space')
add('SAILING_ACTION_SECONDARY', 'rshift space')

return Keybinds
