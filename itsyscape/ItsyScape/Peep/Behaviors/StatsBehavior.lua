--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/StatsBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies the position of a Peep.
local StatsBehavior = Behavior("Stats")

-- Constructs a StatsBehavior.
--
-- 'stats' should be false or an ItsyScape.Game.Stats instance.
function StatsBehavior:new()
	Behavior.Type.new(self)

	self.stats = false
end

return StatsBehavior
