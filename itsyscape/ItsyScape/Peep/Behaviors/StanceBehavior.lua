--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/StanceBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"
local Weapon = require "ItsyScape.Game.Weapon"

-- Specifies the size of a Peep.
local StanceBehavior = Behavior("Stance")

-- Constructs a StanceBehavior with the provided stance.
--
-- * useSpell: Whether or not to use active combat spell. Defaults to false.
--
-- Defaults to STANCE_CONTROLLED.
function StanceBehavior:new(stance)
	Behavior.Type.new(self)
	self.stance = stance or Weapon.STANCE_CONTROLLED
	self.useSpell = false
end

return StanceBehavior
