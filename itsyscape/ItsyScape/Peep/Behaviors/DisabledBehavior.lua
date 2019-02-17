--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/DisabledBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Behavior = require "ItsyScape.Peep.Behavior"

-- Stores combat status information, such as current hitpoints.
local DisabledBehavior = Behavior("Disabled")

-- Constructs an DisabledBehavior.
function DisabledBehavior:new()
	Behavior.Type.new(self)

	-- Nothing.
end

return DisabledBehavior
