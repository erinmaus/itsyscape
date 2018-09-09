--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/LootDropperBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies a peep that drops loot on death.
local LootDropperBehavior = Behavior("LootDropper")

-- Constructs a LootDropperBehavior.
function LootDropperBehavior:new()
	Behavior.Type.new(self)
end

return LootDropperBehavior
