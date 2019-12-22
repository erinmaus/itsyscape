--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicDresserProp.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local BasicDresserProp = Class(Prop) 

function BasicDresserProp:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(4, 2, 2)

	self.isOpen = false
end

function BasicDresserProp:onSearch(...)
	self.isOpen = true
end

function BasicDresserProp:getPropState()
	return {
		isOpen = self.isOpen
	}
end

return BasicDresserProp
