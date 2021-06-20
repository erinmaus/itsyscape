--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/TVBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies a TV view.
local TVBehavior = Behavior("TV")

function TVBehavior:new()
	self.i = 1
	self.j = 1
	self.layer = false
	self.target = false
	self.isOn = false
	self.channel = math.random(1, 1000)
	self.color = Color(0, math.random() * 0.5 + 0.5, 0, 1)

	Behavior.Type.new(self)
end

return TVBehavior
