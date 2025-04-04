--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/StandardZealOrb.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local Config = require "ItsyScape.Game.Config"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Variables = require "ItsyScape.Game.Variables"
local Drawable = require "ItsyScape.UI.Drawable"
local Widget = require "ItsyScape.UI.Widget"
local Particles = require "ItsyScape.UI.Particles"
local StandardBarLabel = require "ItsyScape.UI.Interfaces.Components.StandardBarLabel"

local StandardZealOrb = Class(Drawable)
StandardZealOrb.BORDER_ALPHA = 0.75
StandardZealOrb.BORDER_THICKNESS = 4

function StandardZealOrb:new()
	Drawable.new(self)

	self.innerHueShift = 0.1
	self.innerSaturationShift = 0.2
	self.innerLightnessShift = -0.05
	self.targetTime = 1 / 10
	self.currentTime = 0
	self.padding = 4
	self.squish = 1.2

	self.outerFireParticles = {}
	self.outerFireParticles = Particles()
	self.outerFireParticles:setOverflow(false)
	self.outerFireParticles:setTexture("Resources/Game/UI/Particles/Combat/Zeal.png")
	self.outerFireParticles:updateParticleSystemProperties({
		BufferSize = { 2000 },
		Direction = { math.rad(0) },
		Spread = { math.rad(90) },
		LinearAcceleration = { 0, -64, 0, -80 },
		ParticleLifetime = { 0.4, 0.9 },
		Sizes = { 0.4, 0.2 },
		Speed = { -2, -6 },
		Spin = { math.pi, math.pi * 1.5 },
		SpinVariation = { 1 },
		Colors = {
			{ 1, 0.8, 0.8, 0 },
			{ 1, 0.9, 0.9, 0.8 },
			{ 1, 1, 1, 0.8 },
			{ 1, 1, 1, 0 }
		},
		Quads = {
			love.graphics.newQuad(0, 0, 128, 128, 512, 128),
			love.graphics.newQuad(128, 0, 128, 128, 512, 128),
			love.graphics.newQuad(256, 0, 128, 128, 512, 128),
			love.graphics.newQuad(384, 0, 128, 128, 512, 128),
		},
	})
	self.outerFireParticles:updateParticleSystemProperties({ Offset = { 64, 64 } })
	self:addChild(self.outerFireParticles)

	self.innerFireParticles = {}
	self.innerFireParticles = Particles()
	self.innerFireParticles:setOverflow(false)
	self.innerFireParticles:setTexture("Resources/Game/UI/Particles/Combat/Zeal.png")
	self.innerFireParticles:updateParticleSystemProperties({
		BufferSize = { 2000 },
		Direction = { math.rad(0) },
		Spread = { math.rad(90) },
		LinearAcceleration = { 0, -48, 0, -64 },
		ParticleLifetime = { 0.3, 0.6 },
		Sizes = { 0.3, 0.2 },
		Spin = { math.pi, math.pi * 1.5 },
		SpinVariation = { 1 },
		Speed = { -1, -4 },
		Colors = {
			{ 1, 0.7, 0.7, 0 },
			{ 1, 0.9, 0.9, 0.8 },
			{ 1, 1, 1, 0.8 },
			{ 1, 1, 1, 0 }
		},
		Quads = {
			love.graphics.newQuad(0, 0, 128, 128, 512, 128),
			love.graphics.newQuad(128, 0, 128, 128, 512, 128),
			love.graphics.newQuad(256, 0, 128, 128, 512, 128),
			love.graphics.newQuad(384, 0, 128, 128, 512, 128),
		}
	})
	self.innerFireParticles:updateParticleSystemProperties({ Offset = { 64, 64 } })
	self:addChild(self.innerFireParticles)

	self.label = StandardBarLabel()
	self.label:setPadding(36)
	self.label:setAlign("center")
	self:addChild(self.label)

	self.currentZeal = 0
	self.previousZeal = 0
	self.maximumZeal = 1
	self.tier = 1

	self.currentZealColor = false
	self.currentZealTransitionTime = 0
	self.targetZealTransitionTime = 0.25

	self.fadeInOutTransitionTime = self.targetZealTransitionTime
	self.isFadingOut = true
	self.isFadingIn = false

	self.isReady = false

	self._stencil = function()
		local width, height = self:getSize()
		local radius = math.min(width, height) / 2

		love.graphics.circle("fill", width / 2, height / 2, radius)
	end
end

function StandardZealOrb:getOverflow()
	return true
end

function StandardZealOrb:_calculateRelativeValue(currentValue, maximumValue)
	if currentValue == math.huge then
		return 1
	end

	if maximumValue == math.huge then
		maximumValue = math.max(currentValue, 1)
	end

	return currentValue / maximumValue
end

function StandardZealOrb:updateZeal(current, maximum)
	current = current or 0
	maximum = maximum or 1

	current = math.min(current, maximum)

	self.currentZeal = current
	self.maximumZeal = maximum

	self.label:setText(string.format("%s%%", Utility.Text.prettyNumber(math.floor(current * 100))))
end

function StandardZealOrb:updateZealTier(tier)
	if self.tier == tier then
		return
	end

	local currentColorName = string.format("ui.combat.zeal.tier%dFire", self.tier)
	local nextColorName = string.format("ui.combat.zeal.tier%dFire", tier)
	local currentColor = Color.fromHexString(Config.get("Config", "COLOR", "color", currentColorName))
	local nextColor = Color.fromHexString(Config.get("Config", "COLOR", "color", nextColorName))

	local delta = Tween.sineEaseOut(self.currentZealTransitionTime / self.targetZealTransitionTime)
	self.currentZealColor = (self.currentZealColor or currentColor):lerp(currentColor, delta)
	self.currentZealTransitionTime = 0
	self.tier = tier
end

function StandardZealOrb:update(delta)
	Drawable.update(self, delta)

	if self.previousZeal == 0 and self.currentZeal > 0 then
		self.isFadingIn = true
		self.isFadingOut = false
		self.fadeInOutTransitionTime = self.targetZealTransitionTime - self.fadeInOutTransitionTime
	elseif self.previousZeal > 0 and self.currentZeal == 0 then
		self.isFadingIn = false
		self.isFadingOut = true
		self.fadeInOutTransitionTime = self.targetZealTransitionTime - self.fadeInOutTransitionTime
	end

	self.fadeInOutTransitionTime = math.min(self.fadeInOutTransitionTime + delta, self.targetZealTransitionTime)

	self.previousZeal = self.currentZeal

	local width, height = self:getSize()
	local relativeZeal = self:_calculateRelativeValue(self.currentZeal, self.maximumZeal)

	self.currentTime = self.currentTime + delta
	while self.currentTime > self.targetTime do
		self.currentTime = self.currentTime - self.targetTime

		local numSteps = math.max(math.ceil(relativeZeal * 20), 0)
		if numSteps > 0 then
			local stepWidth = width * (5 / 8)
			local x = 0
			for i = 1, numSteps do
				local y = i / numSteps * height / 2
				local maxWidth = math.sin(i / 20 * (math.pi / 2)) ^ self.squish * stepWidth

				self.innerFireParticles:updateParticleSystemProperties({
					EmissionArea = { "normal", maxWidth / 4, y / 4, 0, true },
					Position = { width / 2, height - y }
				})

				self.outerFireParticles:updateParticleSystemProperties({
					EmissionArea = { "normal", maxWidth / 3, y / 3, 0, true },
					Position = { width / 2, height - y - 16 }
				})

				self.innerFireParticles:emit(math.floor(maxWidth / 6) + 1, math.floor(maxWidth / 7) + 2)
				self.outerFireParticles:emit(math.floor(maxWidth / 7) + 2, math.floor(maxWidth / 8) + 3)
			end
		end
	end

	if self.currentZeal >= 1 then
		self.outerFireParticles:setOverflow(true)
		self.innerFireParticles:setOverflow(true)
	else
		self.outerFireParticles:setOverflow(false)
		self.innerFireParticles:setOverflow(false)
	end

	self.currentZealTransitionTime = math.min(self.currentZealTransitionTime + delta, self.targetZealTransitionTime)
	local delta = Tween.sineEaseOut(self.currentZealTransitionTime / self.targetZealTransitionTime)

	local currentColorName = string.format("ui.combat.zeal.tier%dFire", self.tier)
	local currentZealColor = Color.fromHexString(Config.get("Config", "COLOR", "color", currentColorName))

	local outerZealColor = (self.currentZealColor or currentZealColor):lerp(currentZealColor, delta)
	self.outerFireParticles:setTintColor(outerZealColor)

	local innerZealColor = outerZealColor:shiftHSL(self.innerHueShift, self.innerSaturationShift, self.innerLightnessShift)
	self.innerFireParticles:setTintColor(innerZealColor)
end

function StandardZealOrb:_drawCircle()
	love.graphics.stencil(self._stencil)
	love.graphics.setStencilTest("greater", 0)
end

function StandardZealOrb:beforeDrawChildren()
	if self.currentZeal >= 1 then
		self:drawBorder()
		return
	end

	itsyrealm.graphics.pushCallback(self._drawCircle, self)
end

function StandardZealOrb:afterDrawChildren()
	if self.currentZeal >= 1 then
		return
	end

	itsyrealm.graphics.pushCallback(love.graphics.setStencilTest)
	self:drawBorder()
end

function StandardZealOrb:drawBorder()
	local alpha = Tween.sineEaseOut(self.fadeInOutTransitionTime / self.targetZealTransitionTime)
	if self.isFadingOut then
		alpha = 1 - alpha
	end

	alpha = alpha * self.BORDER_ALPHA

	local borderColor
	if self.tier >= 1 then
		local currentColorName = string.format("ui.combat.zeal.tier%dFire", self.tier)
		local currentZealColor = Color.fromHexString(Config.get("Config", "COLOR", "color", currentColorName), alpha)
		local otherZealColor = currentZealColor:shiftHSL(self.innerHueShift, self.innerSaturationShift, self.innerLightnessShift)

		local delta = math.abs(math.sin(love.timer.getTime() * math.pi))
		borderColor = currentZealColor:lerp(otherZealColor, 0)
	else
		borderColor = Color(0, 0, 0, self.BORDER_ALPHA)
	end

	local width, height = self:getSize()
	local radius = math.min(width, height) / 2
	love.graphics.push("all")
	love.graphics.setColor(borderColor:get())
	love.graphics.setLineWidth(self.BORDER_THICKNESS)
	itsyrealm.graphics.circle("line", width / 2, height / 2, radius - self.BORDER_THICKNESS / 2)
	love.graphics.pop()
end

function StandardZealOrb:draw(resources, state)
	Drawable.draw(self, resources, state)

	local width, height = self:getSize()
	local radius = math.min(width, height) / 2
	local color = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.zeal.background"), 0.5)

	love.graphics.setColor(color:get())
	itsyrealm.graphics.circle("fill", width / 2, height / 2, radius)

	love.graphics.setColor(1, 1, 1, 1)
end

return StandardZealOrb
