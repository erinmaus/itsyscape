--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/MapResourceReferenceBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Behavior = require "ItsyScape.Peep.Behavior"

-- Stores a reference to a map.
local MapResourceReferenceBehavior = Behavior("MapResourceReference")

-- Constructs a MapResourceReferenceBehavior.
--
-- * map: Reference to Map resource.
function MapResourceReferenceBehavior:new()
	Behavior.Type.new(self)
	self.map = false
end

return MapResourceReferenceBehavior
