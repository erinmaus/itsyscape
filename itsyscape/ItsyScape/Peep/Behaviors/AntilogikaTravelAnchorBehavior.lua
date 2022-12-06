--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/AntilogikaTravelAnchorBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

local AntilogikaTravelAnchorBehavior = Behavior("AntilogikaTravelAnchor")

AntilogikaTravelAnchorBehavior.TRAVEL_TYPE_NONE      = 0
AntilogikaTravelAnchorBehavior.TRAVEL_TYPE_OVERWORLD = 1
AntilogikaTravelAnchorBehavior.TRAVEL_TYPE_BUILDING  = 2
AntilogikaTravelAnchorBehavior.TRAVEL_TYPE_DUNGEON   = 3

function AntilogikaTravelAnchorBehavior:new()
	-- The target cell coordinates
	self.targetCellI = 0
	self.targetCellJ = 0

	-- Target anchor position to spawn peep after moving
	self.targetPosition = Vector.ZERO

	self.travelType = AntilogikaTravelAnchorBehavior.TRAVEL_TYPE_OVERWORLD

	Behavior.Type.new(self)
end

return AntilogikaTravelAnchorBehavior
