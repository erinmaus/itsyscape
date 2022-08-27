--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Particles/SizePath.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local ParticlePath = require "ItsyScape.Graphics.ParticlePath"

local SizePath = Class(ParticlePath)

function SizePath:new()
	ParticlePath.new(self)
	self:setSize()
	self:setInPercent()
	self:setOutPercent()
	self:setTween()
end

function SizePath:setSize(value)
	self.size = value or 1
end

function SizePath:setInPercent(value)
	self.inPercent = value or 0
end

function SizePath:setOutPercent(value)
	self.outPercent = value or 1
end

function SizePath:setTween(value)
	self.tween = value or 'linear'
end

function SizePath:update(particle, delta)
	local tween = Tween[self.tween]

	local percentAge = particle.age / particle.lifetime
	if percentAge <= self.inPercent then
		particle.scaleX = tween(percentAge / self.inPercent) * self.size
		particle.scaleY = particle.scaleX
	elseif percentAge >= self.outPercent then
		local difference = percentAge - self.outPercent
		local range = 1 - self.outPercent
		particle.scaleX = tween(1 - difference / range) * self.size
		particle.scaleY = particle.scaleX
	else
		particle.scaleX = self.size
		particle.scaleY = self.size
	end
end

return SizePath
