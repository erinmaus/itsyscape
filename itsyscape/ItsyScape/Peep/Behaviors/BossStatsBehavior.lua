--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/BossStatsBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies the position of a Peep.
local BossStatsBehavior = Behavior("BossStats")

-- Constructs a BossStatsBehavior.
--
-- 'stats' should be a table of stats.
function BossStatsBehavior:new()
	Behavior.Type.new(self)

	self.stats = {}
end

return BossStatsBehavior
