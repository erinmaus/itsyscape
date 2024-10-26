--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicSailingItem.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local ColorBehavior = require "ItsyScape.Peep.Behaviors.ColorBehavior"
local PassableProp = require "Resources.Game.Peeps.Props.PassableProp"

local BasicSailingItem = Class(PassableProp)

function BasicSailingItem:new(...)
	PassableProp.new(self, ...)

	self:addBehavior(ColorBehavior)
end

function BasicSailingItem:getPropState()
	local colors = self:getBehavior(ColorBehavior)

	return {
		primary = { colors.primary:get() },
		secondary = { (colors.secondaries[1] or Color()):get() }
	}
end

return BasicSailingItem
