--------------------------------------------------------------------------------
-- ItsyScape/Graphics/GameView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local MapMeshSceneNode = require "ItsyScape.Graphics.MapMeshSceneNode"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local Renderer = require "ItsyScape.Graphics.Renderer"
local TileSet = require "ItsyScape.World.TileSet"

local GameView = Class()

function GameView:new(game)
	self.game = game
	self.actors = {}

	local stage = game:getStage()
	self._onLoadMap = function(_, map, layer, tileSetID)
		self:addMap(map, layer, tileSetID)
	end
	stage.onLoadMap:register(self._onLoadMap)

	self.onUnloadMap = function(_, map, layer)
		self:removeMap(map, layer)
	end
	stage.onUnloadMap:register(self._onLoadMap)

	self._onMapModified = function(_, map)
		self:updateMap(map)
	end
	stage.onMapModified:register(self._onMapModified)

	self._onActorSpawned = function(_, actorID, actor)
		self:addActor(actorID, actor)
	end
	stage.onActorSpawned:register(self._onActorSpawned)

	self._onActorKilled = function(_, actor)
		self:removeActor(actor)
	end
	stage.onActorKilled:register(self._onActorKilled)

	self.scene = SceneNode()
	self.mapMeshes = {}

	self.renderer = Renderer()
end

function GameView:release()
	for _, actor in pairs(self.actors) do
		actor:release()
	end

	local stage = game:getStage()
	stage.onLoadMap:unregister(self._onLoadMap)
	stage.onUnloadMap:unregister(self._onUnloadMap)
	stage.onMapModified:unregister(self._onMapModified)
	stage.onActorSpawned:unregister(self.onActorSpawned)
	stage.onActorKilled:unregister(self._onActorKilled)
end

function GameView:addMap(map, layer, tileSetID)
	local tileSet = TileSet()
	tileSet:setTileProperty(1, 'colorRed', 128)
	tileSet:setTileProperty(1, 'colorGreen', 192)
	tileSet:setTileProperty(1, 'colorBlue', 64)
	tileSet:setTileProperty(2, 'colorRed', 255)
	tileSet:setTileProperty(2, 'colorGreen', 192)
	tileSet:setTileProperty(2, 'colorBlue', 64)

	if self.mapMeshes[layer] then
		self.mapMeshes[layer].node:setParent(nil)
		self.mapMeshes[layer].node:setMapMesh(nil)
	end

	local m = {
		tileSet = tileSet,
		map = map,
		node = MapMeshSceneNode()
	}
	m.node:setParent(self.scene)

	self.mapMeshes[layer] = m
end

function GameView:removeMap(map, layer)
	local m = self.mapMeshes[layer]
	if m then
		m.node:setParent(nil)
		m.node:setMapMesh(nil)
		self.mapMeshes[layer] = nil
	end
end

function GameView:updateMap(map, layer)
	local m = self.mapMeshes[layer]
	if m then
		m.node:fromMap(m.map, m.tileSet)
	end
end

function GameView:addActor(actorID, actor)
	local view = ActorView(actor, actorID)
	view:attach(self.scene)

	self.actors[actor] = view
end

function GameView:removeActor(actor)
	if self.actors[actor] then
		self.actors[actor]:poof()
		self.actors[actor] = nil
	end
end

function GameView:tick()
	self.scene:tick()
end

return GameView
