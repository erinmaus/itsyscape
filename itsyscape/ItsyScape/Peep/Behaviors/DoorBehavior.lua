--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/DoorBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Function = require "ItsyScape.Common.Function"
local Behavior = require "ItsyScape.Peep.Behavior"
local Tile = require "ItsyScape.World.Tile"

local DoorBehavior = Behavior("Door")

function DoorBehavior:new()
	Behavior.Type.new(self)

	self.isOpen = false
	self.openLock = 0
end

return DoorBehavior
