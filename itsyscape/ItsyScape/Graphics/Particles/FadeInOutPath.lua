--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Particles/FadeInOutPath.lua
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

local FadeInOutPath = Class(ParticlePath)

function FadeInOutPath:new()
	ParticlePath.new(self)
	self:setFadeInPercent()
	self:setFadeOutPercent()
	self:setTween()
end

function FadeInOutPath:setFadeInPercent(value)
	self.fadeInPercent = value or 0
end

function FadeInOutPath:setFadeOutPercent(value)
	self.fadeOutPercent = value or 1
end

function FadeInOutPath:setTween(value)
	self.tween = value or 'linear'
end

function FadeInOutPath:update(particle, delta)
	local tween = Tween[self.tween]

	local percentAge = particle.age / particle.lifetime
	if percentAge <= self.fadeInPercent then
		particle.colorAlpha = tween(percentAge / self.fadeInPercent)
	elseif percentAge >= self.fadeOutPercent then
		local difference = percentAge - self.fadeOutPercent
		local range = 1 - self.fadeOutPercent
		particle.colorAlpha = tween(1 - difference / range)
	else
		particle.colorAlpha = 1
	end
end

return FadeInOutPath
