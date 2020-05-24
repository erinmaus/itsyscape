--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/MapOffsetBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies the offset of a Peep.
local MapOffsetBehavior = Behavior("MapOffset")

-- Constructs a MapOffsetBehavior with the provided offset.
--
-- Values default to 0.
function MapOffsetBehavior:new(x, y, z)
	Behavior.Type.new(self)

	self.origin = Vector(x, y, z)
	self.offset = Vector(0, 0, 0)
	self.rotation = Quaternion.IDENTITY
	self.scale = Vector.ONE
end

return MapOffsetBehavior
