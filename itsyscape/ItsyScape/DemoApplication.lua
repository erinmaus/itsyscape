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
local Vector = require "ItsyScape.Common.Math.Vector"
local Class = require "ItsyScape.Common.Class"
local DirectionalLightSceneNode = require "ItsyScape.Graphics.DirectionalLightSceneNode"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local DemoApplication = Class(Application)
DemoApplication.CAMERA_HORIZONTAL_ROTATION = -math.pi / 6
DemoApplication.CAMERA_VERTICAL_ROTATION = -math.pi / 2
DemoApplication.MAX_CAMERA_VERTICAL_ROTATION_OFFSET = math.pi / 4
DemoApplication.MAX_CAMERA_HORIZONTAL_ROTATION_OFFSET = math.pi / 6 - math.pi / 12

function DemoApplication:new()
	Application.new(self)

	self.isCameraDragging = false
	self.light = DirectionalLightSceneNode()
	do
		self.light:setIsGlobal(true)
		self.light:setDirection(-self:getCamera():getForward())
		self.light:setParent(self:getGameView():getScene())
		
		local ambient = AmbientLightSceneNode()
		ambient:setAmbience(0.4)
		ambient:setParent(self:getGameView():getScene())
	end

	self.cameraVerticalRotationOffset = 0
	self.cameraHorizontalRotationOffset = 0

	self.previousPlayerPosition = false
	self.currentPlayerPosition = false

	self:getCamera():setHorizontalRotation(DemoApplication.CAMERA_HORIZONTAL_ROTATION)
	self:getCamera():setVerticalRotation(DemoApplication.CAMERA_VERTICAL_ROTATION)

	self.playerDead = false
end

function DemoApplication:initialize()
	Application.initialize(self)

	local playerPeep = self:getGame():getPlayer():getActor():getPeep()
	--self:populateMap()
	--self:getGame():getStage():loadStage("IsabelleIsland_AbandonedMine")
	--self:getGame():getStage():loadStage("IsabelleIsland_Tower")
	self:getGame():getStage():movePeep(
		playerPeep,
		"IsabelleIsland_Tower",
		"Anchor_StartGame")
	self:populateMap()


	self:getGame():getUI():open(playerPeep, "Ribbon")
	--self:getGame():getUI():open("CraftWindow", "Metal", nil, "Smelt")

	local position = self:getGame():getPlayer():getActor():getPosition()
	self.previousPlayerPosition = position
	self.currentPlayerPosition = position
end

function DemoApplication:moveActorToTile(actor, i, j, k)
	local map = self:getGame():getStage():getMap(k or 1)
	actor:teleport(map:getTileCenter(i, j))
end

function DemoApplication:populateMap()
	local player = self:getGame():getPlayer():getActor()

	local peep = player:getPeep()
	peep:listen('die', function()
		self.playerDead = true
	end)
	-- Entrance
	--self:moveActorToTile(player, 40, 4)
	-- Mine
	--self:moveActorToTile(player, 16, 21)
	-- Furnace
	--self:moveActorToTile(player, 30, 15)
	-- Boss
	--self:moveActorToTile(player, 32, 37)
end

function DemoApplication:tick()
	Application.tick(self)

	local position = self:getGame():getPlayer():getActor():getPosition()
	self.previousPlayerPosition = self.currentPlayerPosition or position
	self.currentPlayerPosition = position

	self.light:setDirection(-self:getCamera():getForward())

	if self.playerDead then
		local player = self:getGame():getPlayer():getActor()
		local peep = player:getPeep()
		local combat = peep:getBehavior(require "ItsyScape.Peep.Behaviors.CombatStatusBehavior")
		combat.currentHitPoints = combat.maximumHitpoints

		player:playAnimation('combat', false)

		self:moveActorToTile(player, 40, 4)
		self.playerDead = false
	end
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
	self:getCamera():setDistance(math.min(math.max(distance, 1), 40))
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
	self:getCamera():setPosition(previous:lerp(current, self:getFrameDelta()))

	Application.draw(self, delta)
end

return DemoApplication
