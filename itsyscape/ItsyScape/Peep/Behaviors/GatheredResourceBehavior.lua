--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/GatheredResourceBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Behavior = require "ItsyScape.Peep.Behavior"

-- If present on a peep, means the resource was gathered.
local GatheredResourceBehavior = Behavior("GatheredResourceBehavior")

function GatheredResourceBehavior:new()
	Behavior.Type.new(self)
end

return GatheredResourceBehavior
