--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/StandardZealBar.lua
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
local Color = require "ItsyScape.Graphics.Color"
local Utility = require "ItsyScape.Game.Utility"
local Variables = require "ItsyScape.Game.Variables"
local Drawable = require "ItsyScape.UI.Drawable"
local Widget = require "ItsyScape.UI.Widget"
local Particles = require "ItsyScape.UI.Particles"
local StandardBarLabel = require "ItsyScape.UI.Interfaces.Components.StandardBarLabel"

local StandardZealBar = Class(Drawable)

local CONFIG = Variables.load("Resources/Game/Variables/Config.json")
local COLOR_PATH = Variables.Path("colors", Variables.PathParameter("color"))

function StandardZealBar:new()
	Drawable.new(self)

	self.innerHueShift = 0.1
	self.innerSaturationShift = 0.2
	self.innerLightnessShift = -0.05
	self.targetTime = 1 / 10
	self.currentTime = 0
	self.padding = 4
	self.squish = 1.075

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
		ParticleLifetime = { 0.4, 0.7 },
		Sizes = { 0.3, 0.2 },
		Spin = { math.pi, math.pi * 1.5 },
		SpinVariation = { 1 },
		Speed = { -2, -6 },
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
	self:addChild(self.label)

	self.currentZeal = 0
	self.maximumZeal = 1
	self.tier = 1

	self.currentZealColor = false
	self.currentZealTransitionTime = 0
	self.targetZealTransitionTime = 0.25

	self.isReady = false
end

function StandardZealBar:_calculateRelativeValue(currentValue, maximumValue)
	if currentValue == math.huge then
		return 1
	end

	if maximumValue == math.huge then
		maximumValue = math.max(currentValue, 1)
	end

	return currentValue / maximumValue
end

function StandardZealBar:updateZeal(current, maximum)
	current = current or 0
	maximum = maximum or 1

	current = math.min(current, maximum)

	self.currentZeal = current
	self.maximumZeal = maximum

	self.label:setText(string.format("%s%%", Utility.Text.prettyNumber(math.floor(current * 100))))
end

function StandardZealBar:updateZealTier(tier)
	if self.tier == tier then
		return
	end

	local currentColorName = string.format("ui.combat.zeal.tier%dFire", self.tier)
	local nextColorName = string.format("ui.combat.zeal.tier%dFire", tier)
	local currentColor = Color.fromHexString(CONFIG:get(COLOR_PATH, "color", currentColorName))
	local nextColor = Color.fromHexString(CONFIG:get(COLOR_PATH, "color", nextColorName))

	local delta = Tween.sineEaseOut(self.currentZealTransitionTime / self.targetZealTransitionTime)
	self.currentZealColor = (self.currentZealColor or currentColor):lerp(currentColor, delta)
	self.currentZealTransitionTime = 0
	self.tier = tier
end

function StandardZealBar:update(delta)
	Drawable.update(self, delta)

	local width, height = self:getSize()
	local relativeZeal = self:_calculateRelativeValue(self.currentZeal, self.maximumZeal)

	self.currentTime = self.currentTime + delta
	while self.currentTime > self.targetTime do
		self.currentTime = self.currentTime - self.targetTime

		local numSteps = math.max(math.floor(relativeZeal * 20), 0)
		if numSteps > 0 then
			local stepWidth = (relativeZeal * width) / numSteps
			local x = 0
			for i = 1, numSteps do
				local maxWidth = (self.squish ^ (i - 1)) * (stepWidth / 2)

				self.innerFireParticles:updateParticleSystemProperties({
					EmissionArea = { "normal", maxWidth / 3, 0, 0, true },
					Position = { x, height }
				})

				self.outerFireParticles:updateParticleSystemProperties({
					EmissionArea = { "normal", maxWidth / 3, 0, 0, true },
					Position = { x, height - 16 }
				})

				self.innerFireParticles:emit(math.floor(maxWidth / 6) + 1, math.floor(maxWidth / 7) + 2)
				self.outerFireParticles:emit(math.floor(maxWidth / 7) + 2, math.floor(maxWidth / 8) + 3)

				x = x + stepWidth
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
	local currentZealColor = Color.fromHexString(CONFIG:get(COLOR_PATH, "color", currentColorName))

	local outerZealColor = (self.currentZealColor or currentZealColor):lerp(currentZealColor, delta)
	self.outerFireParticles:setTintColor(outerZealColor)

	local innerZealColor = outerZealColor:shiftHSL(self.innerHueShift, self.innerSaturationShift, self.innerLightnessShift)
	self.innerFireParticles:setTintColor(innerZealColor)
end

function StandardZealBar:draw(resources, state)
	local width, height = self:getSize()
	local remainderColor = Color.fromHexString(CONFIG:get(COLOR_PATH, "color", "ui.combat.zeal.remainder"))

	love.graphics.push("all")

	love.graphics.setColor(remainderColor:get())
	itsyrealm.graphics.rectangle("fill", 0, 0, width, height, height / 4, height / 4)

	love.graphics.pop()
end

return StandardZealBar
