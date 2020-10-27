--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicTorch.lua
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

local BasicTorch = Class(Prop)

function BasicTorch:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 3, 1)

	self:addPoke('light')
	self:addPoke('snuff')

	self.isLit = true
end

function BasicTorch:getIsLit()
	return self.isLit
end

function BasicTorch:canLight()
	return true
end

function BasicTorch:previewLight(...)
	if self:canLight() then
		self.isLit = true
	end
end

function BasicTorch:previewSnuff(...)
	self.isLit = false
end

function BasicTorch:getPropState()
	return { lit = self.isLit }
end

return BasicTorch
