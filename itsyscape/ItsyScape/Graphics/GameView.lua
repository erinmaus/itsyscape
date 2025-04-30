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
local MathCommon = require "ItsyScape.Common.Math.Common"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local ActorView = require "ItsyScape.Graphics.ActorView"
local Color = require "ItsyScape.Graphics.Color"
local DebugStats = require "ItsyScape.Graphics.DebugStats"
local Decoration = require "ItsyScape.Graphics.Decoration"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local LayerTextureResource = require "ItsyScape.Graphics.LayerTextureResource"
local Material = require "ItsyScape.Graphics.Material"
local MapMeshSceneNode = require "ItsyScape.Graphics.MapMeshSceneNode"
local ModelResource = require "ItsyScape.Graphics.ModelResource"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"
local OutlinePostProcessPass = require "ItsyScape.Graphics.OutlinePostProcessPass"
local PostProcessPass = require "ItsyScape.Graphics.PostProcessPass"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local Spline = require "ItsyScape.Graphics.Spline"
local SplineSceneNode = require "ItsyScape.Graphics.SplineSceneNode"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local Renderer = require "ItsyScape.Graphics.Renderer"
local ResourceManager = require "ItsyScape.Graphics.ResourceManager"
local SpriteManager = require "ItsyScape.Graphics.SpriteManager"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local SSRPostProcessPass = require "ItsyScape.Graphics.SSRPostProcessPass"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ToneMapPostProcessPass = require "ItsyScape.Graphics.ToneMapPostProcessPass"
local WaterMeshSceneNode = require "ItsyScape.Graphics.WaterMeshSceneNode"
local LargeTileSet = require "ItsyScape.World.LargeTileSet"
local Map = require "ItsyScape.World.Map"
local MapCurve = require "ItsyScape.World.MapCurve"
local MapMeshIslandProcessor = require "ItsyScape.World.MapMeshIslandProcessor"
local TileSet = require "ItsyScape.World.TileSet"
local MapMeshMask = require "ItsyScape.World.MapMeshMask"
local MultiTileSet = require "ItsyScape.World.MultiTileSet"
local WeatherMap = require "ItsyScape.World.WeatherMap"
local Block = require "ItsyScape.World.GroundDecorations.Block"
local SkyboxSceneNode = require "ItsyScape.Graphics.SkyboxSceneNode"
local NShaderCache = require "nbunny.optimaus.shadercache"

local GameView = Class()
GameView.MAP_MESH_DIVISIONS = 16
GameView.FADE_DURATION = 2
GameView.ACTOR_CANVAS_CELL_SIZE = 32

GameView.PropViewDebugStats = Class(DebugStats)
function GameView.PropViewDebugStats:process(node, delta)
	node:update(delta)
end

function GameView:new(game, camera)
	self.game = game
	self.camera = camera
	self.actors = {}
	self.props = {}
	self.views = {}
	self.propViewDebugStats = GameView.PropViewDebugStats()
	self.generalDebugStats = DebugStats.GlobalDebugStats()

	self.scene = SceneNode()
	self.mapMeshes = {}
	self.skyboxes = {}
	self.tests = { id = 1 }

	self.water = {}

	self.decorations = {}

	self.resourceManager = ResourceManager()
	self.spriteManager = SpriteManager(self, self.resourceManager)

	self:initRenderer(_CONF)

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

	self.actorCanvasCircle = love.graphics.newImage("ItsyScape/Graphics/Resources/GameViewActorCanvasCircle.png")

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

function GameView:getCamera()
	return self.camera
end

function GameView:initRenderer(conf)
	self.renderer = Renderer({
		shadows = conf and conf.shadows,
		outlines = conf and conf.outlines,
		reflections = conf and conf.reflections
	})
	self.renderer:setCamera(self.camera)

	self.sceneOutlinePostProcessPass = OutlinePostProcessPass(self.renderer)
	self.sceneOutlinePostProcessPass:load(self.resourceManager)
	self.sceneOutlinePostProcessPass:setIsEnabled(not conf or conf.outlines == nil or not not conf.outlines)

	self.ssrPostProcessPass = SSRPostProcessPass(self.renderer)
	self.ssrPostProcessPass:load(self.resourceManager)
	self.ssrPostProcessPass:setMinMaxSecondPassSteps(_CONF.ssrMinSecondPassSteps, _CONF.ssrMaxSecondPassSteps)
	self.ssrPostProcessPass:setMaxFirstPassSteps(_CONF.ssrMaxFirstPassSteps)
	self.ssrPostProcessPass:setMaxDistanceViewSpace(_CONF.ssrMaxDistanceViewSpace)

	self.skyboxOutlinePostProcessPass = OutlinePostProcessPass(self.renderer)
	self.skyboxOutlinePostProcessPass:load(self.resourceManager)
	self.skyboxOutlinePostProcessPass:setMinOutlineThickness(1)
	self.skyboxOutlinePostProcessPass:setMaxOutlineThickness(1)
	self.skyboxOutlinePostProcessPass:setNearOutlineDistance(0)
	self.skyboxOutlinePostProcessPass:setFarOutlineDistance(1000)
	self.skyboxOutlinePostProcessPass:setMinOutlineDepthAlpha(1)
	self.skyboxOutlinePostProcessPass:setMaxOutlineDepthAlpha(1)
	self.skyboxOutlinePostProcessPass:setOutlineFadeDepth(1000)
	self.skyboxOutlinePostProcessPass:setIsEnabled(not conf or conf.outlines == nil or not not conf.outlines)

	self.toneMapPostProcessPass = ToneMapPostProcessPass(self.renderer)
	self.toneMapPostProcessPass:load(self.resourceManager)

	self.shaderCache = PostProcessPass(self.renderer, 0)
	self.shaderCache:load(self.resourceManager)
	self.bumpCanvasShader = self.shaderCache:loadPostProcessShader("BumpCanvas")
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

	self._onMapMoved = function(_, layer, position, rotation, scale, offset, disabled, parentLayer)
		self:moveMap(layer, position, rotation, scale, offset, disabled, parentLayer)
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

	self._onDropItem = function(_, ref, item, tile, position, source)
		Log.info("Dropped item '%s' (ref = %d, count = %d) at (%d, %d) on layer %d.", item.id, ref, item.count, tile.i, tile.j, tile.layer)
		self:spawnItem(item, tile, position, source)
	end
	stage.onDropItem:register(self._onDropItem)

	self._onTakeItem = function(_, ref, item, source)
		Log.info("Item '%s' (ref = %d, count = %d) taken.", item.id, ref, item.count)
		self:poofItem(item, source)
	end
	stage.onTakeItem:register(self._onTakeItem)

	self._onDecorate = function(_, group, decoration, layer)
		Log.info("Decorating '%s' (%s) on layer %d.", group, decoration.type, layer)
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

	table.clear(self.views)

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

	local mapResourceName, localLayer
	if filename then
		mapResourceName, localLayer = filename:match("Resources/Game/Maps/([^/]+)/(%d+).lmap")
		localLayer = localLayer and tonumber(localLayer)
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

	local largeTileSet = LargeTileSet(tileSet)

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

	local node
	if meta and meta.skybox then
		node = SkyboxSceneNode()

		local color = meta.skybox.color or {}
		if type(color) == "string" then
			color = Color.fromHexString(color)
		else
			color = Color(unpack(color))
		end

		self.skyboxes[node] = {
			color = color
		}
	else
		node = SceneNode()
	end

	local actorCanvas = love.graphics.newCanvas(
		map:getWidth() * GameView.ACTOR_CANVAS_CELL_SIZE,
		map:getHeight() * GameView.ACTOR_CANVAS_CELL_SIZE,
		{ format = "rgba16f" })
	actorCanvas:setFilter("linear", "linear")
	local bumpCanvas = love.graphics.newCanvas(
		map:getWidth() * GameView.ACTOR_CANVAS_CELL_SIZE,
		map:getHeight() * GameView.ACTOR_CANVAS_CELL_SIZE,
		{ format = "rgba16f" })
	bumpCanvas:setFilter("linear", "linear")

	local m = {
		tileSet = tileSet,
		largeTileSet = largeTileSet,
		texture = texture,
		tileSetID = tileSetID or "GrassyPlain",
		filename = filename,
		resource = mapResourceName,
		localLayer = localLayer or 1,
		map = map,
		node = node,
		parts = {},
		layer = layer,
		weatherMap = WeatherMap(layer, -8, -8, map:getCellSize(), map:getWidth() + 16, map:getHeight() + 16),
		maskID = maskID,
		mapMeshMasks = mapMeshMasks,
		mask = mapMeshMasks and MapMeshMask.combine(unpack(mapMeshMasks)),
		islandProcessor = mapMeshMasks and meta.autoMask and MapMeshIslandProcessor(map, tileSet),
		meta = meta,
		wallHackEnabled = not (meta and type(meta.wallHack) == "table" and meta.wallHack.enabled == false),
		actorCanvas = actorCanvas,
		bumpCanvas = bumpCanvas,
		wallHackDecorations = setmetatable({}, { __mode = "k" }),
		decorationTextures = setmetatable({}, { __mode = "v" }),
		staticGroundDecorations = {},
		dynamicGroundDecorations = {}
	}

	m.weatherMap:addMap(m.map)

	m.largeTileSet:resize(m.map)
	self.resourceManager:queueAsyncEvent(function()
		m.largeTileSet:emitAll(m.map)
	end)

	self.mapMeshes[layer] = m
end

function GameView:removeMap(layer)
	local m = self.mapMeshes[layer]
	if m then
		if self.skyboxes[m.node] then
			self.skyboxes[m.node] = nil
		else
			m.node:setParent(nil)
		end

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

function GameView:_getIsMapEditor()
	return _APP:getType() == require "ItsyScape.Editor.MapEditorApplication"
end

function GameView:updateGroundDecorations(m)
	if self:_getIsMapEditor() then
		Log.info("Map editor: not updating ground decorations.")
		return
	end
	
	if m.meta and m.meta.disableGroundDecorations then
		Log.info("Not updating ground decorations; explicitly disabled.")
		return
	end
		
	local tileSetIDs
	if type(m.tileSetID) == 'string' then
		if m.filename and self:_getIsMapEditor() then
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

	local function updateDecorationMaterial(d, group)
		d.sceneNode:getMaterial():setOutlineThreshold(0.5)
		d.sceneNode:getMaterial():setOutlineColor(Color.fromHexString("aaaaaa"))
		d.sceneNode:getMaterial():setIsShadowCaster(false)

		local group = d.decoration:getUniform("_x_Group")

		if group == Block.GROUP_SHINY then
			d.sceneNode:getMaterial():setIsReflectiveOrRefractive(true)
			d.sceneNode:getMaterial():setReflectionPower(1.0)
			d.sceneNode:getMaterial():setReflectionDistance(0.75)
			d.sceneNode:getMaterial():setRoughness(0.5)
		elseif group == Block.GROUP_BENDY then
			local newTexture = m.decorationTextures[d.texture:getID()]
			if not newTexture then
				newTexture = TextureResource(d.texture:getResource())
				newTexture:getHandle():setBoundTexture("Specular", d.texture:getHandle():getBoundTexture("Specular"))
				newTexture:getHandle():setBoundTexture("Heightmap", d.texture:getHandle():getBoundTexture("Heightmap"))
				m.decorationTextures[d.texture:getID()] = newTexture
			end

			d.texture = newTexture
			d.sceneNode:getMaterial():setTextures(newTexture)
			if d.alphaSceneNode then
				d.alphaSceneNode:getMaterial():setTextures(newTexture)
			end

			local shader = self.resourceManager:load(ShaderResource, "Resources/Shaders/BendyDecoration")
			d.sceneNode:getMaterial():setShader(shader)
			self:_updateWind(m.layer, d.sceneNode)
		end

		if group ~= Block.GROUP_STATIC then
			table.insert(m.dynamicGroundDecorations, d)
		else
			table.insert(m.staticGroundDecorations, d)
		end
		
		d.isGroundDecoration = true

		m.wallHackDecorations[d.sceneNode] = true
		m.wallHackDirty = true
	end

	local cachedGroundDecorationDirectory = m.resource and string.format("Resources/Game/Maps/%s/GroundDecorationsCache", m.resource)
	if cachedGroundDecorationDirectory and love.filesystem.getInfo(cachedGroundDecorationDirectory) and not (m.meta and m.meta.disableCaching) then
		local cachedGroundDecorations = love.filesystem.getDirectoryItems(cachedGroundDecorationDirectory)
		table.sort(cachedGroundDecorations)

		self.resourceManager:queueAsyncEvent(function()
			for _, filename in ipairs(cachedGroundDecorations) do
				local index, tileSetID, layer = filename:match("_x_GroundDecorations_(%d+)_(.+)@(%d+).ldeco.cache")

				local hasTileSetID = false
				if tileSetID then
					for _, otherTileSetID in ipairs(tileSetIDs) do
						if tileSetID == otherTileSetID then
							hasTileSetID = true
							break
						end
					end
				end

				layer = layer and tonumber(layer)
				index = index and tonumber(index)

				if index and layer and tileSetID and layer == m.localLayer then
					local fullFilename = string.format("%s/%s", cachedGroundDecorationDirectory, filename)
					local decoration = Decoration(buffer.decode(love.filesystem.read(fullFilename)))

					local group = decoration:getUniform("_x_Group")
					decoration:setIsWall(group == Block.GROUP_STATIC)

					local groupName = string.format("_x_GroundDecorations_%d_%s@%d", index, tileSetID, layer)
					self:decorate(groupName, decoration, m.layer, updateDecorationMaterial)
				end
			end
		end)
	else
		Log.info("No cached ground decorations for '%s' on layer %d.", m.filename or "<dynamic map>", m.layer)

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
					self.resourceManager:queueAsyncEvent(function()
						ground:emitAll(m.tileSet, m.map)

						for i = 1, ground:getDecorationCount() do
							local decoration, group = ground:getDecorationAtIndex(i)
							local groupName = string.format("_x_GroundDecorations_%d_%s@%d", i, tileSetID, m.layer)

							decoration:setUniform("_x_Group", group)
							decoration:setIsWall(group == Block.GROUP_STATIC)

							self:decorate(groupName, decoration, m.layer, updateDecorationMaterial)
						end
					end)
				end
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

	love.thread.getChannel("ItsyScape.Map::input"):push({
		type = "probe",
		id = id,
		key = layer,
		origin = { ray.origin.x, ray.origin.y, ray.origin.z },
		direction = { ray.direction.x, ray.direction.y, ray.direction.z }
	})

	if self:_getIsMapEditor() then
		self:_processMapQuery(love.thread.getChannel('ItsyScape.Map::output'):demand())
	end
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

			if m.lastFilename and m.lastFilename == m.filename then
				Log.info("Map loaded from file; cannot change, aborting update.")
				return
			else
				m.lastFilename = m.filename
			end

			if m.map ~= map then
				if m.map and (m.map:getWidth() ~= map:getWidth() or m.map:getHeight() ~= map:getHeight()) then
					m.largeTileSet:resize(map)
					self.resourceManager:queueAsyncEvent(function()
						m.largeTileSet:emitAll(map)
					end)
				end 

				m.map = map
			end
		end

		if m.islandProcessor then
			m.islandProcessor = MapMeshIslandProcessor(m.map, m.tileSet)
		end

		if not (m.meta and m.meta.skybox) then
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

		local node = MapMeshSceneNode()
		node:setParent(m.node)
		table.insert(m.parts, node)

		local alphaNode
		if m.wallHackEnabled then
			alphaNode = MapMeshSceneNode()
			alphaNode:getMaterial():setIsTranslucent(true)
			alphaNode:getMaterial():setOutlineThreshold(-1.0)
			alphaNode:setParent(m.node)

			table.insert(m.parts, alphaNode)
		end

		if m.meta and m.meta.material then
			local metaMaterial = m.meta.material
			for _, part in ipairs(m.parts) do
				local material = part:getMaterial()
				if metaMaterial.isReflectiveOrRefractive then
					material:setIsReflectiveOrRefractive(true)
				else
					material:setIsReflectiveOrRefractive(false)
				end

				if metaMaterial.reflectionPower then
					material:setReflectionPower(metaMaterial.reflectionPower)
				else
					material:setReflectionPower(0)
				end

				if metaMaterial.reflectionRoughness then
					material:setRoughness(metaMaterial.reflectionRoughness)
				elseif material.isReflectiveOrRefractive then
					material:setRoughness(0)
				end

				if metaMaterial.reflectionDistance then
					material:setReflectionDistance(metaMaterial.reflectionDistance)
				elseif material.setIsReflectiveOrRefractive then
					material:setReflectionDistance(1)
				end
			end
		end

		local function _update()
			local vertices
			if m.filename ~= nil and m.meta and not m.meta.disableCaching then
				local filename = string.format("%s.mapmesh", m.filename)
				if love.filesystem.getInfo(filename) then
					vertices = buffer.decode(love.filesystem.read(filename))
				end
			end

			if vertices then
				node:fromVertices(vertices.data, Vector(unpack(vertices.min)), Vector(unpack(vertices.max)))
			else
				node:fromMap(
					m.map,
					m.tileSet,
					1, 1,
					m.map:getWidth(),
					m.map:getHeight(),
					m.mapMeshMasks,
					m.islandProcessor,
					m.largeTileSet)
			end

			m.node:setBounds(node:getBounds())

			if m.mapMeshMasks then
				node:getMaterial():setTextures(m.largeTileSet:getDiffuseTexture(), m.mask:getTexture(), m.largeTileSet:getSpecularTexture())
			else
				node:getMaterial():setTextures(m.largeTileSet:getDiffuseTexture(), self.defaultMapMaskTexture, m.largeTileSet:getSpecularTexture())
			end

			if alphaNode then
				alphaNode:setMapMesh(node:getMapMesh(), true)
				self:_updateMapNode(m, alphaNode)

				if m.mapMeshMasks then
					alphaNode:getMaterial():setTextures(m.largeTileSet:getDiffuseTexture(), m.mask:getTexture(), m.largeTileSet:getSpecularTexture())
				else
					alphaNode:getMaterial():setTextures(m.largeTileSet:getDiffuseTexture(), self.defaultMapMaskTexture, m.largeTileSet:getSpecularTexture())
				end
			end

			self:_updateMapNode(m, node)
		end

		if self:_getIsMapEditor() then
			_update()
		else
			self.resourceManager:queueAsyncEvent(_update)
		end

		node:getMaterial():send(Material.UNIFORM_FLOAT, "scape_WallHackAlpha", 0.0)
		if alphaNode then
			alphaNode:getMaterial():send(Material.UNIFORM_FLOAT, "scape_WallHackAlpha", 1.0)
		end

		m.weatherMap:addMap(m.map)

		self.resourceManager:queueEvent(self.updateGroundDecorations, self, m)
	end
end

function GameView:moveMap(layer, position, rotation, scale, offset, disabled, parentLayer)
	local m = self.mapMeshes[layer]
	local node = m and m.node
	if node then
		local transform = node:getTransform()
		transform:setLocalTranslation(position)
		transform:setLocalRotation(rotation)
		transform:setLocalScale(scale)
		transform:setLocalOffset(offset)

		love.thread.getChannel('ItsyScape.Map::input'):push({
			type = "transform",
			key = layer,
			parentKey = parentLayer,
			transform = transform:getLocalDeltaTransform(1),
		})

		local parentNode = parentLayer and self:getMapSceneNode(parentLayer)
		parentNode = parentNode or self.scene

		if disabled and node:getParent() then
			parentNode = nil
			node:setParent(nil)
		elseif not disabled and not node:getParent() and not self.skyboxes[node] then
			node:setParent(parentNode)
			node:tick(1)
		end

		if parentNode ~= node:getParent() and not self.skyboxes[node] then
			node:setParent(parentNode)
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

function GameView:_updateWind(layer, node)
	local m = self.mapMeshes[layer]
	if not m then
		return
	end

	local windDirection, windSpeed, windPattern, bumpCanvas = self:getWind(layer)
	local material = node:getMaterial()
	material:send(material.UNIFORM_TEXTURE, "scape_BumpCanvas", bumpCanvas)
	material:send(material.UNIFORM_FLOAT, "scape_MapSize", m.map:getWidth() * m.map:getCellSize(), m.map:getHeight() * m.map:getCellSize())
	material:send(material.UNIFORM_FLOAT, "scape_WindDirection", windDirection:get())
	material:send(material.UNIFORM_FLOAT, "scape_WindSpeed", windSpeed)
	material:send(material.UNIFORM_FLOAT, "scape_WindPattern", windPattern:get())
end

function GameView:_updateMapNodeWallHack(m)
	local wallHackEnabled = m.wallHackEnabled == nil or m.wallHackEnabled
	local wallHackLeft, wallHackRight, wallHackTop, wallHackBottom, wallHackNear = 1.25, 1.25, 4, 0.25, 8
	if wallHackEnabled and not self:_getIsMapEditor() then
		if m.meta and type(m.meta.wallHack) == "table" then
			wallHackLeft = m.meta.wallHack.left or wallHackLeft
			wallHackRight = m.meta.wallHack.right or wallHackRight
			wallHackTop = m.meta.wallHack.top or wallHackTop
			wallHackBottom = m.meta.wallHack.bottom or wallHackBottom
			wallHackNear = m.meta.wallHackNear or wallHackNear
		end
	else
		wallHackLeft = 0
		wallHackRight = 0
		wallHackTop = 0
		wallHackBottom = 0
		wallHackNear = 0
	end

	local globalTransform = m.node:getTransform():getGlobalDeltaTransform(_APP:getPreviousFrameDelta())
	local _, rotation = MathCommon.decomposeTransform(globalTransform)
	local up = rotation:transformVector(Vector.UNIT_Y):getNormal()

	local wallHackParameters = m.wallHackParameters
	if not wallHackParameters or m.wallHackDirty or
	   wallHackParameters.left ~= wallHackLeft or wallHackParameters.right ~= wallHackRight or
	   wallHackParameters.top ~= wallHackTop or wallHackParameters.bottom ~= wallHackBottom or
	   wallHackParameters.near ~= wallHackNear or wallHackParameters.up ~= up
	then
		wallHackParameters = wallHackParameters or {}
		wallHackParameters.left = wallHackLeft
		wallHackParameters.right = wallHackRight
		wallHackParameters.top = wallHackTop
		wallHackParameters.bottom = wallHackBottom
		wallHackParameters.near = wallHackNear
		wallHackParameters.up = up:keep(wallHackParameters.up)

		m.wallHackParameters = wallHackParameters
		m.wallHackDirty = false

		for _, part in ipairs(m.parts) do
			local material = part:getMaterial()
			material:send(Material.UNIFORM_FLOAT, "scape_WallHackWindow", wallHackLeft, wallHackRight, wallHackTop, wallHackBottom)
			material:send(Material.UNIFORM_FLOAT, "scape_WallHackNear", wallHackNear)
			material:send(Material.UNIFORM_FLOAT, "scape_WallHackUp", up:get())
		end
		
		for decoration in pairs(m.wallHackDecorations) do
			local material = decoration:getMaterial()
			material:send(Material.UNIFORM_FLOAT, "scape_WallHackWindow", wallHackLeft, wallHackRight, wallHackTop, wallHackBottom)
			material:send(Material.UNIFORM_FLOAT, "scape_WallHackNear", wallHackNear)
			material:send(Material.UNIFORM_FLOAT, "scape_WallHackUp", up:get())
		end
	end
end

function GameView:_updateMapNode(m, node)
	local mapMesh = node:getMapMesh()
	if not mapMesh then
		return
	end

	local min, max = mapMesh:getBounds()
	local halfSize = (max - min) / 2

	local newMin, newMax = min, max
	for _, curve in ipairs(m.curves or {}) do
		local positions = curve:getPositions()

		for i = 1, positions:length() do
			local position = positions:get(i):getValue()
			newMin = newMin:min(position - halfSize)
			newMin = newMin:min(position + halfSize)
			newMax = newMax:max(position - halfSize)
			newMax = newMax:max(position + halfSize)
		end
	end

	node:setBounds(newMin, newMax)

	local material = node:getMaterial()
	if m.curves and #m.curves > 0 then
		for i = 1, #m.curves do
			local curve = m.curves[i]

			local axisUniform = string.format("scape_Curves[%d].axis", i - 1)
			local sizeUniform = string.format("scape_Curves[%d].size", i - 1)

			material:send(Material.UNIFORM_FLOAT, axisUniform, { curve:getAxis():get() })

			local min, max = curve:getMin(), curve:getMax()
			local size = { min.x, min.z, max.x, max.z }
			material:send(Material.UNIFORM_FLOAT, sizeUniform, size)
		end

		material:send(Material.UNIFORM_TEXTURE, "scape_CurveTextures", m.curveTexture)
		material:send(Material.UNIFORM_INTEGER, "scape_NumCurves", #m.curves)
		material:send(Material.UNIFORM_FLOAT, "scape_MapSize", { m.map:getWidth() * m.map:getCellSize(), m.map:getHeight() * m.map:getCellSize() })
	else
		material:send(Material.UNIFORM_INTEGER, "scape_NumCurves", 0)
	end
end

function GameView:_updatePlayerMapNode()
	local near = 0

	local playerActor = self.game:getPlayer() and self.game:getPlayer():getActor()
	if not playerActor then
		return
	end

	local _, _, layer = playerActor:getTile()
	local m = self.mapMeshes[layer]
	if not m then
		return
	end

	local delta = _APP:getFrameDelta()

	-- local distanceSquared = (self.camera:getDistance() * 2) ^ 2
	-- local position = self.camera:getPosition()
	-- local playerMin = position - Vector.PLANE_XZ
	-- local playerMax = position + Vector.PLANE_XZ
	-- for _, d in ipairs(m.dynamicGroundDecorations) do
	-- 	local decorationMin, decorationMax = d.sceneNode:getBounds()
	-- 	decorationMin, decorationMax = Vector.transformBounds(decorationMin, decorationMax, m.node:getTransform():getGlobalDeltaTransform(delta))

	-- 	local u = (playerMin - decorationMax):max(Vector.ZERO)
	-- 	local v = (decorationMin - playerMax):max(Vector.ZERO)
	-- 	local squaredDistance = u:getLengthSquared() + v:getLengthSquared()

	-- 	if squaredDistance <= distanceSquared then
	-- 		if d.sceneNode:getParent()  ~= m.node then
	-- 			d.sceneNode:setParent(m.node)
	-- 		end

	-- 		if d.alphaSceneNode and d.alphaSceneNode:getParent()  ~= m.node then
	-- 			d.alphaSceneNode:setParent(m.node)
	-- 		end
	-- 	else
	-- 		if d.sceneNode:getParent() == m.node then
	-- 			d.sceneNode:setParent(nil)
	-- 		end
	-- 	end
	-- end

	local _, playerI, playerJ = m.map:getTileAt(self.camera:getPosition().x, self.camera:getPosition().z)

	local eye = self.camera:getEye()
	local _, eyeI, eyeJ = m.map:getTileAt(eye.x, eye.z)

	local differenceI = eyeI - playerI
	local differenceJ = eyeJ - playerJ

	local forward = self.camera:getForward()
	forward.y = -forward.y

	local ray = Ray(self.camera:getPosition() + Vector(0, 0.5, 0), forward)
	if math.abs(differenceI) > math.abs(differenceJ) then
		local directionI = math.sign(differenceI)

		local stopI
		if directionI < 0 then
			stopI = 1
		else
			stopI = m.map:getWidth()
		end

		local isHidden = false
		for i = playerI + directionI, stopI, directionI do
			local center = m.map:getTileCenter(i, playerJ)
			local _, projection = ray:closest(center)

			isHidden = center.y > projection.y
			if isHidden then
				break
			end
		end

		if isHidden then
			local foundCliff = false
			for i = playerI + directionI, stopI, directionI do
				local center = m.map:getTileCenter(i, playerJ)
				local _, projection = ray:closest(center)

				if center.y > projection.y then
					foundCliff = true
				elseif foundCliff or i == stopI then
					foundCliff = true
					near = (math.abs(i - playerI) + 1) * m.map:getCellSize() + 0.5
					break
				end
			end
		end
	else
		local directionJ = math.sign(differenceJ)

		local stopJ
		if directionJ < 0 then
			stopJ = 1
		else
			stopJ = m.map:getHeight()
		end

		local isHidden = false
		for j = playerJ + directionJ, stopJ, directionJ do
			local center = m.map:getTileCenter(playerI, j)
			local _, projection = ray:closest(center)

			isHidden = center.y > projection.y
			if isHidden then
				break
			end
		end

		if isHidden then
			local foundCliff = false
			for j = playerJ + directionJ, stopJ, directionJ do
				local center = m.map:getTileCenter(playerI, j)
				local _, projection = ray:closest(center)

				if center.y > projection.y then
					foundCliff = true
				elseif foundCliff or j == stopJ then
					foundCliff = true
					near = (math.abs(j - playerJ) + 1) * m.map:getCellSize() + 0.5
					break
				end
			end
		end
	end

	for _, node in ipairs(m.parts) do
		node:getMaterial():send(Material.UNIFORM_FLOAT, "scape_WallHackNear", near)
	end

	if self.previousPlayerLayer and self.previousPlayerLayer ~= layer then
		local otherM = self.previousPlayerLayer and self.mapMeshes[self.previousPlayerLayer]
		if otherM then
			for _, node in ipairs(otherM.parts) do
				node:getMaterial():send(Material.UNIFORM_FLOAT, "scape_WallHackNear", 0)
			end

			for _, node in pairs(otherM.decorations) do
				node:setParent(nil)
			end
		end

		self.previousPlayerLayer = layer
	end
end

function GameView:bendMap(layer, ...)
	local m = self.mapMeshes[layer]
	if not m then
		return
	end

	local curveInfos = { ... }
	local curves = {}
	for _, curveInfo in ipairs(curveInfos) do
		local curve = MapCurve(m.map, curveInfo)
		table.insert(curves, curve)
	end

	local textures = {}
	for i = 1, #curves do
		textures[i] = curves[i]:getCurveTexture()
	end

	m.curves = curves

	if #curves >= 1 then
		m.curveTexture = love.graphics.newArrayImage(textures)
		m.curveTexture:setFilter("linear", "linear")
	else
		m.curveTexture = nil
	end

	for _, node in ipairs(m.parts) do
		self:_updateMapNode(m, node)
	end

	for _, decorationInfo in pairs(self.decorations) do
		if decorationInfo.layer == layer then
			self:_updateMapNode(m, decorationInfo.sceneNode)
			
			if decorationInfo.alphaSceneNode then
				self:_updateMapNode(m, decorationInfo.alphaSceneNode)
			end
		end
	end

	love.thread.getChannel('ItsyScapende.Map::input'):push({
		type = 'bend',
		key = layer,
		config = curves[1] and curves[1]:toConfig()
	})	
end

function GameView:setSkyboxColor(layer, color)
	local m = self.mapMeshes[layer]
	if m then
		local skybox = self.skyboxes[m.node]
		if skybox then
			skybox.color = color
		end
	end
end

function GameView:getMapSceneNode(layer)
	local m = self.mapMeshes[layer]
	if m then
		return m.node
	end
end

function GameView:getMapMeshSceneNodes(layer)
	local m = self.mapMeshes[layer]
	if m then
		return unpack(m.parts)
	end
end

function GameView:getMapTileSet(layer)
	local m = self.mapMeshes[layer]
	if m then
		return m.tileSet, m.tileSetID, m.largeTileSet
	end
end

function GameView:getMapCurves(layer)
	local m = self.mapMeshes[layer]
	if m then
		return m.curves
	end
end

function GameView:getMap(layer)
	local m = self.mapMeshes[layer]
	if m then
		return m.map
	end
end

function GameView:getWind(layer)
	local m = self.mapMeshes[layer]
	if m then
		return (m.meta.windDirection and Vector(unpack(m.meta.windDirection)) or Vector(-1, 0, -1)):getNormal(),
		       m.meta.windSpeed or 4,
		       m.meta.windPattern and Vector(unpack(m.meta.windPattern)) or Vector(5, 10, 15),
		       m.bumpCanvas
	end

	return Vector(-1, 0, -1):getNormal(), 4, Vector(5, 10, 15), self.whiteTexture:getResource()
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

	self.actors[actor:getID()] = view
	self.views[actor] = view
end

function GameView:getActor(actor)
	if actor then
		return self.actors[actor:getID()]
	end

	return nil
end

function GameView:getActorByID(id)
	local actorView = self.actors[id]
	return actorView and actorView:getActor()
end

function GameView:removeActor(actor)
	if actor and self.actors[actor:getID()] then
		self.actors[actor:getID()]:release()
		self.actors[actor:getID()] = nil
		self.views[actor] = nil
	end
end

function GameView:hasActor(actor)
	return self.actors[actor:getID()] ~= nil
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

	self.props[prop:getID()] = view
	self.views[prop] = view
end

function GameView:getProp(prop)
	if prop then
		return self.props[prop:getID()]
	end

	return nil
end

function GameView:getPropByID(id)
	local propView = self.props[id]
	return propView and propView:getProp()
end

function GameView:removeProp(prop)
	if prop and self.props[prop:getID()] then
		self.props[prop:getID()]:remove()
		self.props[prop:getID()] = nil
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

function GameView:spawnItem(item, tile, position)
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
	end

	local map = self:getMapSceneNode(tile.layer)
	if not map then
		map = self.scene
	end

	itemNode:getTransform():translate(position)
	itemNode:setParent(map)

	_APP:getUIView():playItemSoundEffect(item, { id = -1, type = "Drop" })

	self.items[item.ref] = itemNode
end

function GameView:poofItem(item)
	local node = self.items[item.ref]
	if node then
		node:setParent(nil)

		self.items[item.ref] = nil
	end

	_APP:getUIView():playItemSoundEffect(item, { id = -1, type = "Take" })
end

function GameView:getItem(ref)
	return self.items[ref]
end

function GameView:decorate(group, decoration, layer, callback)
	local m = self.mapMeshes[layer]
	if not m then
		return
	end

	local groupName = group .. '#' .. tostring(layer)
	if self.decorations[groupName] and
	   self.decorations[groupName].sceneNode
	then
		local d = self.decorations[groupName]

		if d.isGroundDecoration then
			local groundDecorations
			if d.decoration:getUniform("_x_Group") == Block.GROUP_STATIC then
				groundDecorations = m.staticGroundDecorations
			else
				groundDecorations = m.dynamicGroundDecorations
			end

			for i = #groundDecorations, 1, -1 do
				if groundDecorations[i] == d then
					table.remove(groundDecorations, i)
				end
			end
		end

		d.sceneNode:setParent(nil)
		if d.alphaSceneNode then
			d.alphaSceneNode:setParent(nil)
		end

		self.decorations[groupName] = nil
	end

	local map = self:getMapSceneNode(layer)
	if not map then
		map = self.scene
	end

	if not Class.isClass(decoration) and decoration then
		local Type = require(decoration.type)
		decoration = Type(decoration.value)
	end

	local isSpline = Class.isCompatibleType(decoration, Spline)
	local isDecoration = Class.isCompatibleType(decoration, Decoration)
	local isValid = isSpline or isDecoration

	if decoration and isValid then
		local d = {}

		local sceneNode
		if isSpline then
			sceneNode = SplineSceneNode()
		elseif isDecoration then
			sceneNode = DecorationSceneNode()
		end

		self.resourceManager:queueAsyncEvent(function()
			local tileSetFilename = string.format(
				"Resources/Game/TileSets/%s/Layout.lstatic",
				decoration:getTileSetID())
			local staticMesh = self.resourceManager:load(
				StaticMeshResource,
				tileSetFilename)

			local textureFilename = string.format(
				"Resources/Game/TileSets/%s/Texture.png",
				decoration:getTileSetID())
			local layerTextureFilename = string.format(
				"Resources/Game/TileSets/%s/Texture.lua",
				decoration:getTileSetID())

			local texture
			if love.filesystem.getInfo(layerTextureFilename) then
				texture = self.resourceManager:load(
					LayerTextureResource,
					layerTextureFilename)
			else
				texture = self.resourceManager:load(
					TextureResource,
					textureFilename)
			end

			if isSpline then
				sceneNode:fromSpline(decoration, staticMesh:getResource())
				sceneNode:getMaterial():setTextures(texture)
			else
				sceneNode:fromDecoration(decoration, staticMesh:getResource())
				sceneNode:getMaterial():setTextures(texture)
			end

			if self.decorations[groupName] ~= d then
				Log.debug("Decoration group '%s' has been overwritten; ignoring.", groupName)
				return
			end

			sceneNode:setParent(map)

			if decoration:getIsWall() and not self:_getIsMapEditor() then
				local shader
				if Class.isCompatibleType(texture, LayerTextureResource) then
					shader = self.resourceManager:load(
						ShaderResource,
						"Resources/Shaders/MultiTextureWallDecoration")
				else
					shader = self.resourceManager:load(
						ShaderResource,
						"Resources/Shaders/WallDecoration")
				end

				sceneNode:getMaterial():setShader(shader)
				sceneNode:getMaterial():send(Material.UNIFORM_FLOAT, "scape_WallHackAlpha", 0.0)

				local alphaSceneNode
				if isSpline then
					alphaSceneNode = SplineSceneNode()
					alphaSceneNode:fromSpline(decoration, staticMesh:getResource())
				else
					alphaSceneNode = DecorationSceneNode()
					alphaSceneNode:fromDecoration(decoration, staticMesh:getResource())
				end

				alphaSceneNode:getMaterial():setTextures(texture)
				alphaSceneNode:getMaterial():setIsTranslucent(true)
				alphaSceneNode:getMaterial():setOutlineThreshold(-1.0)
				alphaSceneNode:getMaterial():setShader(shader)
				alphaSceneNode:getMaterial():send(Material.UNIFORM_FLOAT, "scape_WallHackAlpha", 1.0)
				alphaSceneNode:setParent(map)

				d.alphaSceneNode = alphaSceneNode
			else
				local shader
				if Class.isCompatibleType(texture, LayerTextureResource) then
					shader = self.resourceManager:load(
						ShaderResource,
						"Resources/Shaders/MultiTextureDecoration")
				else
					shader = self.resourceManager:load(
						ShaderResource,
						"Resources/Shaders/Decoration")
				end

				if sceneNode:getMaterial():getShader():getID() == DecorationSceneNode.DEFAULT_SHADER:getID() then
					sceneNode:getMaterial():setShader(shader)
				end
			end

			d.texture = texture
			d.staticMesh = staticMesh

			if callback then
				callback(d)
			end
		end)

		d.decoration = decoration
		d.name = group
		d.layer = layer
		d.sceneNode = sceneNode

		self.decorations[groupName] = d

		return sceneNode
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

	if water.reflectionDistance then
		node:getMaterial():setIsReflectiveOrRefractive(true)
		node:getMaterial():setReflectionDistance(water.reflectionDistance)
	end

	self.resourceManager:queue(
		TextureResource,
		string.format("Resources/Game/Water/%s/Texture.png", water.texture or "LightFoamyWater1"),
		function(resource)
			node:getMaterial():setTextures(resource)
			node:setParent(parent)
		end)

	node:getMaterial():setOutlineThreshold(-1.0)

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
	local p = {}
	local z = love.timer.getTime()
	for _, prop in pairs(self.props) do
		-- prop:update(delta)
		local n = prop:getDebugInfo().shortName
		local b = love.timer.getTime()
		self.propViewDebugStats:measure(prop, delta)
		local a = love.timer.getTime()
		p[n] = (p[n] or 0) + (a - b) * 1000
	end
	local z2 = love.timer.getTime()
	if love.keyboard.isDown("p") then
		local t = {}
		for k, v in pairs(p) do
			table.insert(t, { obj = k, time = v })
		end
		table.sort(t, function(a, b) return a.time < b.time end)
	print(">>> d", "z2 - z", (z2 - z) * 1000, Log.dump(t))
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

function GameView:_processMapQuery(m)
	if not m then
		return
	end

	local test = self.tests[m.id]
	if not test then
		return
	end

	self.tests[m.id] = nil
	local results = {}

	for i = 1, #m.tiles do
		local tile = m.tiles[i]

		local m = self.mapMeshes[tile.layer]
		if m then
			local result = {
				[Map.RAY_TEST_RESULT_TILE] = m.map:getTile(tile.i, tile.j),
				[Map.RAY_TEST_RESULT_I] = tile.i,
				[Map.RAY_TEST_RESULT_J] = tile.j,
				[Map.RAY_TEST_RESULT_POSITION] = Vector(unpack(tile.position)),
				layer = tile.layer
			}

			table.insert(results, result)
		end
	end

	test.callback(results)
end

function GameView:updateMapQueries(delta)
	local m
	repeat
		m = love.thread.getChannel('ItsyScape.Map::output'):pop()
		self:_processMapQuery(m)
	until m == nil
end

function GameView:updateMaps(delta)
	for _, m in pairs(self.mapMeshes) do
		self:_updateMapNodeWallHack(m)
	end
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
	_APP:measure("gameView:updateMaps()", GameView.updateMaps, self, delta)

	if self.game:getPlayer() then
		local actor = self:getActor(self.game:getPlayer():getActor())
		if actor then
			player = actor:getSceneNode()
			local transform = player:getTransform():getGlobalDeltaTransform(0, 0, 0)
			love.audio.setPosition(transform:transformPoint(0, 0, 0))
		end
	end
end

function GameView:_drawActorOnActorCanvas(delta, actor, m)
	local actorView = self:getActor(actor)
	if not actorView then
		return
	end

	local transform = actorView:getSceneNode():getTransform():getGlobalDeltaTransform(delta)
	local position = Vector(transform:transformPoint(0, 0, 0))

	local min, max = actor:getBounds()
	local size = max - min

	local radius = math.min(size.x, size.z) / 2
	local relativePosition = position / Vector(m.map:getWidth() * m.map:getCellSize(), 1.0, m.map:getHeight() * m.map:getCellSize())
	local relativeScale = (radius + 3) / m.map:getCellSize()
	relativeScale = relativeScale * (GameView.ACTOR_CANVAS_CELL_SIZE / self.actorCanvasCircle:getWidth())

	love.graphics.draw(self.actorCanvasCircle, relativePosition.x * m.actorCanvas:getWidth(), relativePosition.z * m.actorCanvas:getHeight(), 0, relativeScale, relativeScale, self.actorCanvasCircle:getWidth() / 2, self.actorCanvasCircle:getHeight() / 2)
end

function GameView:_updateActorCanvases(delta)
	love.graphics.push("all")
	for layer, m in pairs(self.mapMeshes) do
		love.graphics.setCanvas(m.actorCanvas)
		love.graphics.clear(0, 0, 0, 1)

		love.graphics.setShader()
		love.graphics.setBlendMode("alpha", "alphamultiply")

		for actor in self.game:getStage():iterateActors() do
			local _, _, actorLayer = actor:getTile()
			if actorLayer == layer then
				self:_drawActorOnActorCanvas(delta, actor, m)
			end
		end

		love.graphics.setCanvas(m.bumpCanvas)
		love.graphics.clear(0, 0, 0, 1)

		love.graphics.setShader(self.bumpCanvasShader)
		love.graphics.setBlendMode("replace", "premultiplied")
		love.graphics.draw(m.actorCanvas)
	end
	love.graphics.pop()
end

function GameView:drawSkyboxTo(delta, renderer, width, height)
	local skybox = next(self.skyboxes)
	if skybox then
		local info = self.skyboxes[skybox]

		renderer:setClearColor(Color(0, 0, 0, 0))
		renderer:draw(skybox, delta, width, height)

		return true
	end

	return false
end

function GameView:drawWorldTo(delta, renderer, width, height)
	renderer:setClearColor(Color(0, 0, 0, 0))
	renderer:draw(self.scene, delta, width, height)
end

function GameView:draw(delta, width, height)
	for _, actor in pairs(self.actors) do
		self.generalDebugStats:measure(
			string.format("actor::%s::draw", actor:getActor():getPeepID()),
			actor.draw,
			actor)
	end

	self:_updateActorCanvases(delta)
	self:_updatePlayerMapNode()
	
	local skybox = next(self.skyboxes)
	if skybox then
		local info = self.skyboxes[skybox]
		
		self.renderer:setClearColor(Color(0, 0, 0, 0))
		self.renderer:draw(skybox, delta, width, height, { self.sceneOutlinePostProcessPass })
		self.renderer:present(false)
	end

	self.renderer:setClearColor(Color(0, 0, 0, 0))
	--self.renderer:draw(self.scene, delta, width, height)
	self.renderer:draw(self.scene, delta, width, height, { self.ssrPostProcessPass, self.toneMapPostProcessPass, self.sceneOutlinePostProcessPass })
	self.renderer:present(true)
end

function GameView:preTick(frameDelta)
	self.generalDebugStats:measure("GameView::tickScene", self.scene.tick, self.scene, frameDelta)

	for projectile in pairs(self.projectiles) do
		self.generalDebugStats:measure(
			string.format("projectile::%s::tick", projectile:getID()),
			projectile.tick,
			projectile)
	end

	for skybox in pairs(self.skyboxes) do
		skybox:tick(frameDelta)
	end
end

function GameView:postTick()
	local gameManager = self.game:getGameManager()
	if gameManager then
		for _, instance in gameManager:iterateDirty() do
			local interface = instance:getInterface()
			local object = instance:getInstance()
			local objectView = self.views[object]
			if objectView then
				self.generalDebugStats:measure(
					string.format("%s::%s::tick", interface, object:getPeepID()),
					objectView.tick,
					objectView)
			end
		end
	else
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
	end
end

function GameView:quit()
	love.thread.getChannel('ItsyScape.Map::input'):push({
		type = 'quit'
	})

	self.mapThread:wait()

	if _DEBUG then
		love.filesystem.createDirectory("Performance")

		local result = { "name, mean, total, count" }
		local stats = self.resourceManager:getStats()
		for _, stat in ipairs(stats) do
			table.insert(result, string.format("%s,%f,%f,%d", stat.name, stat.mean, stat.total, stat.count))
		end

		local suffix = os.date("%Y-%m-%d %H%M%S")
		local filename = string.format("Performance/Resources %s.csv", suffix)
		love.filesystem.write(filename, table.concat(result, "\n"))
	end
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
				if map.mapMeshMasks then
					node:getMaterial():setTextures(map.largeTileSet:getDiffuseTexture(), map.mask:getTexture(), map.largeTileSet:getSpecularTexture(), map.largeTileSet:getOutlineTexture())
				else
					node:getMaterial():setTextures(map.largeTileSet:getDiffuseTexture(), self.defaultMapMaskTexture, map.largeTileSet:getSpecularTexture(), map.largeTileSet:getOutlineTexture())
				end
			end
		end
	end

	for _, actor in pairs(self.actors) do
		actor:dirty()
	end

	self:initRenderer(_CONF)
end

function GameView:dumpStatsToCSV()
	self.propViewDebugStats:dumpStatsToCSV("GameView_PropView_Update")
	self.generalDebugStats:dumpStatsToCSV("GameView_Tick")
end

return GameView
