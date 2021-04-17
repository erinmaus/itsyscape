--------------------------------------------------------------------------------
-- ItsyScape/TextEffectApplication.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Application = require "ItsyScape.Application"
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local Renderer = require "ItsyScape.Graphics.Renderer"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"

local TextEffectApplication = Class(Application)

local FRAGMENT = [[
	uniform float scape_Scale;
	uniform float scape_Time;
	uniform Image scape_Fill;

	vec4 effect(vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinates)
	{
		vec4 textureColor = vec4(vec3(1.0), Texel(texture, textureCoordinate).a);
		vec4 fillColor = Texel(scape_Fill, textureCoordinate * scape_Scale + vec2(scape_Time, scape_Time));
		return textureColor * fillColor;
	}
]]

local VERTEX = [[
	vec4 position(mat4 transform, vec4 position)
	{
		return transform * position;
	}
]]

local IMAGES = {
	"card01-mystery",
	"card02-skills",
	"card03-fighting",
	"card04-bosses",
	"card05-future"
}

local CHARACTERS = {
	{
		peep = "Tinkerer",
		animation = "walk",
		position = Vector(6, 3.5, -2),
		rotation = math.pi / 8
	},
	{
		peep = "Drakkenson_Kvre",
		animation = "idle",
		position = Vector(-6, 5, -5),
		rotation = -math.pi / 8
	},
	{
		peep = "Emily_Default",
		animation = "walk",
		position = Vector(6, 0, -6),
		rotation = math.pi / 8,
	},
	{
		peep = "Yendorian_Base",
		animation = "idle",
		position = Vector(-7, 0, -6),
		rotation = -math.pi / 8,
	},
	{
		peep = "Sailing_Nyan",
		animation = "idle-sit",
		position = Vector(7.5, 0, -6),
		rotation = math.pi / 8,
	}
}

function TextEffectApplication:new()
	Application.new(self)

	self.text = {}
	self.blur = {}

	for i = 1, #IMAGES do
		local baseFilename = string.format("Resources/Promo/Meme2/%s", IMAGES[i])
		table.insert(self.text, love.graphics.newImage(baseFilename .. ".png"))
		table.insert(self.blur, love.graphics.newImage(baseFilename .. "-bg.png"))
	end

	self.elapsedTime = 0

	self.shader = love.graphics.newShader(FRAGMENT, VERTEX)

	self.textFill = love.graphics.newImage("Resources/Promo/Meme2/TextFill.png")
	self.textFill:setWrap('repeat')

	self.background = love.graphics.newImage("Resources/Promo/Meme2/Background.png")
	self.background:setWrap('repeat')

	self.index = 1
	self.init = false
	self.peepRenderer = Renderer()
	self.peepCamera = ThirdPersonCamera()

	self:initPeeps()
end

function TextEffectApplication:initPeeps()
	local stage = self:getGame():getStage()
	local gameView = self:getGameView()

	self.actors = {}
	for i = 1, #CHARACTERS do
		local resource = string.format("resource://%s", CHARACTERS[i].peep)
		local success, actor = stage:spawnActor(resource)

		if success then
			self.actors[i] = actor
		else
			Log.warn("Couldn't spawn peep '%s'.", CHARACTERS[i])
		end
	end
end

function TextEffectApplication:update(delta)
	Application.update(self, delta)
	self.elapsedTime = self.elapsedTime + delta
end

function TextEffectApplication:keyDown(...)
	self.index = self.index + 1
	if self.index > #IMAGES then
		self.index = 1
	end

	local actor = self.actors[self.index]
	if actor then
		local peep = actor:getPeep()
		local animationName = "animation-" .. CHARACTERS[self.index].animation
		local animationResource = peep:getResource(animationName, "ItsyScape.Graphics.AnimationResource")

		actor:playAnimation('main', 0, animationResource, true, 0)
	end

	return Application.keyDown(self, ...)
end

function TextEffectApplication:draw()
	local w, h = love.window.getMode()

	local gameCamera = self:getCamera()
	self.peepCamera:setHorizontalRotation(gameCamera:getHorizontalRotation())
	self.peepCamera:setVerticalRotation(gameCamera:getVerticalRotation() + CHARACTERS[self.index].rotation)
	self.peepCamera:setDistance(gameCamera:getDistance() - 10)

	self.peepRenderer:setClearColor(Color(0, 0, 0, 0))
	self.peepRenderer:setCullEnabled(false)
	self.peepRenderer:setCamera(self.peepCamera)
	self.peepCamera:setWidth(w)
	self.peepCamera:setHeight(h)
	self.peepCamera:setPosition(CHARACTERS[self.index].position)

	love.graphics.push('all')
	self.peepRenderer:draw(
		self:getGameView():getActor(self.actors[self.index]):getSceneNode(),
		self:getFrameDelta(),
		w, h)
	love.graphics.pop()

	local texture = self.peepRenderer:getOutputBuffer():getColor()

	do
		local s = 10 * math.abs(math.sin(self.elapsedTime * 2)) / 255
		love.graphics.clear(239 / 255 - s, 224 / 255 - s, 243 / 255 - s, 1)
		love.graphics.draw(self.background, 0, 0)
		love.graphics.setColor(1, 1, 1, 0.6)
		love.graphics.draw(texture, 0, h, 0, 1, -1)
		love.graphics.setColor(1, 1, 1, 1)
	end

	do
		local blur = self.blur[self.index]
		love.graphics.setShader(self.shader)
		self.shader:send("scape_Time", self.elapsedTime)
		self.shader:send("scape_Fill", self.textFill)
		self.shader:send("scape_Scale", 4)
		love.graphics.setColor(255 / 255, 204 / 255, 0 / 255, 1)
		love.graphics.draw(blur, w / 2, h / 2, 0, 2, 2, blur:getWidth() / 2, blur:getHeight() / 2)
	end

	do
		local text = self.text[self.index]
		love.graphics.setShader()
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(text, w / 2, h / 2, 0, 0.5, 0.5, text:getWidth() / 2, text:getHeight() / 2)
	end
end

return TextEffectApplication
