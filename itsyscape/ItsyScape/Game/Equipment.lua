--------------------------------------------------------------------------------
-- ItsyScape/Game/Equipment.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Item = require "ItsyScape.Game.Item"

local Equipment = Class(Item)
Equipment.PLAYER_SLOT_SELF   = 0
Equipment.PLAYER_SLOT_HEAD   = 1
Equipment.PLAYER_SLOT_NECK   = 2
Equipment.PLAYER_SLOT_BODY   = 3
Equipment.PLAYER_SLOT_LEGS   = 4
Equipment.PLAYER_SLOT_FEET   = 5
Equipment.PLAYER_SLOT_HANDS  = 6
Equipment.PLAYER_SLOT_BACK   = 7
Equipment.PLAYER_SLOT_FINGER = 8
Equipment.PLAYER_SLOT_POCKET = 9
Equipment.PLAYER_SLOT_QUIVER = 10
Equipment.PLAYER_SLOT_EFFECT = 11

Equipment.AMMO_NONE  = 0
Equipment.AMMO_ARROW = 1
Equipment.AMMO_BOLT  = 2
Equipment.AMMO_ANY   = 100

Equipment.PLAYER_SLOT_RIGHT_HAND = 20
Equipment.PLAYER_SLOT_LEFT_HAND = 21
Equipment.PLAYER_SLOT_TWO_HANDED = 22

Equipment.SKIN_PRIORITY_BASE       = 0
Equipment.SKIN_PRIORITY_ACCENT     = 10
Equipment.SKIN_PRIORITY_EQUIPMENT  = 100

return Equipment
