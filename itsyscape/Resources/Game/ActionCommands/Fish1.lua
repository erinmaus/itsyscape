--------------------------------------------------------------------------------
-- Resources/Game/ActionCommands/Fish1.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Config = require "ItsyScape.Game.Config"
local Color = require "ItsyScape.Graphics.Color"
local ActionCommand = require "ItsyScape.Game.ActionCommand"

local Fish = Class(ActionCommand)
Fish.HIT_INTERVAL = 0.25 
Fish.OFFSET = 16
Fish.VELOCITY = 2

function Fish:new(...)
	ActionCommand.new(self, ...)

	self:getRoot():setSize(256, 48)

	self.bar = ActionCommand.Bar()
	self.bar:setSize(256, 48)
	self.bar:setBackgroundColor(Color(0, 0, 1))
	self:addChild(self.bar)

	self.fish = ActionCommand.Icon()
	self.fish:setIcon(string.format("Resources/Game/Items/%s/Icon.png", self:getOutputItem()))
	self.fish:setSize(48, 48)
	self:addChild(self.fish)

	self.rectangleContainer = ActionCommand.Component()
	self.rectangleContainer:setSize(48, 48)
	self:addChild(self.rectangleContainer)

	self.innerRectangle = ActionCommand.Rectangle()
	self.innerRectangle:setLineWidth(2)
	self.innerRectangle:setRadius(4)
	self.rectangleContainer:addChild(self.innerRectangle)

	self.outerRectangle = ActionCommand.Rectangle()
	self.outerRectangle:setSize(48, 48)
	self.outerRectangle:setLineWidth(4)
	self.outerRectangle:setRadius(4)
	self.rectangleContainer:addChild(self.outerRectangle)

	self.rectangleButton = ActionCommand.Button()
	self.rectangleButton:setStandardButton("mouse_horizontal")
	self.rectangleButton:setGamepadButton("stick_l_horizontal")
	self.rectangleButton:setPosition(0, 56)
	self.rectangleButton:setSize(48, 48)
	self.rectangleContainer:addChild(self.rectangleButton)

	self.hitTimer = 0
	self:moveFish()

	self.cursorX = 0.5
	self.cursorXVelocity = 0
end

function Fish:moveFish()
	self.oldFishTargetX = self.newFishTargetX or 0
	self.newFishTargetX = love.math.random(0, self:getRoot():getWidth())
end

function Fish:hit()
	if self.hitTimer > 0 then
		return
	end

	local distance = math.abs(self.rectangleContainer:getX() - self.fish:getX())
	local delta = 1 - math.clamp(distance / (self.rectangleContainer:getWidth() / 2))
	self:onHit(delta)

	self.hitTimer = self.HIT_INTERVAL
	self:moveFish()
end

function Fish:onButtonDown(controller, button)
	ActionCommand.onButtonDown(self, controller, button)

	if (controller == "mouse" and button == 1) or
	   (controller == "gamepad" and button == "a")
	then
		self:hit()
	end
end

function Fish:onXAxis(controller, value)
	ActionCommand.onXAxis(controller, value)

	if controller == "mouse" then
		self.cursorXVelocity = 0
		self.cursorX = value
	else
		local axisSensitivity = Config.get("Input", "KEYBIND", "type", "ui", "name", "axisSensitivity") or 0
		if math.abs(value) > axisSensitivity then
			self.cursorXVelocity = value
		else
			self.cursorXVelocity = 0
		end
	end
end

function Fish:update(delta)
	ActionCommand.update(self, delta)

	local s = math.sin(love.timer.getTime() * math.pi / 4) * 4 + 64

	self.cursorX = math.clamp(self.cursorX + self.cursorXVelocity * self.VELOCITY * delta, -1, 1)
	local rectangleContainerX = (self.cursorX + 1) / 2 * self:getRoot():getWidth()
	self.rectangleContainer:setX(rectangleContainerX - self.rectangleContainer:getWidth() / 2)

	self.innerRectangle:setSize(s, s)
	self.innerRectangle:setPosition(
		(self.rectangleContainer:getWidth() - s) / 2,
		(self.rectangleContainer:getWidth() - s) / 2)

	self.hitTimer = math.max(self.hitTimer - delta, 0)

	local x = math.lerp(self.oldFishTargetX, self.newFishTargetX, 1 - math.clamp(self.hitTimer / self.HIT_INTERVAL))
	x = x + math.sin(love.timer.getTime() * math.pi) * Fish.OFFSET

	self.fish:setX(x - self.fish:getWidth() / 2)

	local distance = self.rectangleContainer:getX() - self.fish:getX()
	if math.abs(distance) <= self.rectangleContainer:getWidth() / 2 then
		self.rectangleButton:setStandardButton("mouse_left")
		self.rectangleButton:setGamepadButton("a")
	else
		self.rectangleButton:setStandardButton("mouse_horizontal")
		self.rectangleButton:setGamepadButton("stick_l_horizontal")
	end

	local goColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.shimmer.attackable"))
	local readyColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.shimmer.interactive"))
	local inactiveColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.shimmer.unselected"))

	if self.hitTimer > 0 then
		self.innerRectangle:setColor(inactiveColor)
		self.outerRectangle:setColor(inactiveColor)
	elseif math.abs(distance) <= self.rectangleContainer:getWidth() / 2 then
		self.innerRectangle:setColor(goColor)
		self.outerRectangle:setColor(goColor)
	else
		self.innerRectangle:setColor(readyColor)
		self.outerRectangle:setColor(readyColor)
	end
end

return Fish
