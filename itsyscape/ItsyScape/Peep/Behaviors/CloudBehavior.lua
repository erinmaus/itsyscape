--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/CloudBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Behavior = require "ItsyScape.Peep.Behavior"

local SkyBehavior = Behavior("Cloud")

function SkyBehavior:new()
	Behavior.Type.new(self)

	self.alpha = 1
end

return SkyBehavior
