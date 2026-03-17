--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicDodge.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local PassableProp = require "Resources.Game.Peeps.Props.PassableProp"

local BasicDodge = Class(PassableProp)

BasicDodge.FADE_IN_OUT_DURATION = 0.25
BasicDodge.POOF_DURATION        = 1

function BasicDodge:new(...)
	PassableProp.new(self, ...)

	self:addPoke("color")
	self:addPoke("fade")
	self:addPoke("vanish")

	self.innerColor = Color(1, 0, 0)
	self.outerColor = Color(1, 1, 0)

	self.fadeDuration = 0
	self.isFadingIn = false
	self.isFadingOut = false
end

function BasicDodge:onColor(innerColor, outerColor)
	self.innerColor:from(innerColor:get())
	self.outerColor:from(outerColor:get())

	self.isFadingIn = true
	self.isFadingOut = false
	self.fadeDuration = BasicDodge.FADE_IN_OUT_DURATION
end

function BasicDodge:onFade()
	self.fadeDuration = BasicDodge.FADE_IN_OUT_DURATION - self.fadeDuration
	self.isFadingIn = false
	self.isFadingOut = true
end

function BasicDodge:onVanish()
	Utility.Peep.poof(self)
end

function BasicDodge:_updateFade(delta)
	self.fadeDuration = math.max(self.fadeDuration - delta, 0)

	if self.fadeDuration == 0 and self.isFadingOut then
		self.isFadingOut = false
		self:pushPoke(self.POOF_DURATION, "vanish")
	end
end

function BasicDodge:update(director, game)
	PassableProp.update(self, director, game)

	local delta = game:getDelta()
	self:_updateFade(delta)
end

function BasicDodge:getPropState()
	local alpha = self.fadeDuration / self.FADE_IN_OUT_DURATION
	if self.isFadingIn then
		alpha = 1 - alpha
	end

	return {
		innerColor = { self.innerColor:get() },
		outerColor = { self.outerColor:get() },
		alpha = alpha
	}
end

return BasicDodge
