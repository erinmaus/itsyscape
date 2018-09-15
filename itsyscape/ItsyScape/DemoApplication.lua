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

	self.previousPlayerPosition = false
	self.currentPlayerPosition = false
end

function DemoApplication:initialize()
	Application.initialize(self)

	--self:populateMap()
	self:getGame():getStage():loadStage("IsabelleIsland_AbandonedMine")
	self:populateMap()

	self:getGame():getUI():open("Ribbon")
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
	--self:moveActorToTile(player, 40, 4)
	--self:moveActorToTile(player, 16, 21)
	self:moveActorToTile(player, 32, 37)
	--self:moveActorToTile(player, 30, 15)
end

function DemoApplication:tick()
	Application.tick(self)

	local position = self:getGame():getPlayer():getActor():getPosition()
	self.previousPlayerPosition = self.currentPlayerPosition or position
	self.currentPlayerPosition = position

	self.light:setDirection(-self:getCamera():getForward())
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
		local angle1 = dx / 128
		local angle2 = -dy / 128
		self:getCamera():setVerticalRotation(
			self:getCamera():getVerticalRotation() + angle1)
		self:getCamera():setHorizontalRotation(
			self:getCamera():getHorizontalRotation() + angle2)
	end
end

function DemoApplication:draw(delta)
	local previous = self.previousPlayerPosition
	local current = self.currentPlayerPosition
	self:getCamera():setPosition(previous:lerp(current, self:getFrameDelta()))

	Application.draw(self, delta)
end

return DemoApplication
