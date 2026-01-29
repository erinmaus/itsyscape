--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/CombatDodgeBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

local CombatDodgeBehavior = Behavior("CombatDodge")

function CombatDodgeBehavior:new()
	Behavior.Type.new(self)

	self.direction = Vector(0)
	self.speed = 0
	self.currentDistance = 0
	self.maximumDistance = 0
end

return CombatDodgeBehavior
