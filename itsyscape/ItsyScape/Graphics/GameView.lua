--------------------------------------------------------------------------------
-- ItsyScape/Graphics/GameView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local ripple = require "ripple"
local buffer = require "string.buffer"
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local ActorView = require "ItsyScape.Graphics.ActorView"
local Color = require "ItsyScape.Graphics.Color"
local DebugStats = require "ItsyScape.Graphics.DebugStats"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local LayerTextureResource = require "ItsyScape.Graphics.LayerTextureResource"
local MapMeshSceneNode = require "ItsyScape.Graphics.MapMeshSceneNode"
local ModelResource = require "ItsyScape.Graphics.ModelResource"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local Renderer = require "ItsyScape.Graphics.Renderer"
local ResourceManager = require "ItsyScape.Graphics.ResourceManager"
local SpriteManager = require "ItsyScape.Graphics.SpriteManager"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local WaterMeshSceneNode = require "ItsyScape.Graphics.WaterMeshSceneNode"
local Map = require "ItsyScape.World.Map"
local MapMeshIslandProcessor = require "ItsyScape.World.MapMeshIslandProcessor"
local TileSet = require "ItsyScape.World.TileSet"
local MapMeshMask = require "ItsyScape.World.MapMeshMask"
local MultiTileSet = require "ItsyScape.World.MultiTileSet"
local WeatherMap = require "ItsyScape.World.WeatherMap"

local GameView = Class()
GameView.MAP_MESH_DIVISIONS = 16
GameView.FADE_DURATION = 2

GameView.PropViewDebugStats = Class(DebugStats)
function GameView.PropViewDebugStats:process(node, delta)
	node:update(delta)
end

function GameView:new(game)
	self.game = game
	self.actors = {}
	self.props = {}
	self.views = {}
	self.propViewDebugStats = GameView.PropViewDebugStats()
	self.generalDebugStats = DebugStats.GlobalDebugStats()

	self.scene = SceneNode()
	self.mapMeshes = {}
	self.tests = { id = 1 }

	self.water = {}

	self.decorations = {}

	self.renderer = Renderer(_MOBILE)
	self.resourceManager = ResourceManager()
	self.spriteManager = SpriteManager(self.resourceManager)

	self.itemBagModel = self.resourceManager:load(
		ModelResource,
		"Resources/Game/Items/ItemBag.lmesh")
	self.itemBagIconModel = self.resourceManager:load(
		ModelResource,
		"Resources/Game/Items/ItemBagIcon.lmesh")
	self.items = {}

	local translucentTextureImageData = love.image.newImageData(1, 1)
	translucentTextureImageData:setPixel(0, 0, 1, 1, 1, 0)
	self.translucentTexture = TextureResource(love.graphics.newImage(translucentTextureImageData))
	self.translucentTextureImageData = translucentTextureImageData

	local whiteTextureImageData = love.image.newImageData(1, 1)
	whiteTextureImageData:setPixel(0, 0, 1, 1, 1, 1)
	self.whiteTexture = TextureResource(love.graphics.newImage(whiteTextureImageData))
	self.whiteTextureImageData = whiteTextureImageData

	self.defaultMapMaskTexture = LayerTextureResource(love.graphics.newArrayImage(whiteTextureImageData))

	local itemTextureImageData = love.image.newImageData(1, 1)
	itemTextureImageData:setPixel(0, 0, 1, 1, 1, 1)
	self.itemTexture = TextureResource(love.graphics.newImage(itemTextureImageData))
	self.itemTextureImageData = itemTextureImageData

	self.projectiles = {}

	self.weather = {}

	self.mapThread = love.thread.newThread("ItsyScape/Game/LocalModel/Threads/Map.lua")
	self.mapThread:start()

	self.soundTags = {
		main = ripple.newTag(),
		ambience = ripple.newTag(),
		soundEffects = ripple.newTag()
	}

	self.music = {}
	self.pendingMusic = {}
end

function GameView:getGame()
	return self.game
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

function GameView:attach(game)
	self.game = game or self.game
	local stage = self.game:getStage()

	self._onLoadMap = function(_, map, layer, tileSetID, mask, meta)
		Log.info("Adding map to layer %d (has mask = %s).", layer, Log.boolean(mask))
		self:addMap(map, layer, tileSetID, mask, meta)
	end
	stage.onLoadMap.debug = true
	stage.onLoadMap:register(self._onLoadMap)

	self._onUnloadMap = function(_, layer)
		Log.info("Unloading map from layer %d.", layer)
		self:removeMap(layer)
	end
	stage.onUnloadMap:register(self._onUnloadMap)

	self._onMapModified = function(_, map, layer)
		Log.info("Map for layer %d modified.", layer)
		self:updateMap(map, layer)
	end
	stage.onMapModified:register(self._onMapModified)

	self._onMapMoved = function(_, layer, position, rotation, scale, offset, disabled)
		self:moveMap(layer, position, rotation, scale, offset, disabled)
	end
	stage.onMapMoved:register(self._onMapMoved)

	self._onActorSpawned = function(_, actorID, actor)
		Log.info("Spawning actor '%s' (%s).", actorID, actor and actor:getPeepID())
		self:addActor(actorID, actor)
	end
	stage.onActorSpawned:register(self._onActorSpawned)

	self._onActorKilled = function(_, actor)
		Log.info("Poofing actor '%s' (%s).", actor and actor:getName(), actor and actor:getPeepID())
		self:removeActor(actor)
	end
	stage.onActorKilled:register(self._onActorKilled)

	self._onPropPlaced = function(_, propID, prop)
		Log.info("Placing prop '%s' (%s).", propID, prop and prop:getPeepID())
		self:addProp(propID, prop)
	end
	stage.onPropPlaced:register(self._onPropPlaced)

	self._onPropRemoved = function(_, prop)
		Log.info("Removing prop '%s' (%s).", prop and prop:getName(), prop and prop:getPeepID())
		self:removeProp(prop)
	end
	stage.onPropRemoved:register(self._onPropRemoved)

	self._onDropItem = function(_, ref, item, tile, position)
		Log.info(
			"Dropped item '%s' (ref = %d, count = %d) at (%d, %d) on layer %d.",
			item.id, ref, item.count, tile.i, tile.j, tile.layer)
		self:spawnItem(item, tile, position)
	end
	stage.onDropItem:register(self._onDropItem)

	self._onTakeItem = function(_, ref, item)
		Log.info(
			"Item '%s' (ref = %d, count = %d) taken.",
			item.id, ref, item.count)
		self:poofItem(item)
	end
	stage.onTakeItem:register(self._onTakeItem)

	self._onDecorate = function(_, group, decoration, layer)
		Log.info("Decorating '%s' on layer %d.", group, layer)
		self:decorate(group, decoration, layer)
	end
	stage.onDecorate:register(self._onDecorate)

	self._onUndecorate = function(_, group, layer)
		Log.info("Removing decoration '%s' on layer %d.", group, layer)
		self:decorate(group, nil, layer)
	end
	stage.onUndecorate:register(self._onUndecorate)

	self._onWaterFlood = function(_, key, water, layer)
		Log.info("Water (%s) flooding on layer %d.", key, layer)
		self:flood(key, water, layer)
	end
	stage.onWaterFlood:register(self._onWaterFlood)

	self._onWaterDrain = function(_, key, layer)
		Log.info("Water (%s) draining on layer %d.", key, layer)
		self:drain(key, water)
	end
	stage.onWaterDrain:register(self._onWaterDrain)

	self._onForecast = function(_, layer, key, id, props)
		Log.info("Forecast is '%s' for key '%s' on layer %d.", id, key, layer)
		self:forecast(layer, key, nil)
		self:forecast(layer, key, id, props)
	end
	stage.onForecast:register(self._onForecast)

	self._onStopForecast = function(_, layer, key)
		Log.info("Forecast '%s' on layer %d is over.", key, layer)
		self:forecast(layer, key, nil)
	end
	stage.onStopForecast:register(self._onStopForecast)

	self._onProjectile = function(_, projectileID, source, destination, layer)
		Log.info("Firing projectile '%s'.", projectileID)
		self:fireProjectile(projectileID, source, destination, layer)
	end
	stage.onProjectile:register(self._onProjectile)

	self._onPlayMusic = function(_, track, song)
		if type(song) == 'table' then
			Log.info("Playing songs '%s' on track '%s'.", table.concat(song, ", "), track)
		else
			Log.info("Playing song '%s' on track '%s'.", song, track)
		end

		self:playMusic(track, song)
	end
	stage.onPlayMusic:register(self._onPlayMusic)

	self._onStopMusic = function(_, track, song)
		Log.info("Stopping track '%s'.", track)
		self:playMusic(track, false)
	end
	stage.onStopMusic:register(self._onStopMusic)
end

function GameView:reset()
	Log.info("Resetting game view...")

	for _, actor in pairs(self.actors) do
		Log.info("Poofing actor '%s' (%s).", actor:getActor():getName(), actor:getActor():getPeepID())
		actor:release()
	end
	table.clear(self.actors)

	for _, prop in pairs(self.props) do
		Log.info("Removing prop '%s' (%s).", prop:getProp():getName(), prop:getProp():getPeepID())
		prop:remove()
	end
	table.clear(self.props)

	for layer in pairs(self.mapMeshes) do
		Log.info("Clearing map from layer %d.", layer)
		self:removeMap(layer)
	end

	for _, itemNode in pairs(self.items) do
		Log.info("Removing item.")
		itemNode:setParent(nil)
	end
	table.clear(self.items)

	for _, decoration in pairs(self.decorations) do
		Log.info("Removing decoration '%s'.", decoration.name)

		if decoration.sceneNode then
			decoration.sceneNode:setParent(nil)
		end
	end
	table.clear(self.decorations)

	for key, water in pairs(self.water) do
		Log.info("Water '%s' draining.", key)
		water:setParent(nil)
	end
	table.clear(self.water)

	for key, weather in pairs(self.weather) do
		Log.info("Removing weather '%s'.", key)
		weather:remove()
	end
	table.clear(self.weather)

	for projectile in ipairs(self.projectiles) do
		Log.info("Poofing projectile '%s'.", projectile:getDebugInfo().shortName)
		projectile:poof()
	end
	table.clear(self.projectiles)

	for track in ipairs(self.music) do
		Log.info("Stopping music on track '%s'.", track)
		self:playMusic(track, false)
	end

	self.spriteManager:clear()

	Log.info("Reset game view.")
end

function GameView:release()
	self:reset()

	local stage = self.game:getStage()
	stage.onLoadMap:unregister(self._onLoadMap)
	stage.onUnloadMap:unregister(self._onUnloadMap)
	stage.onMapModified:unregister(self._onMapModified)
	stage.onMapMoved:unregister(self._onMapMoved)
	stage.onActorSpawned:unregister(self.onActorSpawned)
	stage.onActorKilled:unregister(self._onActorKilled)
	stage.onPropPlaced:unregister(self._onPropPlaced)
	stage.onPropRemoved:unregister(self._onPropRemoved)
	stage.onTakeItem:unregister(self._onTakeItem)
	stage.onDropItem:unregister(self._onDropItem)
	stage.onDecorate:unregister(self._onDecorate)
	stage.onUndecorate:unregister(self._onUndecorate)
	stage.onWaterFlood:unregister(self._onWaterFlood)
	stage.onWaterDrain:unregister(self._onWaterDrain)
	stage.onForecast:unregister(self._onForecast)
	stage.onStopForecast:unregister(self._onStopForecast)
	stage.onProjectile:unregister(self._onProjectile)
	stage.onPlayMusic:unregister(self._onPlayMusic)
	stage.onStopMusic:unregister(self._onStopMusic)
end

function GameView:addMap(map, layer, tileSetID, mask, meta)
	meta = meta or {}

	local filename = false
	if type(map) == 'string' then
		filename = map
		map = Map.loadFromFile(map)
	end

	local tileSet, texture
	if type(tileSetID) == 'table' then
		tileSet = MultiTileSet(tileSetID)
		texture = tileSet:getMultiTexture()
	else
		local tileSetFilename = string.format(
			"Resources/Game/TileSets/%s/Layout.lua",
			tileSetID or "GrassyPlain")
		tileSet, texture = TileSet.loadFromFile(tileSetFilename, true)
	end

	local mapMeshMasks = {}
	if mask then
		if type(mask) ~= 'table' then
			mask = { default = mask }
		end

		for key, maskID in pairs(mask) do
			local mapMeshMaskTypeName
			if maskID == true then
				mapMeshMaskTypeName = "ItsyScape.World.MapMeshMask"
			else
				mapMeshMaskTypeName = string.format("ItsyScape.World.%sMapMeshMask", maskID)
			end

			if mapMeshMaskTypeName then
				local mapMeshMask
				local s, r = xpcall(require, debug.traceback, mapMeshMaskTypeName)
				if not s then
					Log.warn("Error loading map mesh mask '%s': %s", mapMeshMaskTypeName, r)
					r = nil
				else
					mapMeshMask = r()
				end
				
				if mapMeshMask then
					table.insert(mapMeshMasks, mapMeshMask)
					mapMeshMasks[key] = #mapMeshMasks
				end
			end
		end
	end
	mapMeshMasks = #mapMeshMasks >= 1 and mapMeshMasks

	if self.mapMeshes[layer] then
		self:removeMap(layer)
	end

	local m = {
		tileSet = tileSet,
		texture = texture,
		tileSetID = tileSetID or "GrassyPlain",
		filename = filename,
		map = map,
		node = SceneNode(),
		parts = {},
		layer = layer,
		weatherMap = WeatherMap(layer, -8, -8, map:getCellSize(), map:getWidth() + 16, map:getHeight() + 16),
		maskID = maskID,
		mapMeshMasks = mapMeshMasks,
		mask = mapMeshMasks and MapMeshMask.combine(unpack(mapMeshMasks)),
		islandProcessor = mapMeshMasks and meta.autoMask and MapMeshIslandProcessor(map, tileSet),
		meta = meta
	}

	m.weatherMap:addMap(m.map)

	self.mapMeshes[layer] = m
end

function GameView:removeMap(layer)
	local m = self.mapMeshes[layer]
	if m then
		m.node:setParent(nil)

		for i = 1, #m.parts do
			m.parts[i]:setMapMesh(nil)
		end

		m.weatherMap:removeMap(m.map)

		self.mapMeshes[layer] = nil

		love.thread.getChannel('ItsyScape.Map::input'):push({
			type = 'unload',
			key = layer
		})

		for key, value in pairs(self.decorations) do
			if value.layer == layer then
				self.decorations[key] = nil
			end
		end
	end
end

function GameView:updateGroundDecorations(m)
	local isMapEditor = _APP:getType() == require "ItsyScape.Editor.MapEditorApplication"
	if isMapEditor then
		Log.info("Map editor: not updating ground decorations.")
		return
	end

	local tileSetIDs
	if type(m.tileSetID) == 'string' then
		if m.filename then
			for i = 1, m.map:getWidth() do
				for j = 1, m.map:getHeight() do
					m.map:getTile(i, j).tileSetID = m.tileSetID
				end
			end
		end

		tileSetIDs = { m.tileSetID }
	else
		tileSetIDs = m.tileSetID
	end

	for i = 1, #tileSetIDs do
		local tileSetID = tileSetIDs[i] or "GrassyPlain"

		local groundDecorationsFilename = string.format(
			"Resources/Game/TileSets/%s/Ground.lua",
			tileSetID)
		local groundExists = love.filesystem.getInfo(groundDecorationsFilename)

		if groundExists then
			local chunk = love.filesystem.load(groundDecorationsFilename)

			local GroundType = chunk()
			if GroundType then
				local ground = GroundType()
				ground:emitAll(m.tileSet, m.map)

				local decoration = ground:getDecoration()
				local groupName = string.format("_x_GroundDecorations_%s", tileSetID)
				self:decorate(groupName, decoration, m.layer)
			end
		end
	end
end

function GameView:testMap(layer, ray, callback)
	local id = self.tests.id
	self.tests.id = id + 1

	self.tests[id] = {
		layer = layer,
		callback = callback
	}

	love.thread.getChannel('ItsyScape.Map::input'):push({
		type = 'probe',
		id = id,
		key = layer,
		origin = { ray.origin.x, ray.origin.y, ray.origin.z },
		direction = { ray.direction.x, ray.direction.y, ray.direction.z }
	})
end

function GameView:updateMap(map, layer)
	local m = self.mapMeshes[layer]
	if m then
		if m.map then
			m.weatherMap:removeMap(m.map)
		end

		if map then
			if type(map) == 'string' then
				if m.filename ~= map then
					m.filename = map
					map = Map.loadFromFile(map)
				else
					map = m.map
				end
			else
				m.filename = nil
			end

			if m.map ~= map then
				m.map = map
				if m.islandProcessor then
					m.islandProcessor = MapMeshIslandProcessor(m.map, m.tileSet)
				end
			end
		end

		do
			local before = love.timer.getTime()
			love.thread.getChannel('ItsyScape.Map::input'):push({
				type = 'load',
				key = layer,
				data = buffer.encode(m.map:serialize())
			})
			local after = love.timer.getTime()

			Log.debug("Updated layer '%d' in %d ms.", layer, (after - before) * 1000)
		end

		for i = 1, #m.parts do
			m.parts[i]:setParent(nil)
			m.parts[i]:setMapMesh(nil)
		end
		m.parts = {}

		local w, h
		do
			local E = 1 / GameView.MAP_MESH_DIVISIONS
			local partialX = m.map:getWidth() / GameView.MAP_MESH_DIVISIONS
			local partialY = m.map:getHeight() / GameView.MAP_MESH_DIVISIONS

			w = math.floor(partialX)
			h = math.floor(partialY)

			if partialX - math.floor(partialX) >= E then
				w = w + 1
			end

			if partialY - math.floor(partialY) >= E then
				h = h + 1
			end
		end

		for j = 1, h do
			for i = 1, w do
				local x = (i - 1) * GameView.MAP_MESH_DIVISIONS + 1
				local y = (j - 1) * GameView.MAP_MESH_DIVISIONS + 1

				local node = MapMeshSceneNode()
				node:setParent(m.node)
				table.insert(m.parts, node)
				self.resourceManager:queueEvent(function()
					node:fromMap(
						m.map,
						m.tileSet,
						x, y,
						GameView.MAP_MESH_DIVISIONS,
						GameView.MAP_MESH_DIVISIONS,
						m.mapMeshMasks,
						m.islandProcessor)

					if m.mapMeshMasks then
						node:getMaterial():setTextures(m.texture, m.mask:getTexture())
					else
						node:getMaterial():setTextures(m.texture, self.defaultMapMaskTexture)
					end
				end)
			end
		end

		m.weatherMap:addMap(m.map)

		self:updateGroundDecorations(m)
	end
end

function GameView:moveMap(layer, position, rotation, scale, offset, disabled)
	local node = self:getMapSceneNode(layer)
	if node then
		local transform = node:getTransform()
		transform:setLocalTranslation(position)
		transform:setLocalRotation(rotation)
		transform:setLocalScale(scale)
		transform:setLocalOffset(offset)

		if disabled and node:getParent() then
			node:setParent(nil)
		elseif not disabled and not node:getParent() then
			node:setParent(self.scene)
			node:tick(1)
		end
	end

	local m = self.mapMeshes[layer]
	if m then
		m.weatherMap:updateMap(m.map, position, rotation, scale)

		local x = ((m.map:getWidth() + 0.5) * m.map:getCellSize()) / 2
		local z = ((m.map:getHeight() + 0.5) * m.map:getCellSize()) / 2
		local globalTransform = m.node:getTransform():getGlobalTransform()
		local position = Vector(globalTransform:transformPoint(x, 0, z))
		m.weatherMap:setAbsolutePosition(position)
	end
end

function GameView:getMapSceneNode(layer)
	local m = self.mapMeshes[layer]
	if m then
		return m.node
	end
end

function GameView:getMapTileSet(layer)
	local m = self.mapMeshes[layer]
	if m then
		return m.tileSet, m.tileSetID
	end
end

function GameView:getMap(layer)
	local m = self.mapMeshes[layer]
	if m then
		return m.map
	end
end

function GameView:addActor(actorID, actor)
	if not actor then
		Log.warn("Actor of type '%s' is nil; cannot add.", actorID)
		return
	end

	if self:hasActor(actor) then
		Log.warn("Actor of type '%s' (%d) already exists; cannot add.", actorID, actor:getID())
		return
	end

	local view = ActorView(actor, actorID)
	view:attach(self)

	self.actors[actor] = view
	self.views[actor] = view
end

function GameView:getActor(actor)
	return self.actors[actor]
end

function GameView:getActorByID(id)
	for actor in pairs(self.actors) do
		if actor:getID() == id then
			return actor
		end
	end

	return nil
end

function GameView:removeActor(actor)
	if self.actors[actor] then
		local view = self.actors[actor]
		self.actors[actor]:release()
		self.actors[actor] = nil
		self.views[actor] = nil
	end
end

function GameView:hasActor(actor)
	return self.actors[actor] ~= nil
end

function GameView:addProp(propID, prop)
	if not prop or self:getProp(prop) then
		return
	end

	local PropViewTypeName = string.format("Resources.Game.Props.%s.View", propID, propID)
	local s, r = xpcall(function() return require(PropViewTypeName) end, debug.traceback)
	if not s then
		Log.warnOnce("Failed to load prop view '%s': %s", PropViewTypeName, r)
		r = require "Resources.Game.Props.Null.View"
	end

	local PropView = r
	local view = PropView(prop, self)
	view:attach()
	view:load()

	self.props[prop] = view
	self.views[prop] = view
end

function GameView:getProp(prop)
	return self.props[prop]
end

function GameView:getPropByID(id)
	for prop in pairs(self.props) do
		if prop:getID() == id then
			return prop
		end
	end
end

function GameView:removeProp(prop)
	if self.props[prop] then
		local view = self.props[prop]
		self.props[prop]:remove()
		self.props[prop] = nil
		self.views[prop] = nil
	end
end

function GameView:getView(instance)
	return self.views[instance]
end

function GameView:getWhiteTexture()
	return self.whiteTexture, self.whiteTextureImageData
end

function GameView:getTranslucentTexture()
	return self.translucentTexture, self.translucentTextureImageData
end

function GameView:spawnItem(item, tile)
	local map = self:getMap(tile.layer)
	if map then
		position = map:getTileCenter(tile.i, tile.j)
	end

	local itemNode = SceneNode()
	do
		local lootBagNode = ModelSceneNode()
		lootBagNode:setModel(self.itemBagModel)
		lootBagNode:getMaterial():setShader(ModelSceneNode.STATIC_SHADER)
		lootBagNode:getMaterial():setTextures(self.itemTexture)
		lootBagNode:setParent(itemNode)
	end
	do
		local lootIconNode = ModelSceneNode(self.itemBagIconModel)
		lootIconNode:setModel(self.itemBagIconModel)

		local texture = self.resourceManager:queue(
			TextureResource,
			string.format("Resources/Game/Items/%s/Icon.png", item.id),
			function(texture)
				lootIconNode:getMaterial():setTextures(texture)
			end)

		lootIconNode:getMaterial():setShader(ModelSceneNode.STATIC_SHADER)
		lootIconNode:setParent(itemNode)
		lootIconNode:setParent(itemNode)
	end

	local map = self:getMapSceneNode(tile.layer)
	if not map then
		map = self.scene
	end

	itemNode:getTransform():translate(position)
	itemNode:setParent(map)

	self.items[item.ref] = itemNode
end

function GameView:poofItem(item)
	local node = self.items[item.ref]
	if node then
		node:setParent(nil)

		self.items[item.ref] = nil
	end
end

function GameView:decorate(group, decoration, layer)
	local groupName = group .. '#' .. tostring(layer)
	if self.decorations[groupName] and
	   self.decorations[groupName].sceneNode
	then
		self.decorations[groupName].sceneNode:setParent(nil)
		self.decorations[groupName] = nil
	end

	local map = self:getMapSceneNode(layer)
	if not map then
		map = self.scene
	end

	if decoration then
		local d = {}

		self.resourceManager:queueEvent(function()
			if self.decorations[groupName] ~= d then
				Log.debug("Decoration group '%s' has been overwritten; ignoring.", groupName)
				return
			end

			local tileSetFilename = string.format(
				"Resources/Game/TileSets/%s/Layout.lstatic",
				decoration:getTileSetID())
			local staticMesh = self.resourceManager:load(
				StaticMeshResource,
				tileSetFilename)

			local textureFilename = string.format(
				"Resources/Game/TileSets/%s/Texture.png",
				decoration:getTileSetID())
			local texture = self.resourceManager:load(
				TextureResource,
				textureFilename)

			local sceneNode = DecorationSceneNode()
			sceneNode:fromDecoration(decoration, staticMesh:getResource())
			sceneNode:getMaterial():setTextures(texture)

			sceneNode:setParent(map)

			d.sceneNode = sceneNode
			d.staticMesh = staticMesh
			d.layer = layer
		end)

		d.decoration = decoration
		d.name = group
		d.layer = layer

		self.decorations[groupName] = d
	end
end

function GameView:flood(key, water, layer)
	self:drain(key)

	local parent = self:getMapSceneNode((water.layer or 1) - 1 + (layer or 1))
	if not parent then
		parent = self.scene
	end

	local node = WaterMeshSceneNode()
	local map = self:getMap(layer)
	node:generate(
		map,
		water.i or 1,
		water.j or 1,
		water.width or (map:getWidth() - ((water.i or 1) - 1) + 1),
		water.height or (map:getHeight() - ((water.j or 1) - 1) + 1),
		water.y,
		water.finesse)

	if water.timeScale then
		node:setTextureTimeScale(water.timeScale)
	end

	if water.yOffset then
		node:setYOffset(water.yOffset)
	end

	if water.isTranslucent or (water.alpha and water.alpha < 1) then
		node:getMaterial():setIsTranslucent(true)
	end

	if water.alpha then
		node:getMaterial():setColor(Color(1, 1, 1, water.alpha))
	end

	self.resourceManager:queue(
		TextureResource,
		string.format("Resources/Game/Water/%s/Texture.png", water.texture or "LightFoamyWater1"),
		function(resource)
			node:getMaterial():setTextures(resource)
			node:setParent(parent)
		end)


	self.water[key] = node
end

function GameView:drain(key)
	if self.water[key] then
		self.water[key]:setParent(nil)
		self.water[key]:degenerate()
		self.water[key] = nil
	end
end

function GameView:forecast(layer, key, id, props)
	if not id then
		local current = self.weather[key]
		if current then
			current:remove()
		end

		self.weather[key] = nil
		return
	end

	local WeatherType
	do
		local WeatherTypeName = string.format("ItsyScape.Graphics.%sWeather", id)
		local s, r = pcall(require, WeatherTypeName)
		if not s then
			Log.error("Failed to load weather '%s': %s.", id, r)
			return
		end

		WeatherType = r
	end

	if WeatherType then
		local node = self.mapMeshes[layer]
		if node then
			map = node.weatherMap

			local weather = WeatherType(self, layer, map, props or {})
			self.weather[key] = weather
		end
	end
end

function GameView:fireProjectile(projectileID, source, destination, layer)
	local ProjectileType
	do
		local ProjectileTypeName = string.format("Resources.Game.Projectiles.%s.Projectile", projectileID)
		local s, r = pcall(require, ProjectileTypeName)
		if not s then
			Log.error("Failed to load projectile '%s': %s.", projectileID, r)
			return
		end

		ProjectileType = r
	end

	if ProjectileType then
		local projectile = ProjectileType(projectileID, self, source, destination, layer)
		projectile:attach()
		projectile:load()
		projectile:tick()
		self.projectiles[projectile] = true
	end
end

function GameView:playMusic(track, song)
	-- An empty playlist should stop playing music
	if type(song) == 'table' and #song == 0 then
		song = false
	end

	-- A single song should be converted into a playlist
	if type(song) == 'string' then
		song = { song }
	end

	local currentTracks = self.music[track]

	-- Determine if this is the same playlist
	local isSame = true
	if currentTracks and type(song) == 'table' and #song == #currentTracks then
		for i = 1, #song do
			if currentTracks[i].song ~= song[i] then
				isSame = false
				break
			end
		end
	else
		isSame = false
	end

	-- If it's not the same playlist, stop playing
	if currentTracks and not isSame then
		for i = 1, #currentTracks[currentTracks.index].sounds do
			currentTracks[currentTracks.index].sounds[i]:pause(GameView.FADE_DURATION)
		end

		for i = 1, #currentTracks do
			table.insert(self.pendingMusic, currentTracks[i])
		end

		self.music[track] = nil
	end

	-- Prepare the new playlist
	if song and #song > 0 and not isSame then
		local newTracks = { index = 1 }
		for i = 1, #song do
			local sounds, instances
			do
				for i = 1, #self.pendingMusic do
					local pendingTrack = self.pendingMusic[i]
					if pendingTrack.song == song[i] then
						table.remove(self.pendingMusic, i)

						sounds = pendingTrack.sounds
						instances = pendingTrack.instances

						break
					end
				end
			end

			if not sounds then
				sounds = {}

				local directoryPath = string.format("Resources/Game/Music/%s", song[i])
				local items = love.filesystem.getDirectoryItems(directoryPath)
				table.sort(items)

				for _, item in ipairs(items) do
					if item:match(".*%.ogg$") then
						local filename = directoryPath .. "/" .. item
						local stream = love.audio.newSource(filename, 'stream')
						local sound = ripple.newSound(stream, {
							tags = { self.soundTags[track] or self.soundTags.music }
						})

						table.insert(sounds, sound)
					end
				end
			end

			-- Play the first song in the playlist immediately.
			if i == 1 then
				if instances then
					for i = 1, #instances do
						instances[i]:resume(GameView.FADE_DURATION)
						instances[i].loop = true
					end
				else
					instances = {}
					for i = 1, #sounds do
						table.insert(instances, sounds[i]:play({
							loop = true,
							fadeDuration = GameView.FADE_DURATION
						}))
					end
				end
			end

			table.insert(newTracks, {
				sounds = sounds,
				instances = instances,
				song = song[i]
			})
		end

		self.music[track] = newTracks
	end
end

function GameView:getDecorations()
	local result = {}
	local count = 0
	for k, v in pairs(self.decorations) do
		result[v.name] = v.decoration
		count = count + 1
	end

	return result, count
end

function GameView:getDecorationLayer(decoration)
	for k, v in pairs(self.decorations) do
		if v.decoration == decoration then
			return v.layer
		end
	end

	return nil
end

function GameView:getDecorationMeshes()
	local result = {}
	local count = 0
	for k, v in pairs(self.decorations) do
		result[v.name] = v.staticMesh
		count = count + 1
	end

	return result, count
end

function GameView:getDecorationSceneNodes()
	local result = {}
	local count = 0
	for k, v in pairs(self.decorations) do
		-- Only return "drawable" nodes
		if v.sceneNode and v.sceneNode:canLerp() then
			result[v.name] = v.sceneNode
			count = count + 1
		end
	end

	return result, count
end

function GameView:updateResourceManager()
	self.resourceManager:update()
end

function GameView:updateActors(delta)
	for _, actor in pairs(self.actors) do
		actor:update(delta)
	end
end

function GameView:updateProps(delta)
	for _, prop in pairs(self.props) do
		self.propViewDebugStats:measure(prop, delta)
	end
end

function GameView:updateProjectiles(delta)
	local finishedProjectiles = {}
	for projectile in pairs(self.projectiles) do
		projectile:update(delta)

		if projectile:isDone() then
			table.insert(finishedProjectiles, projectile)
		end
	end

	for i = 1, #finishedProjectiles do
		finishedProjectiles[i]:poof()
		self.projectiles[finishedProjectiles[i]] = nil
	end
end

function GameView:updateWeather(delta)
	for _, weather in pairs(self.weather) do
		weather:update(delta)
	end
end

function GameView:updateSprites(delta)
	self.spriteManager:update(delta)
end

function GameView:updateMusic(delta)
	local multiplier = 1
	if _MOBILE then
		multiplier = _CONF.volume or 1
	end

	-- Update tags
	self.soundTags.soundEffects.volume = (_CONF.soundEffectsVolume or 1) * multiplier
	self.soundTags.main.volume = (_CONF.musicVolume or 1) * multiplier
	self.soundTags.ambience.volume = (_CONF.ambienceVolume or 1) * multiplier

	-- Clear out pending music.
	do
		local index = 1
		while index <= #self.pendingMusic do
			if not self.pendingMusic[index].instances or #self.pendingMusic[index].instances < 1 or self.pendingMusic[index].instances[1]:isStopped() then
				table.remove(self.pendingMusic, index)
			else
				for i = 1, #self.pendingMusic[index].sounds do
					self.pendingMusic[index].sounds[i]:update(delta)
				end

				index = index + 1
			end
		end
	end

	-- Updating existing tracks
	for track, songs in pairs(self.music) do
		if #songs > 1 then
			local s = songs[songs.index]

			-- Play the next track if the current is stopped
			if s.instances and #s.instances[1] >= 1 and s.instances[1]:isStopped() then
				local nextIndex = songs.index + 1
				if nextIndex > #songs then
					nextIndex = 1
				end

				local n = songs[nextIndex]

				if n.instances then
					for i = 1, #n.instances do
						n.instances[i]:resume(GameView.FADE_DURATION)
					end
				elseif s.sounds then
					local instances = {}
					for i = 1, #n.instances do
						local instance = s.sound:play({
							loop = true,
							fadeDuration = GameView.FADE_DURATION
						})

						table.insert(instances, instance)
					end
				end
			-- If we're near the end of the track, fade out the last 1/2 second
			elseif s.instance and #s.intances >= 1 and (s.instance[1].duration - s.instance[1].offset) <= 0.5 then
				for i = 1, #s.instances do
					s.instances[i]:pause(GameView.FADE_DURATION)
				end
			end
		end

		for i = 1, #songs do
			local s = songs[i]

			for j = 1, #s.sounds do
				s.sounds[j]:update(delta)
			end
		end
	end
end

function GameView:updateMapQueries(delta)
	local m
	repeat
		m = love.thread.getChannel('ItsyScape.Map::output'):pop()
		if m and m.type == 'probe' then
			local test = self.tests[m.id]
			if test then
				local mapMesh = self.mapMeshes[test.layer]
				if mapMesh then
					self.tests[m.id] = nil
					local results = {}

					for i = 1, #m.tiles do
						local tile = m.tiles[i]
						local result = {
							[Map.RAY_TEST_RESULT_TILE] = mapMesh.map:getTile(tile.i, tile.j),
							[Map.RAY_TEST_RESULT_I] = tile.i,
							[Map.RAY_TEST_RESULT_J] = tile.j,
							[Map.RAY_TEST_RESULT_POSITION] = Vector(unpack(tile.position))
						}

						table.insert(results, result)
					end

					test.callback(results)
				end
			end
		end
	until m == nil
end

function GameView:update(delta)
	_APP:measure("gameView:updateResourceManager()", GameView.updateResourceManager, self)
	_APP:measure("gameView:updateActors()", GameView.updateActors, self, delta)
	_APP:measure("gameView:updateProps()", GameView.updateProps, self, delta)
	_APP:measure("gameView:updateProjectiles()", GameView.updateProjectiles, self, delta)
	_APP:measure("gameView:updateWeather()", GameView.updateWeather, self, delta)
	_APP:measure("gameView:updateSprites()", GameView.updateSprites, self, delta)
	_APP:measure("gameView:updateMusic()", GameView.updateMusic, self, delta)
	_APP:measure("gameView:updateMapQueries()", GameView.updateMapQueries, self, delta)

	if self.game:getPlayer() then
		local actor = self:getActor(self.game:getPlayer():getActor())
		if actor then
			player = actor:getSceneNode()
			local transform = player:getTransform():getGlobalDeltaTransform(0, 0, 0)
			love.audio.setPosition(transform:transformPoint(0, 0, 0))
		end
	end
end

function GameView:tick(frameDelta)
	self.generalDebugStats:measure("GameView::tickScene", self.scene.tick, self.scene, frameDelta)

	for _, actor in pairs(self.actors) do
		self.generalDebugStats:measure(
			string.format("actor::%s::tick", actor:getActor():getPeepID()),
			actor.tick,
			actor)
	end

	for _, prop in pairs(self.props) do
		self.generalDebugStats:measure(
			string.format("prop::%s::tick", prop:getProp():getPeepID()),
			prop.tick,
			prop)
	end

	for projectile in pairs(self.projectiles) do
		self.generalDebugStats:measure(
			string.format("projectile::%s::tick", projectile:getID()),
			projectile.tick,
			projectile)
	end
end

function GameView:quit()
	love.thread.getChannel('ItsyScape.Map::input'):push({
		type = 'quit'
	})

	self.mapThread:wait()
end

function GameView:dirty()
	for layer, map in pairs(self.mapMeshes) do
		local mapMeshMasks = map.mapMeshMasks
		if mapMeshMasks then
			Log.info("Resetting map mesh masks on layer %d.", layer)

			for _, mapMeshMask in ipairs(mapMeshMasks) do
				mapMeshMask:initializeCanvas()
			end

			map.mask = MapMeshMask.combine(unpack(mapMeshMasks))

			for _, node in ipairs(map.parts) do
				node:getMaterial():setTextures(map.texture, map.mask:getTexture())
			end
		end
	end
end

function GameView:dumpStatsToCSV()
	self.propViewDebugStats:dumpStatsToCSV("GameView_PropView_Update")
	self.generalDebugStats:dumpStatsToCSV("GameView_Tick")
end

return GameView
