--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicLever.lua
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

local BasicLever = Class(Prop)

function BasicLever:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1.5, 1.5, 1.5)

	self:addPoke('pull')

	self.isPulled = false
end

function BasicLever:getIsPulled()
	return self.isPulled
end

function BasicLever:canPull()
	return true
end

function BasicLever:onPull(force)
	if self:canPull() or force then
		self.isPulled = not self.isPulled
	end
end

function BasicLever:getPropState()
	return { down = not self.isPulled }
end

return BasicLever
