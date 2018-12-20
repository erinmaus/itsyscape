--------------------------------------------------------------------------------
-- ItsyScape/DemoApplication.lua
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
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local DirectionalLightSceneNode = require "ItsyScape.Graphics.DirectionalLightSceneNode"
local FogSceneNode = require "ItsyScape.Graphics.FogSceneNode"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local DemoApplication = Class(Application)
DemoApplication.CAMERA_HORIZONTAL_ROTATION = -math.pi / 6
DemoApplication.CAMERA_VERTICAL_ROTATION = -math.pi / 2
DemoApplication.MAX_CAMERA_VERTICAL_ROTATION_OFFSET = math.pi / 4
DemoApplication.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET = math.pi / 6 - math.pi / 12

function DemoApplication:new()
	Application.new(self)

	self.isCameraDragging = false
	self.cameraVerticalRotationOffset = 0
	self.cameraHorizontalRotationOffset = 0

	self.previousPlayerPosition = false
	self.currentPlayerPosition = false

	self:getCamera():setHorizontalRotation(DemoApplication.CAMERA_HORIZONTAL_ROTATION)
	self:getCamera():setVerticalRotation(DemoApplication.CAMERA_VERTICAL_ROTATION)
end

function DemoApplication:getPlayerPosition(delta)
	local position
	do
		local gameView = self:getGameView()
		local actor = gameView:getActor(self:getGame():getPlayer():getActor())
		local node = actor:getSceneNode()
		local transform = node:getTransform():getGlobalDeltaTransform(delta or 0)
		position = Vector(transform:transformPoint(0, 0, 0))
	end

	return position
end

function DemoApplication:initialize()
	local storage = love.filesystem.read("Player/Default.dat")
	if storage then
		self:getGame():getDirector():getPlayerStorage(1):deserialize(storage)
	end

	storage = self:getGame():getDirector():getPlayerStorage(1)

	Application.initialize(self)

	local playerPeep = self:getGame():getPlayer():getActor():getPeep()

	if not storage:getRoot():hasSection("Location") or
	   not storage:getRoot():getSection("Location"):get("name")
	then
		self:getGame():getStage():movePeep(
			playerPeep,
		"IsabelleIsland_Tower",
		"Anchor_StartGame")
	end

	self:getGame():getUI():open(playerPeep, "Ribbon")
	self:getGame():getUI():open(playerPeep, "CombatStatusHUD")
end

function DemoApplication:tick()
	Application.tick(self)
end

function DemoApplication:mousePress(x, y, button)
	if not Application.mousePress(self, x, y, button) then
		if button == 1 then
			self:probe(x, y, true)
		elseif button == 2 then
			self:probe(x, y, false)
		elseif button == 3 then
			self.isCameraDragging = true
		end
	end
end

function DemoApplication:mouseRelease(x, y, button)
	Application.mouseRelease(self, x, y, button)

	if button == 3 then
		self.isCameraDragging = false
	end
end

function DemoApplication:mouseScroll(x, y)
	Application.mouseScroll(self, x, y)
	local distance = self.camera:getDistance() - y * 0.5

	if not _DEBUG then
		self:getCamera():setDistance(math.min(math.max(distance, 1), 40))
	else
		self:getCamera():setDistance(distance)
	end
end

function DemoApplication:mouseMove(x, y, dx, dy)
	Application.mouseMove(self, x, y, dx, dy)

	if self.isCameraDragging then
		local angle1 = self.cameraVerticalRotationOffset + dx / 128
		local angle2 = self.cameraHorizontalRotationOffset + -dy / 128

		if not _DEBUG then
			angle1 = math.max(
				angle1,
				-DemoApplication.MAX_CAMERA_VERTICAL_ROTATION_OFFSET)
			angle1 = math.min(
				angle1,
				DemoApplication.MAX_CAMERA_VERTICAL_ROTATION_OFFSET)
			angle2 = math.max(
				angle2,
				-DemoApplication.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET)
			angle2 = math.min(
				angle2,
				DemoApplication.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET)
		end

		self:getCamera():setVerticalRotation(
			DemoApplication.CAMERA_VERTICAL_ROTATION + angle1)
		self:getCamera():setHorizontalRotation(
			DemoApplication.CAMERA_HORIZONTAL_ROTATION + angle2)

		self.cameraVerticalRotationOffset = angle1
		self.cameraHorizontalRotationOffset = angle2
	end
end

function DemoApplication:draw(delta)
	local previous = self.previousPlayerPosition
	local current = self.currentPlayerPosition
	self:getCamera():setPosition(self:getPlayerPosition(self:getFrameDelta()))

	Application.draw(self, delta)
end

return DemoApplication
