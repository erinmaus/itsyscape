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
Equipment.PLAYER_SLOT_HEAD   = 1
Equipment.PLAYER_SLOT_NECK   = 2
Equipment.PLAYER_SLOT_BODY   = 3
Equipment.PLAYER_SLOT_LEGS   = 4
Equipment.PLAYER_SLOT_FEET   = 5
Equipment.PLAYER_SLOT_HANDS  = 6
Equipment.PLAYER_SLOT_BACK   = 7
Equipment.PLAYER_SLOT_FINGER = 8
Equipment.PLAYER_SLOT_POCKET = 9

return Equipment
