--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/MapObjectBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies a peep that owns a map object reference
local MapObjectBehavior = Behavior("MapObject")

-- Constructs a MapObjectBehavior.
--
-- mapObject: The MapObject resource. Defaults to false.
--
-- A map object has priority over the base resource.
function MapObjectBehavior:new()
	Behavior.Type.new(self)

	self.mapObject = false
end

return MapObjectBehavior
