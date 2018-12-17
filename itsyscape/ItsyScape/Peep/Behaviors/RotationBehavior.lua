--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/RotationBehavior.lua
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
local RotationBehavior = Behavior("Rotation")

-- Constructs a RotationBehavior with the provided rotation.
--
-- Values default to 1.
function RotationBehavior:new(rot)
	Behavior.Type.new(self)
	self.rotation = rot or Quaternion.IDENTITY
end

return RotationBehavior
