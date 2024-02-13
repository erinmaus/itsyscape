--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/ShipCaptainBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Behavior = require "ItsyScape.Peep.Behavior"

local ShipCaptainBehavior = Behavior("ShipCaptain")

-- Constructs an ShipCaptainBehavior.
-- If attached to a Peep, points to the ship's map script.
-- If attached to a Ship, points to the ship's captain (Peep).
function ShipCaptainBehavior:new()
	Behavior.Type.new(self)
	self.peep = false
end

return ShipCaptainBehavior
