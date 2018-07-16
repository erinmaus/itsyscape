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
	self:createMap()

	Application.initialize(self)

	self:populateMap()

	self:getGame():getUI():open("Ribbon")
	--self:getGame():getUI():open("CraftWindow", "Metal", nil, "Smelt")

	local position = self:getGame():getPlayer():getActor():getPosition()
	self.previousPlayerPosition = position
	self.currentPlayerPosition = position
end

function DemoApplication:createMap()
	self:getGame():getStage():newMap(8, 8, 1)
	local map = self:getGame():getStage():getMap(1)
	for j = 1, map:getHeight() do
		for i = 1, map:getWidth() do
			local tile = map:getTile(i, j)
			tile.flat = 1
			tile.edge = 2
			tile.topLeft = 1
			tile.topRight = 1
			tile.bottomLeft = 1
			tile.bottomRight = 1
		end
	end

	table.insert(map:getTile(1, 1).decals, 9)
	for i = 2, map:getWidth() do
		local tile = map:getTile(i, 1)
		table.insert(tile.decals, 5)
	end

	for j = 2, map:getHeight() do
		local tile = map:getTile(1, j)
		table.insert(tile.decals, 7)
	end

	for i = 2, map:getWidth() do
		local tile = map:getTile(i, 1)
		tile.topLeft = math.min(i - 1, math.ceil(map:getWidth() / 2))
		tile.topRight = math.min(i, math.ceil(map:getWidth() / 2))
		tile.bottomLeft = math.min(i - 1, math.ceil(map:getWidth() / 2))
		tile.bottomRight = math.min(i, math.ceil(map:getWidth() / 2))
	end

	for j = 2, map:getHeight() / 2 do
		for i = 1, map:getWidth() / 2 do
			if i % 2 ~= j % 2 then
				local tile = map:getTile(i * 2, j * 2)
				tile.topLeft = 2
				tile.topRight = 2
				tile.bottomLeft = 2
				tile.bottomRight = 2
			end
		end
	end

	for j = 2, map:getHeight() do
		local tile = map:getTile(3, j)
		tile.topLeft = 1
		tile.topRight = 1
		tile.bottomLeft = 1
		tile.bottomRight = 1
	end

	self.game:getStage():updateMap(1)
end

function DemoApplication:moveActorToTile(actor, i, j, k)
	local map = self:getGame():getStage():getMap(k or 1)
	actor:teleport(map:getTileCenter(i, j))
end

function DemoApplication:populateMap()
	do
		local s, a = self:getGame():getStage():spawnActor("resource://Goblin_Base")
		if s then
			local map = self:getGame():getStage():getMap(1)
			local i, j = math.random(1, map:getWidth()), math.random(1, map:getHeight())
			self:moveActorToTile(a, i, j)
		end
	end

	do
		local s, a = self:getGame():getStage():placeProp("resource://Furnace_Default")
		if s then
			local map = self:getGame():getStage():getMap(1)
			local position = a:getPeep():getBehavior(
				require "ItsyScape.Peep.Behaviors.PositionBehavior")
			position.position = map:getTileCenter(5, 2)
		end
	end

	local player = self:getGame():getPlayer():getActor()
	self:moveActorToTile(player, 4, 4)
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
