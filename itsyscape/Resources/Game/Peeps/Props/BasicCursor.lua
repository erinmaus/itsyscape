--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Props/BasicCursor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local PassableProp = require "Resources.Game.Peeps.Props.PassableProp"

local BasicCursor = Class(PassableProp)

function BasicCursor:new(...)
	PassableProp.new(self, ...)

	self.color = Color(1, 0, 0, 1)
end

function BasicCursor:setColor(value)
	self.color:from(value:get())
end

function BasicCursor:getColor()
	return self.color
end

function BasicCursor:getPropState()
	return { color = { self.color:get() } }
end

return BasicCursor
