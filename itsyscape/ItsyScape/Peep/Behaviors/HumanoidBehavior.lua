--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/HumanoidBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies a peep is human.
local HumanoidBehavior = Behavior("Humanoid")

-- Constructs a HumanoidBehavior.
function HumanoidBehavior:new()
	Behavior.Type.new(self)
end

return HumanoidBehavior
