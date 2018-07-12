--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/PropReferenceBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Behavior = require "ItsyScape.Peep.Behavior"

-- Stores a reference to a prop.
local PropReferenceBehavior = Behavior("PropReference")

-- Constructs an PropReferenceBehavior.
--
-- * prop: Reference to prop. Should be falsey if there is no reference.
--   Defaults to false.
function PropReferenceBehavior:new()
	Behavior.Type.new(self)
	self.prop = false
end

return PropReferenceBehavior
