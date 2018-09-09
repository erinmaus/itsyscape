--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/MappResourceBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies a peep that owns a Mapp resource reference
local MappResourceBehavior = Behavior("MappResource")

-- Constructs a MappResourceBehavior.
--
-- resource: The Mapp resource. Defaults to false.
function MappResourceBehavior:new()
	Behavior.Type.new(self)

	self.resource = false
end

return MappResourceBehavior
