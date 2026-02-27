--------------------------------------------------------------------------------
-- Resources/Game/ActionCommands/Woodcut1.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local ActionCommand = require "ItsyScape.Game.ActionCommand"
local Config = require "ItsyScape.Game.Config"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Probe = require "ItsyScape.Peep.Probe"

local Woodcut1 = Class(ActionCommand)
Woodcut1.HIT_INTERVAL = 0.5
Woodcut1.VELOCITY = math.pi / 32
Woodcut1.MIN_DISTANCE = math.pi / 16
Woodcut1.NEAR_DISTANCE = math.pi / 8

Woodcut1.SPARKLE_MIN_IDLE_DURATION_SECONDS = 3
Woodcut1.SPARKLE_MAX_IDLE_DURATION_SECONDS = 5
Woodcut1.SPARKLE_RADIUS = 2
Woodcut1.SPARKLE_VELOCITY = math.pi / 4

Woodcut1.MAP = "Skilling_Woodcutting1"

function Woodcut1:new(...)
	ActionCommand.new(self, ...)

	self:getRoot():setSize(540, 400)

	self.map = ActionCommand.Map()
	self.map:setSize(540, 400)
	self.map:setDistance(25)
	self:addChild(self.map)

	self.rectangleContainer = ActionCommand.Component()
	self.rectangleContainer:setPosition(-24, -24)
	self.rectangleContainer:setSize(48, 48)
	self.map:addChild(self.rectangleContainer)

	self.toolIcon = ActionCommand.Item()
	self.toolIcon:setSize(48, 48)
	self.toolIcon:setItem(self:getToolResource())
	self.rectangleContainer:addChild(self.toolIcon)

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
	self.rectangleButton:setStandardButton("keyboard_arrows")
	self.rectangleButton:setGamepadButton("stick_l")
	self.rectangleButton:setPosition(0, 56)
	self.rectangleButton:setSize(48, 48)
	self.rectangleContainer:addChild(self.rectangleButton)

	self.mapLayer, self.mapScript = self:newMap(self.MAP, function(mapLayer, mapScript)
		self.map:setMap(mapScript)

		local treeProp = Utility.spawnPropAtAnchor(mapScript, Utility.Peep.getResource(self:getTarget()), "Anchor_Spawn")
		self.tree = treeProp and treeProp:getPeep()

		self.cursor = self:getDirector():probe(
			self:getPeep():getLayerName(),
			Probe.layer(mapLayer),
			Probe.namedMapObject("Cursor"))[1]

		self.sparkle = self:getDirector():probe(
			self:getPeep():getLayerName(),
			Probe.layer(mapLayer),
			Probe.namedMapObject("SparkleCursor"))[1]

		self.rectangleContainer:setTarget(self.tree)
	end) 

	self.hitTimer = 0

	self.sparkleTimer = 0
	self.targetSparkleAngle = 0
	self.currentSparkleAngle = false
	self.currentCursorAngle = 0
end

function Woodcut1:close()
	ActionCommand.close(self)

	if self.tree then
		Utility.Peep.poof(self.tree)
	end
end

function Woodcut1:hit()
	if self.hitTimer > 0 then
		return
	end

	self:onHit(love.math.random())

	self.tree:poke("chop", { peep = self:getPeep(), tool = self:getTool() })

	self.hitTimer = self.HIT_INTERVAL
end

function Woodcut1:placeCursor(peep, angle)
	local x, y, z = Utility.Map.getAnchorPosition(
		self:getGame(),
		Utility.Peep.getResource(self.mapScript),
		"Anchor_Spawn")

	x = x + math.cos(angle) * self.SPARKLE_RADIUS
	z = z + math.sin(angle) * self.SPARKLE_RADIUS

	local map = Utility.Peep.getMap(self.mapScript)
	y = map:getInterpolatedHeight(x, z)

	Utility.Peep.setPosition(peep, Vector(x, y, z))
end

function Woodcut1:updateCursorPosition(delta)
	if not self.cursor then
		return
	end

	local x = self:getInputDirection()
	local velocityX = -x * self.VELOCITY

	self.currentCursorAngle = self.currentCursorAngle + velocityX
	self:placeCursor(self.cursor, self.currentCursorAngle)
end

function Woodcut1:updateMapCamera()
	if self.tree then
		self.map:setOffset(Utility.Peep.getPosition(self.tree))
	end

	self.map:setVerticalRotation(-self.currentCursorAngle + math.pi * 2)
end

function Woodcut1:calculateDistance()
	if not self.currentSparkleAngle then
		return math.huge
	end

	local sparkleAngle = self.currentSparkleAngle % (math.pi * 2)
	local cursorAngle = self.currentCursorAngle % (math.pi * 2)

	return math.abs(sparkleAngle - cursorAngle)
end

function Woodcut1:onControlDown()
	self:tryHit()
end

function Woodcut1:tryHit()
	local distance = self:calculateDistance()

	if distance <= self.MIN_DISTANCE then
		self:hit()
	end
end

function Woodcut1:updateCursorColor(distance)
	local goColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.resource.hit"))
	local warmColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.resource.warm"))
	local readyColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.resource.ready"))

	local isHot = distance <= self.MIN_DISTANCE
	local isWarm = not isHot and distance <= self.NEAR_DISTANCE
	local isCold = not (isHot or isWarm)

	if isHot then
		self.innerRectangle:setColor(goColor)
		self.outerRectangle:setColor(goColor)

		self.rectangleButton:setControl("poke")
		self.rectangleButton:setGamepadButton()
		self.rectangleButton:setStandardButton()
	else
		self.rectangleButton:setControl()
		self.rectangleButton:setGamepadButton("stick_l")
		self.rectangleButton:setStandardButton("keyboard_arrows")
	end

	if isWarm then
		local delta = (distance - self.MIN_DISTANCE) / (self.NEAR_DISTANCE - self.MIN_DISTANCE)
		local color = readyColor:lerp(warmColor, delta)

		self.innerRectangle:setColor(color)
		self.outerRectangle:setColor(color)
	end

	if isCold then
		self.innerRectangle:setColor(readyColor)
		self.outerRectangle:setColor(readyColor)
	end

	self.stateIsHot = isHot
	self.stateIsWarm = isWarm
	self.stateIsCold = isCold
end

function Woodcut1:moveSparkle(delta)
	if not self.sparkle then
		return
	end

	if not self.currentSparkleAngle then
		self.currentSparkleAngle = self.targetSparkleAngle
		return
	end

	local distance = self.targetSparkleAngle - self.currentSparkleAngle
	local direction = math.sign(distance)
	local offset = math.min(self.SPARKLE_VELOCITY * delta, math.abs(distance))

	self.currentSparkleAngle = self.currentSparkleAngle + offset * direction

	self:placeCursor(self.sparkle, self.currentSparkleAngle)
end

function Woodcut1:updateSparkle(delta)
	self.sparkleTimer = math.max(self.sparkleTimer - delta, 0)

	if self.sparkleTimer == 0 then
		self.sparkleTimer = math.lerp(
			self.SPARKLE_MIN_IDLE_DURATION_SECONDS,
			self.SPARKLE_MAX_IDLE_DURATION_SECONDS,
			love.math.random())

		self.targetSparkleAngle = love.math.random() * math.pi * 2
	end

	self:moveSparkle(delta)
end

function Woodcut1:getMessage()
	if self.stateIsCold then
		return "ui.actionCommand.woodcutting.rotateToCursor"
	elseif self.stateIsWarm then
		return "ui.actionCommand.woodcutting.getCloser"
	elseif self.stateIsHot then
		return "ui.actionCommand.woodcutting.smashButton"
	end

	return "ui.actionCommand.woodcutting.rotateToCursor"
end

function Woodcut1:update(delta)
	ActionCommand.update(self, delta)

	local s = math.sin(love.timer.getTime() * math.pi / 4) * 4 + 64

	self.innerRectangle:setSize(s, s)
	self.innerRectangle:setPosition(
		((self.outerRectangle:getSize() + 4) - (s + 4)) / 2,
		((self.outerRectangle:getSize() + 4) - (s + 4)) / 2)

	self.hitTimer = math.max(self.hitTimer - delta, 0)

	self:updateSparkle(delta)
	self:updateCursorPosition(delta)

	local distance = self:calculateDistance()
	self:updateCursorColor(distance)

	self:updateMapCamera()
end

return Woodcut1
