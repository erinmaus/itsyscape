--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/TeleportalBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies the output of a teleport action.
local TeleportalBehavior = Behavior("Humanoid")

-- Constructs a TeleportalBehavior.
function TeleportalBehavior:new()
	self.i = 1
	self.j = 1
	self.layer = false
	Behavior.Type.new(self)
end

return TeleportalBehavior
