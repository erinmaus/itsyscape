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
local ActorView = require "ItsyScape.Graphics.ActorView"
local MapMeshSceneNode = require "ItsyScape.Graphics.MapMeshSceneNode"
local ModelResource = require "ItsyScape.Graphics.ModelResource"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local Renderer = require "ItsyScape.Graphics.Renderer"
local ResourceManager = require "ItsyScape.Graphics.ResourceManager"
local SpriteManager = require "ItsyScape.Graphics.SpriteManager"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
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

	self._onMapModified = function(_, map, layer)
		self:updateMap(map, layer)
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

	self._onDropItem = function(_, item, tile, position)
		self:spawnItem(item, tile, position)
	end
	stage.onDropItem:register(self._onDropItem)

	self._onTakeItem = function(_, item)
		self:poofItem(item)
	end
	stage.onTakeItem:register(self._onTakeItem)

	self.scene = SceneNode()
	self.mapMeshes = {}

	self.renderer = Renderer()
	self.resourceManager = ResourceManager()
	self.spriteManager = SpriteManager(self.resourceManager)

	self.itemBagModel = self.resourceManager:load(
		ModelResource,
		"Resources/Game/Items/ItemBag.lmesh")
	self.itemBagIconModel = self.resourceManager:load(
		ModelResource,
		"Resources/Game/Items/ItemBagIcon.lmesh")
	self.items = {}

	local imageData = love.image.newImageData(1, 1)
	imageData:setPixel(0, 0, 1, 1, 1, 1)
	self.whiteTexture = TextureResource(love.graphics.newImage(imageData))
end

function GameView:getRenderer()
	return self.renderer
end

function GameView:getResourceManager()
	return self.resourceManager
end

function GameView:getSpriteManager()
	return self.spriteManager
end

function GameView:getScene()
	return self.scene
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
	stage.onTakeItem:unregister(self._onTakeItem)
	stage.onDropItem:unregister(self._onDropItem)
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
	view:attach(self)

	self.actors[actor] = view
end

function GameView:removeActor(actor)
	if self.actors[actor] then
		self.actors[actor]:poof()
		self.actors[actor] = nil
	end
end

function GameView:spawnItem(item, tile, position)
	local map = self.game:getStage():getMap(tile.layer)
	if map then
		position.y = map:getInterpolatedHeight(position.x, position.z)
	end

	local itemNode = SceneNode()
	do
		local lootBagNode = ModelSceneNode()
		lootBagNode:setModel(self.itemBagModel)
		lootBagNode:getMaterial():setShader(ModelSceneNode.STATIC_SHADER)
		lootBagNode:getMaterial():setTextures(self.whiteTexture)
		lootBagNode:setParent(itemNode)
	end
	do
		local lootIconNode = ModelSceneNode(self.itemBagIconModel)
		lootIconNode:setModel(self.itemBagIconModel)

		local texture = self.resourceManager:load(
			require "ItsyScape.Graphics.TextureResource",
			string.format("Resources/Game/Items/%s/Icon.png", item.id))
		lootIconNode:getMaterial():setShader(ModelSceneNode.STATIC_SHADER)
		lootIconNode:setParent(itemNode)
		lootIconNode:getMaterial():setTextures(texture)

		lootIconNode:setParent(itemNode)
	end

	itemNode:getTransform():translate(position)
	itemNode:setParent(self.scene)

	self.items[item.ref] = itemNode
end

function GameView:poofItem(item)
	local node = self.items[item.ref]
	if node then
		node:setParent(nil)

		self.items[item.ref] = nil
	end
end

function GameView:update(delta)
	for _, actor in pairs(self.actors) do
		actor:update(delta)
	end

	self.spriteManager:update(delta)
end

function GameView:tick()
	self.scene:tick()
end

return GameView
