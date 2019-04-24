--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/MirrorBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies the rotation of a Peep.
local MirrorBehavior = Behavior("Mirror")

-- Constructs a MirrorBehavior with the provided reflection.
--
-- Values default to 90 degrees.
function MirrorBehavior:new(rot)
	Behavior.Type.new(self)
	self.reflection = rot or Quaternion.Y_90
end

return MirrorBehavior
