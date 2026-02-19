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
local Vector = require "ItsyScape.Common.Math.Vector"
local ActionCommand = require "ItsyScape.Game.ActionCommand"
local Config = require "ItsyScape.Game.Config"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Probe = require "ItsyScape.Peep.Probe"

local Fish = Class(ActionCommand)
Fish.HIT_INTERVAL = 0.5
Fish.VELOCITY = 8
Fish.MIN_DISTANCE = 0.25
Fish.NEAR_DISTANCE = 0.5

function Fish:new(...)
	ActionCommand.new(self, ...)

	self:getRoot():setSize(540, 400)

	self.map = ActionCommand.Map()
	self.map:setSize(540, 400)
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

	self.mapLayer, self.mapScript = self:newMap("Skilling_Fishing1", function(mapLayer, mapScript)
		self.map:setMap(mapScript)

		local x, y, z = Utility.Map.getAnchorPosition(
			self:getGame(),
			Utility.Peep.getResource(mapScript),
			"Anchor_Spawn")

		local fishActor = Utility.spawnActorAtPosition(mapScript, "LightningStormfish", x, y, z)
		self.fish = fishActor and fishActor:getPeep()

		self.cursor = self:getDirector():probe(
			self:getPeep():getLayerName(),
			Probe.layer(mapLayer),
			Probe.namedMapObject("Cursor"))[1]

		self.rectangleContainer:setTarget(self.cursor)
	end) 

	self.hitTimer = 0
end

function Fish:close()
	ActionCommand.close(self)

	if self.fish then
		Utility.Peep.poof(self.fish)
	end
end

function Fish:hit()
	if self.hitTimer > 0 then
		return
	end

	self:onHit(love.math.random())

	self.fish:poke("reel", { peep = self:getPeep(), tool = self:getTool() })
	self:getGame():getStage():fireProjectile("FishingSplash", Vector.ZERO, self.fish)

	self.hitTimer = self.HIT_INTERVAL
end

function Fish:updateCursorPositionSize(delta)
	if not self.cursor then
		return
	end

	local scale = math.lerp(1, 1.5, math.sin(math.clamp(self.hitTimer / self.HIT_INTERVAL) * math.pi))
	Utility.Peep.setScale(self.cursor, Vector(scale))

	local x, y = self:getInputDirection()
	local velocityX, velocityY = self.VELOCITY * x, self.VELOCITY * y

	local currentPosition = Utility.Peep.getPosition(self.cursor)
	currentPosition = currentPosition + Vector(velocityX * delta, 0, velocityY * delta)

	local map = Utility.Peep.getMap(self.cursor)
	currentPosition.x = math.clamp(currentPosition.x, 0, map:getWidth() * map:getCellSize())
	currentPosition.z = math.clamp(currentPosition.z, 0, map:getHeight() * map:getCellSize())
	currentPosition.y = map:getInterpolatedHeight(currentPosition.x, currentPosition.z) + 0.5

	Utility.Peep.setPosition(self.cursor, currentPosition)

	self.map:setOffset(Vector(currentPosition.x, 0, currentPosition.z))
end

function Fish:calculateDistance()
	if not (self.cursor and self.fish) then
		return math.huge
	end

	if not (self.cursor:getIsReady() and self.fish:getIsReady()) then
		return math.huge
	end

	local cursorFishDistance = Utility.Peep.getAbsoluteDistance(self.cursor, self.fish)
	return cursorFishDistance
end

function Fish:onControlDown()
	self:tryHit()
end

function Fish:tryHit()
	local distance = self:calculateDistance()

	if distance <= self.MIN_DISTANCE then
		self:hit()
	end
end

function Fish:updateCursorColor(distance)
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
end

function Fish:update(delta)
	ActionCommand.update(self, delta)

	local s = math.sin(love.timer.getTime() * math.pi / 4) * 4 + 64

	self.innerRectangle:setSize(s, s)
	self.innerRectangle:setPosition(
		((self.outerRectangle:getSize() + 4) - (s + 4)) / 2,
		((self.outerRectangle:getSize() + 4) - (s + 4)) / 2)

	self.hitTimer = math.max(self.hitTimer - delta, 0)

	self:updateCursorPositionSize(delta)

	local distance = self:calculateDistance()
	self:updateCursorColor(distance)
end

return Fish
