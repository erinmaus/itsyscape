--------------------------------------------------------------------------------
-- Resources/Game/Sprites/ClassChange.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Weapon = require "ItsyScape.Game.Weapon"
local Color = require "ItsyScape.Graphics.Color"
local Sprite = require "ItsyScape.Graphics.Sprite"
local FontResource = require "ItsyScape.Graphics.FontResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local ClassChange = Class(Sprite)
ClassChange.DURATION = 2
ClassChange.SLIDE_IN_OUT_DISTANCE = 32
ClassChange.BACKGROUND_PADDING = 8
ClassChange.BACKGROUND_COLOR = Color.fromHexString("463779")
ClassChange.TEXT_COLOR = Color.fromHexString("faa92b")
ClassChange.SCALE = 0.75

ClassChange.STYLES = {
	[Weapon.STYLE_MAGIC] = {
		style = "Magic",
		ammo = false,

		particles = {
			duration = 1.5,

			properties = {
				{
					EmissionArea = { "none", 0, 0 },
					EmissionRate = { 30 },
					EmitterLifetime = { 0.5 },
					ParticleLifetime = { 0.25, 0.5 },
					Spin = { math.pi, math.pi * 1.5 },
					SpinVariation = { 1 },
					Sizes = { 1, 0.5 },
					Speed = { 16, 32 },
					Rotation = { math.rad(0), math.rad(360) },
					Colors = {
						{ Color.fromHexString("ff6600", 0):get() },
						{ Color.fromHexString("ff6600"):get() },
						{ Color.fromHexString("ff6600", 0):get() }
					}
				},
				{
					EmissionArea = { "none", 0, 0 },
					EmissionRate = { 30 },
					EmitterLifetime = { 0.5 },
					ParticleLifetime = { 0.5, 0.75 },
					Spin = { math.pi, math.pi * 1.5 },
					SpinVariation = { 1 },
					Sizes = { 0.5, 1 },
					Speed = { 32, 64 },
					Rotation = { math.rad(0), math.rad(360) },
					Colors = {
						{ Color.fromHexString("ffd52a"):get() },
						{ Color.fromHexString("ffd52a"):get() },
						{ Color.fromHexString("ffd52a", 0):get() }
					}
				},
				{
					EmissionArea = { "normal", 32, 16, 0, false },
					EmissionRate = { 30 },
					EmitterLifetime = { 0.75 },
					Direction = { math.rad(180) },
					Spread = { math.rad(45) },
					ParticleLifetime = { 0.5, 1 },
					Spin = { math.pi, math.pi * 1.5 },
					SpinVariation = { 1 },
					Speed = { 64, 96 },
					Rotation = { math.rad(0), math.rad(360) },
					Colors = {
						{ Color.fromHexString("ff6600", 0):get() },
						{ Color.fromHexString("ff6600"):get() },
						{ Color.fromHexString("ff6600"):get() },
						{ Color.fromHexString("ffd52a"):get() },
						{ Color.fromHexString("ffd52a"):get() },
						{ Color.fromHexString("ffd52a", 0):get() }
					}
				},
			},

			{
				offsetX = 0,
				offsetY = 0,
				positionX = -64,
				positionY = 0,
				rotation = -math.pi / 4,
				scaleX = 1.5,
				scaleY = 1.5,
				alpha = 1
			},
			{
				offsetX = 0,
				offsetY = 0,
				positionX = 128,
				positionY = 32,
				rotation = 0,
				scaleX = 1,
				scaleY = 1,
				alpha = 1
			}
		},

		weapon = {
			duration = 1,

			{
				offsetX = 64,
				offsetY = 64,
				positionX = -196,
				positionY = 0,
				rotation = -math.pi / 4,
				scaleX = 0.5,
				scaleY = 0.5,
				alpha = 1
			},
			{
				offsetX = 64,
				offsetY = 64,
				positionX = -160,
				positionY = 32,
				rotation = math.pi / 8,
				scaleX = 1.25,
				scaleY = 1.25,
				alpha = 1
			}
		},
	},

	[Weapon.STYLE_ARCHERY] = {
		style = "Archery",

		particles = {
			duration = 2,

			properties = {
				{
					EmissionArea = { "ellipse", 8, 8, 0, true },
					EmissionRate = { 20 },
					Spread = { math.rad(360) },
					EmitterLifetime = { 1 },
					ParticleLifetime = { 0.5, 0.75 },
					Sizes = { 0.5, 0.25 },
					Speed = { 128, 192 },
					Rotation = { math.rad(0), math.rad(360) },
					Colors = {
						{ Color.fromHexString("ffcc00", 0):get() },
						{ Color.fromHexString("ffcc00"):get() },
						{ Color.fromHexString("ffcc00", 0):get() }
					}
				},
				{
					EmissionArea = { "ellipse", 8, 8, 0, true },
					EmissionRate = { 5 },
					Spread = { math.rad(360) },
					EmitterLifetime = { 1 },
					ParticleLifetime = { 0.5, 0.75 },
					Sizes = { 0.5, 0.25 },
					Speed = { 128, 192 },
					Rotation = { math.rad(0), math.rad(360) },
					Colors = {
						{ Color.fromHexString("00ccff", 0):get() },
						{ Color.fromHexString("00ccff"):get() },
						{ Color.fromHexString("00ccff", 0):get() }
					}
				},
			},

			{
				offsetX = 0,
				offsetY = 0,
				positionX = -160,
				positionY = 0,
				rotation = 0,
				scaleX = 1.5,
				scaleY = 1.5,
				alpha = 1
			},
			{
				offsetX = 0,
				offsetY = 0,
				positionX = 256,
				positionY = 0,
				rotation = 0,
				scaleX = 1,
				scaleY = 1,
				alpha = 1
			}
		},

		weapon = {
			duration = 1,

			{
				offsetX = 64,
				offsetY = 64,
				positionX = -160,
				positionY = 0,
				rotation = 0,
				scaleX = 1,
				scaleY = 1,
				alpha = 1
			},
			{
				offsetX = 64,
				offsetY = 64,
				positionX = -128,
				positionY = 0,
				rotation = 0,
				scaleX = 1.25,
				scaleY = 1.25,
				alpha = 1
			}
		},

		ammo = {
			duration = 2,

			{
				offsetX = 64,
				offsetY = 64,
				positionX = -160,
				positionY = 0,
				rotation = 0,
				scaleX = 1.5,
				scaleY = 1.5,
				alpha = 1
			},
			{
				offsetX = 64,
				offsetY = 64,
				positionX = 256,
				positionY = 0,
				rotation = 0,
				scaleX = 0.5,
				scaleY = 0.5,
				alpha = 0
			}
		}
	},

	[Weapon.STYLE_MELEE] = {
		style = "Melee",
		ammo = false,

		particles = {
			duration = 1,
			properties = {
				{
					EmissionArea = { "none", 0, 0 },
					Direction = { math.rad(0) },
					Spread = { math.rad(20) },
					LinearAcceleration = { 0, 96, 0, 128 },
					ParticleLifetime = { 0.5, 1 },
					Spin = { math.pi, math.pi * 1.5 },
					SpinVariation = { 1 },
					Sizes = { 1, 0.5 },
					Speed = { 160, 196 },
					Rotation = { math.rad(0), math.rad(360) },
					Colors = {
						{ 1, 0.15, 0.15, 0 },
						{ 1, 0.15, 0.15, 1 },
						{ 0.8, 0.15, 0.15, 1 },
						{ 0.7, 0.2, 0.2, 1 },
						{ 0.7, 0.2, 0.2, 0 },
					},

					min = 20,
					max = 30
				},
				{
					EmissionArea = { "none", 0, 0 },
					Direction = { math.rad(10) },
					Spread = { math.rad(10) },
					LinearAcceleration = { 0, 96, 0, 128 },
					ParticleLifetime = { 0.5, 0.75 },
					Spin = { math.pi, math.pi * 1.5 },
					SpinVariation = { 1 },
					Sizes = { 0.75, 0.25 },
					Speed = { 160, 256 },
					Colors = {
						{ 0.5, 0.15, 0.15, 0 },
						{ 0.5, 0.25, 0.25, 1 },
						{ 0.5, 0.25, 0.25, 1 },
						{ 0.5, 0.25, 0.25, 0 }
					},

					min = 15,
					max = 30
				},
				{
					EmissionArea = { "none", 0, 0 },
					Direction = { math.rad(45) },
					Spread = { math.rad(45) },
					LinearAcceleration = { 0, 192, 0, 256 },
					ParticleLifetime = { 0.5, 1 },
					Spin = { math.pi, math.pi * 1.5 },
					SpinVariation = { 1 },
					Sizes = { 0.5, 0.25 },
					Speed = { 256, 320 },
					Colors = {
						{ 0.8, 0.25, 0.25, 1 }
					},

					min = 15,
					max = 20
				}
			},

			{
				offsetX = 0,
				offsetY = 0,
				positionX = -32,
				positionY = 0,
				rotation = -math.pi / 4,
				scaleX = 1,
				scaleY = 1,
				alpha = 1
			},
			{
				offsetX = 0,
				offsetY = 0,
				positionX = 128,
				positionY = 0,
				rotation = 0,
				scaleX = 1,
				scaleY = 1,
				alpha = 1
			}
		},

		weapon = {
			duration = 1,

			{
				offsetX = 76,
				offsetY = 64,
				positionX = -196,
				positionY = -32,
				rotation = -math.pi / 4,
				scaleX = 1,
				scaleY = 1,
				alpha = 1
			},
			{
				offsetX = 76,
				offsetY = 64,
				positionX = -64,
				positionY = 32,
				rotation = 0,
				scaleX = 1.25,
				scaleY = 1.25,
				alpha = 1
			}
		}
	}
}

function ClassChange:new(...)
	Sprite.new(self, ...)

	local resources = self:getSpriteManager():getResources()
	resources:queue(
		FontResource,
		"Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf@48",
		function(font)
			self.font = font
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Sprites/ClassChange/ClassChange.png",
		function(background)
			self.background = background
		end)

	self.ready = false
end

function ClassChange:spawn(combatStyle)
	local resources = self:getSpriteManager():getResources()

	local style = self.STYLES[combatStyle]

	resources:queue(
		TextureResource,
		string.format("Resources/Game/Sprites/ClassChange/%sWeapon.png", style.style),
		function(weapon)
			self.weaponTexture = weapon
			weapon:getResource():setFilter("linear", "linear")
		end)

	self.particles = {}
	resources:queue(
		TextureResource,
		string.format("Resources/Game/Sprites/ClassChange/%sParticle.png", style.style),
		function(particle)
			self.particleTexture = particle
			particle:getResource():setFilter("linear", "linear")

			if style.particles and style.particles.properties then
				for _, properties in ipairs(style.particles.properties) do
					local particles = love.graphics.newParticleSystem(particle:getResource())
					self:initParticleSystem(particles, {
							Quads = {
								love.graphics.newQuad(0, 0, 128, 128, 512, 128),
								love.graphics.newQuad(128, 0, 128, 128, 512, 128),
								love.graphics.newQuad(256, 0, 128, 128, 512, 128),
								love.graphics.newQuad(384, 0, 128, 128, 512, 128)
							},
							Offset = { 64, 64 }
						})
					self:initParticleSystem(particles, properties)

					if properties.min and properties.max then
						particles:emit(love.math.random(properties.min, properties.max))
					end

					table.insert(self.particles, particles)
				end
			end
		end)

	if style.ammo then
		resources:queue(
			TextureResource,
			string.format("Resources/Game/Sprites/ClassChange/%sAmmo.png", style.style),
			function(ammo)
				self.ammoTexture = ammo
				ammo:getResource():setFilter("linear", "linear")
			end)
	end

	resources:queueEvent(function()
		self.ready = true
	end)

	self.text = itsyrealm.language.get("sprite.classChange.change")
	self.style = style
end

function ClassChange:isDone(time)
	return time > ClassChange.DURATION
end

function ClassChange:update(delta)
	Sprite.update(self, delta)

	if not self.ready then
		return
	end

	for _, particles in ipairs(self.particles) do
		particles:update(delta)
	end
end

function ClassChange:_drawPart(drawable, animation, position, time)
	if not (drawable and animation) then
		return
	end

	local duration = animation.duration
	local delta = Tween.sineEaseOut(math.clamp(time / duration))
	local from = animation[1]
	local to = animation[2]

	local offsetX = math.lerp(from.offsetX, to.offsetX, delta)
	local offsetY = math.lerp(from.offsetY, to.offsetY, delta)
	local positionX = math.lerp(from.positionX, to.positionX, delta)
	local positionY = math.lerp(from.positionY, to.positionY, delta)
	local rotation = math.lerpAngle(from.rotation, to.rotation, delta)
	local scaleX = math.lerp(from.scaleX, to.scaleX, delta)
	local scaleY = math.lerp(from.scaleY, to.scaleY, delta)
	local alpha = math.lerp(from.alpha, to.alpha, delta)

	local r, g, b, a = love.graphics.getColor()

	love.graphics.setColor(r, g, b, a * alpha)
	love.graphics.draw(
		drawable,
		position.x + positionX,
		position.y + positionY,
		rotation,
		scaleX * self.SCALE,
		scaleY * self.SCALE,
		offsetX,
		offsetY)

	love.graphics.setColor(r, g, b, a)
end

function ClassChange:draw(position, time)
	if not self.ready then
		return
	end

	local delta = time / self.DURATION
	local mu = math.clamp(math.sin(delta * math.pi) * 2)

	local textOffsetX
	if delta > 0.5 then
		textOffsetX = self.SLIDE_IN_OUT_DISTANCE * (1 - mu)
	else
		textOffsetX = -self.SLIDE_IN_OUT_DISTANCE * (1 - mu)
	end

	local alpha = mu

	local oldFont = love.graphics.getFont()

	local font = self.font:getResource()
	local background = self.background:getResource()

	love.graphics.setFont(font)
	local textWidth = font:getWidth(self.text)

	local r, g, b = self.BACKGROUND_COLOR:get()
	love.graphics.setColor(r, g, b, alpha)

	love.graphics.setBlendMode("add")
	love.graphics.draw(
		background,
		position.x,
		position.y,
		0,
		2 * self.SCALE,
		2 * self.SCALE,
		background:getWidth() / 2,
		background:getHeight() / 2)
	love.graphics.setBlendMode("alpha")

	love.graphics.setColor(1, 1, 1, alpha)

	for _, particles in ipairs(self.particles) do
		self:_drawPart(particles, self.style.particles, position, time)
	end

	self:_drawPart(self.weaponTexture and self.weaponTexture:getResource(), self.style.weapon, position, time)
	self:_drawPart(self.ammoTexture and self.ammoTexture:getResource(), self.style.ammo, position, time)

	do
		love.graphics.setColor(0, 0, 0, alpha)
		love.graphics.printf(
			self.text,
			position.x + 2 + textOffsetX,
			position.y + 2,
			font:getWidth(self.text),
			"center",
			0,
			self.SCALE,
			self.SCALE,
			textWidth / 2,
			font:getHeight() / 2)
	end

	local tr, tg, tb = self.TEXT_COLOR:get()
	do
		love.graphics.setColor(tr, tg, tb, alpha)
		love.graphics.printf(
			self.text,
			position.x + textOffsetX,
			position.y,
			font:getWidth(self.text),
			"center",
			0,
			self.SCALE,
			self.SCALE,
			textWidth / 2,
			font:getHeight() / 2)
	end

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(oldFont)
end

return ClassChange
