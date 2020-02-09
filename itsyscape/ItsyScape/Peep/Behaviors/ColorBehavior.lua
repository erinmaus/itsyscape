--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/ColorBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Behavior = require "ItsyScape.Peep.Behavior"
local Color = require "ItsyScape.Graphics.Color"

-- Specifies the rotation of a Peep.
local ColorBehavior = Behavior("Color")

-- Constructs a ColorBehavior with the provided color.
--
-- Values default to #ffffff.
function ColorBehavior:new(color)
	Behavior.Type.new(self)

	self.primary = Color(color)
	self.secondaries = {}
end

return ColorBehavior
