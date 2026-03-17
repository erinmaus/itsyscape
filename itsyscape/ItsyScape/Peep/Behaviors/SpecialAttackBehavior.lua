--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/SpecialAttackBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

local SpecialAttackBehavior = Behavior("SpecialAttack")

-- Constructs a SpecialAttackBehavior.
--
-- Indicates the foe is using or recently used a special attack.
--
-- - 'weapon' is an Weapon-instance. This is the special attack "weapon."
-- - 'attackInterval' is how many attacks before the SpecialAttack is finished.
function SpecialAttackBehavior:new()
	Behavior.Type.new(self)

	self.attackInterval = 1
	self.weapon = false
end

return SpecialAttackBehavior
