--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/StandardHealthBar.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local Utility = require "ItsyScape.Game.Utility"
local Variables = require "ItsyScape.Game.Variables"
local Drawable = require "ItsyScape.UI.Drawable"
local Widget = require "ItsyScape.UI.Widget"
local Particles = require "ItsyScape.UI.Particles"
local StandardBarLabel = require "ItsyScape.UI.Interfaces.Components.StandardBarLabel"

local StandardHealthBar = Class(Drawable)

local CONFIG = Variables.load("Resources/Game/Variables/Config.json")
local COLOR_PATH = Variables.Path("colors", Variables.PathParameter("color"))

function StandardHealthBar:new()
	Drawable.new(self)

	self.bloodSplats = {}
	self.bloodSplatFadeTime = 0.25
	self.bloodSplatScale = 1.5
	self.bloodSplatSlide = 0.25
	self.bloodSplatHueShift = 0.05
	self.bloodSplatLightnessShift = 0.2
	self.padding = 4

	self.healthParticles = Particles()
	self.healthParticles:setOverflow(false)
	self.healthParticles:setTexture("Resources/Game/UI/Particles/Combat/Heal.png")
	self.healthParticles:updateParticleSystemProperties({
		Direction = { math.rad(0) },
		Spread = { math.rad(90) },
		LinearAcceleration = { 0, -128, 0, -160 },
		ParticleLifetime = { 0.5, 1 },
		Sizes = { 1, 0.5 },
		Speed = { -16, -32 },
		Colors = {
			{ 1, 1, 1, 0 },
			{ 1, 1, 1, 1 },
			{ 1, 1, 1, 1 },
			{ 1, 1, 1, 1 },
			{ 1, 1, 1, 0 }
		}
	})
	self:addChild(self.healthParticles)

	self.label = StandardBarLabel()
	self:addChild(self.label)

	self.currentHealth = 1
	self.maximumHealth = 1
	self.currentRelativeValue = 100

	self.isReady = false
end

function StandardHealthBar:_random()
	return love.math.random()
end

function StandardHealthBar:_calculateRelativeValue(currentValue, maximumValue)
	if currentValue == math.huge then
		return 1
	end

	if maximumValue == math.huge then
		maximumValue = math.max(currentValue, 1000)
	end

	return currentValue / maximumValue
end

function StandardHealthBar:_heal(nextRelativeAmount, currentRelativeAmount)
	local relativeWidth = math.abs(nextRelativeAmount - currentRelativeAmount)

	local width, height = self:getSize()

	local particleWidth = (relativeWidth * width) / 4
	local particleHeight = 2

	local x = currentRelativeAmount * width + (relativeWidth * width) / 2
	local y = height + 8

	self.healthParticles:updateParticleSystemProperties({
		EmissionArea = { "normal", particleWidth, particleHeight, 0, true },
		Position = { x, y }
	})

	local min = math.max((relativeWidth * width) - 16, 1)
	local max = math.max((relativeWidth * width) + 16, 8)
	self.healthParticles:emit(min, max)

	for _, bloodSplat in ipairs(self.bloodSplats) do
		if bloodSplat.x < nextRelativeAmount and bloodSplat.isFadingIn then
			bloodSplat.isFadingIn = false
			bloodSplat.isFadingOut = true
			bloodSplat.targetTime = self:_random() * self.bloodSplatFadeTime
			bloodSplat.currentTime = 0
		end
	end
end

function StandardHealthBar:_damage(nextRelativeAmount, currentRelativeAmount)
	local relativeWidth = math.abs(nextRelativeAmount - currentRelativeAmount)

	local width, height = self:getSize()

	local particleWidth = relativeWidth * width / 3
	local x = (currentRelativeAmount * width) + particleWidth / 2

	local minNumBloodSplats = math.max(math.floor(relativeWidth * width / 2) - 4, 2)
	local maxNumBloodSplats = math.max(math.floor(relativeWidth * width / 2) + 4, 4)
	local numBloodSplats = love.math.random(minNumBloodSplats, maxNumBloodSplats)

	local normal = Vector((self:_random() - 0.5) * 2, (self:_random() - 0.5) * 2, 0):getNormal()

	local offset = 0
	for i = 1, numBloodSplats do
		local bloodSplat = {
			isFadingIn = true,
			isFadingOut = false,
			x = self:_random() * relativeWidth + nextRelativeAmount,
			y = self:_random(),
			slideX = normal.x * self:_random() * self.bloodSplatSlide,
			slideY = normal.y * self:_random() * self.bloodSplatSlide,
			scale = self:_random() * self.bloodSplatScale,
			targetTime = self:_random() * self.bloodSplatFadeTime,
			rotation = love.math.random() * math.pi * 2,
			hueShift = self:_random() * self.bloodSplatHueShift,
			lightnessShift = self:_random() * self.bloodSplatLightnessShift,
			currentTime = 0,
			alpha = 0
		}

		table.insert(self.bloodSplats, bloodSplat)
	end
end

function StandardHealthBar:updateHealth(current, maximum)
	current = current or 1
	maximum = maximum or 1

	local nextRelative = math.floor(self:_calculateRelativeValue(current, maximum) * 100)
	local currentRelative = self.currentRelativeValue

	if current ~= 0 then
		nextRelative = math.max(nextRelative, 1)
	end

	if nextRelative > currentRelative then
		self:_heal(nextRelative / 100, currentRelative / 100)
	elseif nextRelative < currentRelative then
		self:_damage(nextRelative / 100, currentRelative / 100)
	end

	self.currentRelativeValue = nextRelative
	self.currentHealth = current
	self.maximumHealth = maximum

	self.label:setText(string.format("%s/%s", Utility.Text.prettyNumber(current), Utility.Text.prettyNumber(maximum)))
end

function StandardHealthBar:update(delta)
	Drawable.update(self, delta)

	for i = #self.bloodSplats, 1, -1 do
		local bloodSplat = self.bloodSplats[i]

		if bloodSplat.currentTime == bloodSplat.targetTime and bloodSplat.isFadingOut then
			table.remove(self.bloodSplats, i)
		else
			bloodSplat.currentTime = math.min(bloodSplat.currentTime + delta, bloodSplat.targetTime)

			if bloodSplat.isFadingIn then
				bloodSplat.alpha = bloodSplat.currentTime / bloodSplat.targetTime
			elseif bloodSplat.isFadingOut then
				bloodSplat.alpha = 1 - (bloodSplat.currentTime / bloodSplat.targetTime)
			else
				bloodSplat.alpha = 1
			end
		end
	end
end

function StandardHealthBar:loadStatic(resources)
	if self.isReady then
		return
	end

	self.bloodSplatImage = resources:load(
		love.graphics.newImage,
		"Resources/Game/UI/Particles/Combat/BloodSplat.png")

	self.isReady = true
end

function StandardHealthBar:draw(resources, state)
	self:loadStatic(resources)

	local width, height = self:getSize()
	local scale = height / self.bloodSplatImage:getHeight()

	local damageColor = Color.fromHexString(CONFIG:get(COLOR_PATH, "color", "ui.combat.health.damage"))
	local hitpointsColor = Color.fromHexString(CONFIG:get(COLOR_PATH, "color", "ui.combat.health.hitpoints"))

	local damageWidth = (1 - (self.currentRelativeValue / 100)) * width

	love.graphics.push("all")
	love.graphics.setColor(hitpointsColor:get())
	itsyrealm.graphics.rectangle("fill", 0, 0, width, height, 4, 4)

	if damageWidth > 0 then
		damageWidth = math.max(damageWidth, 8)
		love.graphics.setColor(damageColor:get())
		itsyrealm.graphics.rectangle("fill", width - damageWidth, 0, damageWidth, height, 4, 4)
	end

	itsyrealm.graphics.applyPseudoScissor()
	for _, bloodSplat in ipairs(self.bloodSplats) do
		local color = damageColor:shiftHSL(bloodSplat.hueShift, nil, bloodSplat.lightnessShift)
		color.a = bloodSplat.alpha

		local x = bloodSplat.x * width
		local y = bloodSplat.y * height

		local slideX = bloodSplat.slideX * width * (1 - bloodSplat.alpha)
		local slideY = bloodSplat.slideY * height * (1 - bloodSplat.alpha)

		x = x + slideX
		y = y + slideY

		local localScale = scale * bloodSplat.scale * bloodSplat.alpha
		local imageWidth = self.bloodSplatImage:getWidth() * localScale
		local imageHeight = self.bloodSplatImage:getHeight() * localScale

		love.graphics.setColor(color:get())
		itsyrealm.graphics.draw(self.bloodSplatImage, x, y, bloodSplat.rotation, localScale, localScale, imageWidth / 2, imageHeight / 2)
	end

	itsyrealm.graphics.resetPseudoScissor()
	love.graphics.pop()
end

return StandardHealthBar
