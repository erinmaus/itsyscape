--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicPlayerSail.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local ColorBehavior = require "ItsyScape.Peep.Behaviors.ColorBehavior"
local PassableProp = require "Resources.Game.Peeps.Props.PassableProp"

local BasicPlayerSail = Class(PassableProp)

function BasicPlayerSail:new(...)
	PassableProp.new(self, ...)

	self:addBehavior(ColorBehavior)
end

function BasicPlayerSail:getPropState()
	local colors = self:getBehavior(ColorBehavior)

	return {
		primary = { colors.primary:get() },
		secondary = { (colors.secondaries[1] or Color()):get() }
	}
end

return BasicPlayerSail
