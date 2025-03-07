--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ActorView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Function = require "ItsyScape.Common.Function"
local Class = require "ItsyScape.Common.Class"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Vector = require "ItsyScape.Common.Math.Vector"
local Body = require "ItsyScape.Game.Body"
local Equipment = require "ItsyScape.Game.Equipment"
local NullActor = require "ItsyScape.Game.Null.Actor"
local Animatable = require "ItsyScape.Game.Animation.Animatable"
local ModelSkin = require "ItsyScape.Game.Skin.ModelSkin"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Color = require "ItsyScape.Graphics.Color"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local Skeleton = require "ItsyScape.Graphics.Skeleton"
local SkeletonResource = require "ItsyScape.Graphics.SkeletonResource"
local LayerTextureResource = require "ItsyScape.Graphics.LayerTextureResource"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local Model = require "ItsyScape.Graphics.Model"
local ModelResource = require "ItsyScape.Graphics.ModelResource"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PathTextureResource = require "ItsyScape.Graphics.PathTextureResource"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local Atlas = require "ItsyScape.UI.Atlas"
local MapCurve = require "ItsyScape.World.MapCurve"

local ActorView = Class()

ActorView.DEFAULT_MULTI_SHADER = ShaderResource()
ActorView.DEFAULT_MULTI_SHADER:loadFromFile("Resources/Shaders/MultiSkinnedModel")

ActorView.Animatable = Class(Animatable)
function ActorView.Animatable:new(actor)
	self.actor = actor
	self.animations = { id = 1 }
	self.sceneNodes = {}
	self.sounds = {}
	self.pendingTransforms = {}
	self:_newTransforms()
end

function ActorView.Animatable:_newTransforms()
	self.transforms = self:getSkeleton():createTransforms()
end

function ActorView.Animatable:setColor(value)
	for _, slot in pairs(self.actor.skins) do
		for i = 1, #slot do
			if slot[i].sceneNode then
				slot[i].sceneNode:getMaterial():setColor(value)
			end
		end
	end
end

function ActorView.Animatable:playSound(filename, attenuation)
	local sound = self.sounds[filename]
	if not sound then
		sound = love.audio.newSource(filename, 'static')
		self.sounds[filename] = sound
		sound:setVolume((_CONF.soundEffectsVolume or 1) * (_CONF.volume or 1))

		if attenuation then
			sound:setAttenuationDistances(unpack(attenuation))
		end
	end

	return sound
end

function ActorView.Animatable:getSkeleton()
	if self.actor.body then
		return self.actor.body:getSkeleton()
	else
		return Skeleton.EMPTY
	end
end

function ActorView.Animatable:setSkin(slot, priority, skin)
	if slot == Equipment.PLAYER_SLOT_RIGHT_HAND then
		if self.actor.skins[Equipment.PLAYER_SLOT_TWO_HANDED] then
			slot = Equipment.PLAYER_SLOT_TWO_HANDED
		end
	end

	self.actor:changeSkin(slot, priority, skin)
end

function ActorView.Animatable:addSceneNode(SceneNodeType, ...)
	local sceneNode = SceneNodeType(...)
	sceneNode:setParent(self.actor.sceneNode)

	self.sceneNodes[sceneNode] = true

	return sceneNode
end

function ActorView.Animatable:removeSceneNode(sceneNode)
	if self.sceneNodes[sceneNode] then
		sceneNode:setParent(nil)
		self.sceneNodes[sceneNode] = nil
	end
end

function ActorView.Animatable:getResourceManager()
	return self.actor.game:getResourceManager()
end

function ActorView.Animatable:getTransforms()
	return self.transforms
end

function ActorView.Animatable:getPostComposedTransform(attach, func)
	table.insert(self.pendingTransforms, function()
		local transform = self.transforms:getTransform(self:getSkeleton():getBoneIndex(attach))
		func(transform)
	end)
end

function ActorView.Animatable:flushPendingComposedTransforms()
	for _, func in ipairs(self.pendingTransforms) do
		func()
	end
	table.clear(self.pendingTransforms)
end

function ActorView.Animatable:setTransforms(transforms, animation, time)
	for k, transform in pairs(transforms) do
		if type(k) == 'number' then
			self:setTransform(k, transform, animation, time)
		end
	end
end

function ActorView.Animatable:setTransform(index, transform)
	self.transforms:setTransform(index, transform)
end

function ActorView.Animatable:_nextAnimationID()
	local id = self.animations.id
	self.animations.id = self.animations.id + 1

	return id
end

function ActorView.Animatable:addPlayingAnimation(animation, time)
	local id = self:_nextAnimationID()

	table.insert(self.animations, {
		animation = animation,
		id = id,
		time = time or 0
	})

	return id
end

function ActorView.Animatable:removePlayingAnimation(id)
	for i = 1, #self.animations do
		local a = self.animations[i]
		if a.id == id then
			table.remove(self.animations, i)
			break
		end
	end
end

function ActorView.Animatable:updatePlayingAnimationTime(id, time)
	for i = 1, #self.animations do
		local a = self.animations[i]
		if a.id == id then
			a.time = time
			break
		end
	end
end

function ActorView.Animatable:getPlayingAnimations(animationName)
	local result = {}
	for i = 1, #self.animations do
		local a = self.animations[i].animation
		if not animationName or a:getAnimationDefinition():getName() == animationName then
			table.insert(result, a)
		end
	end

	return unpack(result)
end

function ActorView.Animatable:update()
	local transform = self.actor:getSceneNode():getTransform():getGlobalDeltaTransform(0)
	local x, y, z = transform:transformPoint(0, 0, 0)

	local pending
	for filename, sound in pairs(self.sounds) do
		sound:setPosition(x, y, z)

		if not sound:isPlaying() then
			pending = pending or {}
			pending[filename] = true
		end
	end

	if pending then
		for sound in pairs(pending) do
			self.sounds[sound] = nil
		end
	end
end

ActorView.CombinedModel = Class()
ActorView.CombinedModel.VERTEX_FORMAT = {
	{ 'VertexPosition', 'float', 3 },
	{ 'VertexNormal', 'float', 3 },
	{ 'VertexTexture', 'float', 2 },
	{ 'VertexBoneIndex', 'float', 4 },
	{ 'VertexBoneWeight', 'float', 4 },
	{ 'VertexDirection', 'float', 1 },
	{ 'VertexLayer', 'float', 1 },
}

function ActorView.CombinedModel:new(actorView, shader)
	self.actorView = actorView
	self.shader = shader

	local maxTextureSize = love.graphics.getSystemLimits().texturesize
	maxTextureSize = math.min(maxTextureSize, 2048)

	self.atlasSize = maxTextureSize

	self.isAtlasDirty = false
	self.baseAtlas = Atlas(self.atlasSize, self.atlasSize, 128, math.huge)
	self.perPassAtlases = {}
	self.boundTextureAtlases = {}

	self.baseModels = {}
	self.currentBaseModels = {}

	self.mappedVertices = {}
	self.mappedVertexCount = 0

	self.min = Vector(0):keep()
	self.max = Vector(0):keep()

	self.inputVertexFormat = {}
	self.outputVertexFormat = {}
	self:_buildVertexFormat(self.outputVertexFormat, self.VERTEX_FORMAT)

	self.sceneNode = ModelSceneNode()
	self.sceneNode:getMaterial():setShader(self.shader)

	self.isUpdating = 0
end

function ActorView.CombinedModel:getShader()
	return self.shader
end

function ActorView.CombinedModel:getSceneNode()
	return self.sceneNode
end

function ActorView.CombinedModel:add(baseModelSceneNode, baseTexture)
	self:remove(baseModelSceneNode)

	table.insert(self.baseModels, { sceneNode = baseModelSceneNode, texture = baseTexture })
end

function ActorView.CombinedModel:remove(baseModelSceneNode)
	for i = #self.baseModels, 1, -1 do
		if self.baseModels[i].sceneNode == baseModelSceneNode then
			self.baseAtlas:replace(self.baseModels[i].texture)
			table.remove(self.baseModels, i)
		end
	end
end

function ActorView.CombinedModel:getIsReady()
	return self.isUpdating == 0
end

function ActorView.CombinedModel:getIsEmpty()
	return #self.baseModels == 0
end

function ActorView.CombinedModel:dirty()
	self.isAtlasDirty = true
end

function ActorView.CombinedModel:_getIsModelDirty()
	if #self.baseModels ~= #self.currentBaseModels then
		return true
	end

	for index = 1, #self.currentBaseModels do
		if self.currentBaseModels[index] ~= self.baseModels[index].sceneNode then
			return true
		end
	end

	return false
end

function ActorView.CombinedModel:_getOffsetCount(format, name)
	local LOVE_VERTEX_FORMAT_COUNT_INDEX = 3
	local LOVE_VERTEX_FORMAT_NAME_INDEX = 1

	local offset = 0
	local count = 0
	for i = 1, #format do
		if format[i][LOVE_VERTEX_FORMAT_NAME_INDEX] == 'VertexBoneIndex' then
			count = self.format[i][LOVE_VERTEX_FORMAT_COUNT_INDEX]
			break
		end
		offset = offset + self.format[i][LOVE_VERTEX_FORMAT_COUNT_INDEX]
	end

	return offset, count
end

function ActorView.CombinedModel:_buildVertexFormat(result, format)
	local LOVE_VERTEX_FORMAT_COUNT_INDEX = 3
	local LOVE_VERTEX_FORMAT_NAME_INDEX = 1

	local offset = 1
	for i = 1, #format do
		local attribute = format[i]
		local attributeName = attribute[LOVE_VERTEX_FORMAT_NAME_INDEX]
		local attributeCount = attribute[LOVE_VERTEX_FORMAT_COUNT_INDEX]

		local r = result[attributeName] or {}
		r.offset = offset
		r.count = attributeCount

		result[attributeName] = r

		offset = offset + attributeCount
	end
end

function ActorView.CombinedModel:_appendModel(baseModel, baseTexture)
	local LOVE_VERTEX_FORMAT_NAME_INDEX = 1

	local vertices = baseModel:getVertices()
	self:_buildVertexFormat(self.inputVertexFormat, baseModel:getFormat())

	for _, attribute in ipairs(self.VERTEX_FORMAT) do
		local attributeName = attribute[LOVE_VERTEX_FORMAT_NAME_INDEX]

		local inputOffset, inputCount
		local outputOffset, outputCount
		do
			local inputAttribute = self.inputVertexFormat[attributeName]
			if inputAttribute then
				inputOffset = inputAttribute.offset
				inputCount = inputAttribute.count
			end

			local outputAttribute = self.outputVertexFormat[attributeName]
			if outputAttribute then
				outputOffset = outputAttribute.offset
				outputCount = outputAttribute.count
			end
		end

		if not (inputOffset and inputCount and outputOffset and outputCount) then
			if outputOffset and outputCount then
				for index, vertex in ipairs(vertices) do
					local outputVertexIndex = index + self.mappedVertexCount
					local outputVertex = self.mappedVertices[outputVertexIndex] or {}

					if attributeName == "VertexLayer" then
						local layer = self.baseAtlas:layer(baseTexture) or 1
						for i = 1, outputCount do
							outputVertex[outputOffset + i - 1] = layer - 1
						end
					else
						for i = 1, outputCount do
							outputVertex[outputOffset + i - 1] = 0
						end
					end

					self.mappedVertices[outputVertexIndex] = outputVertex
				end
			end
		else
			for index, inputVertex in ipairs(vertices) do
				local outputVertexIndex = index + self.mappedVertexCount
				local outputVertex = self.mappedVertices[outputVertexIndex] or {}

				for i = 1, inputCount do
					outputVertex[outputOffset + i - 1] = inputVertex[inputOffset + i - 1]
				end

				for i = inputCount + 1, outputCount do
					outputVertex[i] = 0
				end

				if attributeName == "VertexPosition" then
					local min = self.min or Vector(math.huge):keep()
					local max = self.max or Vector(-math.huge):keep()

					min.x = math.min(inputVertex[inputOffset] or min.x, min.x)
					min.y = math.min(inputVertex[inputOffset + 1] or min.y, min.y)
					min.z = math.min(inputVertex[inputOffset + 2] or min.z, min.z)
					max.x = math.max(inputVertex[inputOffset] or max.x, max.x)
					max.y = math.max(inputVertex[inputOffset + 1] or max.y, max.y)
					max.z = math.max(inputVertex[inputOffset + 2] or max.z, max.z)

					self.min = min
					self.max = max
				elseif attributeName == "VertexTexture" then
					local left, right, top, bottom = self.baseAtlas:coordinates(baseTexture)
					local width = right - left
					local height = bottom - top

					local s = outputVertex[outputOffset] * width + left
					local t = 1 - ((1 - outputVertex[outputOffset + 1]) * height + top)

					outputVertex[outputOffset] = s
					outputVertex[outputOffset + 1] = t
				end

				self.mappedVertices[outputVertexIndex] = outputVertex
			end
		end
	end

	self.mappedVertexCount = self.mappedVertexCount + #vertices
end

function ActorView.CombinedModel:_updateModel()
	table.clear(self.currentBaseModels)

	self.mappedVertexCount = 0
	self.min = nil
	self.max = nil

	local totalTime = 0
	for _, baseModel in ipairs(self.baseModels) do
		table.insert(self.currentBaseModels, baseModel.sceneNode)

		local model = baseModel.sceneNode:getModel():getResource()
		local texture = baseModel.texture

		self:_appendModel(model, texture)

		if coroutine.running() then
			coroutine.yield()
		end
	end

	if self.mappedVertexCount >= 1 then
		self.combinedModel = Model.fromMappedVertices(
			self.VERTEX_FORMAT,
			self.mappedVertices,
			self.mappedVertexCount,
			self.min,
			self.max,
			self.actorView:getSkeleton())
		self.combinedModelResource = ModelResource(self.combinedModel)

		self.sceneNode:setModel(self.combinedModelResource)
	end

	if coroutine.running() then
		coroutine.yield()
	end

	self.isUpdating = self.isUpdating - 1
end

function ActorView.CombinedModel:_updateAtlas()
	local rebuildOtherAtlases = false

	for _, baseModel in ipairs(self.baseModels) do
		local handle = baseModel.texture
		local texture = baseModel.sceneNode:getMaterial():getTexture(1)
		local key = texture:getID()

		if not self.baseAtlas:has(handle) then
			self.baseAtlas:add(handle, texture:getResource(), key)
			rebuildOtherAtlases = true
		elseif self.baseAtlas:reset(handle, key) then
			self.baseAtlas:replace(handle, texture:getResource(), key)
		end
	end

	self.baseAtlas:update()

	if rebuildOtherAtlases then
		self.texture = LayerTextureResource(self.baseAtlas:getTexture())
	end
end

function ActorView.CombinedModel:update()
	self:_updateAtlas()

	if self:_getIsModelDirty() then
		self.isUpdating = self.isUpdating + 1
		self.actorView:getGameView():getResourceManager():queueEvent(self._updateModel, self)
	end

	if self.texture then
		self.sceneNode:getMaterial():setTextures(self.texture)
	end
end

function ActorView:new(actor, actorID)
	self.actor = actor
	self.actorID = actorID
	self.animatable = ActorView.Animatable(self)

	self.sceneNode = SceneNode()

	self.combinedModelSceneNodes = {}

	self.layer = false
	self.position = false
	self.rotation = Quaternion():keep()

	self.animations = {}
	self._onAnimationPlayed = function(_, slot, priority, animation, _, time)
		self:playAnimation(slot, animation, priority, time or 0)
	end
	actor.onAnimationPlayed:register(self._onAnimationPlayed)
	self._onAnimationStopped = function(_, slot, priority, animation, _, time)
		self:playAnimation(slot, false, false, time or 0)
	end
	actor.onAnimationStopped:register(self._onAnimationStopped)

	self.skins = {}
	self.currentApplySkin = 0

	self._onSkinChanged = function(_, slot, priority, skin, config)
		Log.engine(
			"Skin slot '%s' (priority = %d) changed to '%s' for '%s' (%d).",
			slot, priority, skin and skin:getFilename(), self.actor:getName(), self.actor:getID() or -1)
		self:changeSkin(slot, priority, skin, config)
	end
	actor.onSkinChanged:register(self._onSkinChanged)
	self._onSkinRemoved = function(_, slot, priority, skin)
		Log.engine(
			"Skin slot '%s' unset '%s' for '%s' (%d).",
			slot, skin and skin:getFilename(), self.actor:getName(), self.actor:getID() or -1)
		self:changeSkin(slot, false, skin)
	end
	actor.onSkinRemoved:register(self._onSkinRemoved)

	self.body = false
	self._onTransmogrified = function(_, body)
		Log.engine(
			"Transmogrified to '%s' for '%s' (%d).",
			body and body:getFilename(), self.actor:getName(), self.actor:getID() or -1)
		self:transmogrify(body)
	end
	actor.onTransmogrified:register(self._onTransmogrified)

	self._onTeleport = function(_, position, layer)
		self:move(position, layer, true)
	end
	actor.onTeleport:register(self._onTeleport)

	self._onMove = function(_, position, layer)
		self:move(position, layer, false)
	end
	actor.onMove:register(self._onMove)

	self._onDirectionChanged = function(_, direction, rotation)
		self:face(direction, rotation)
	end
	actor.onDirectionChanged:register(self._onDirectionChanged)

	self._onDamage = function(_, damageType, damage)
		self:damage(damageType, damage)
	end
	actor.onDamage:register(self._onDamage)

	self._onHUDMessage = function(_, message, ...)
		self:flash(message, ...)
	end
	actor.onHUDMessage:register(self._onHUDMessage)

	self.healthBar = false
	self.sprites = setmetatable({}, { __mode = 'k' })

	self.onPreComputeBoneTransforms = Callback(false)
	self.onPostComputeBoneTransforms = Callback(false)
end

function ActorView:getActor()
	return self.actor
end

function ActorView:getIsImmediate()
	return Class.isCompatibleType(self.actor, NullActor)
end

function ActorView:attach(game)
	self.game = game
end

function ActorView:getGameView()
	return self.game
end

function ActorView:release()
	self.sceneNode:setParent(nil)

	self.actor.onDirectionChanged:unregister(self._onDirectionChanged)
	self.actor.onMove:unregister(self._onMove)
	self.actor.onTeleport:unregister(self._onTeleport)
	self.actor.onAnimationPlayed:unregister(self._onAnimationPlayed)
	self.actor.onAnimationStopped:unregister(self._onAnimationStopped)
	self.actor.onTransmogrified:unregister(self._onTransmogrified)
	self.actor.onSkinChanged:unregister(self._onSkinChanged)
	self.actor.onSkinRemoved:unregister(self._onSkinRemoved)
	self.actor.onDamage:unregister(self._onDamage)
	self.actor.onHUDMessage:unregister(self._onHUDMessage)

	for sprite in pairs(self.sprites) do
		self.game:getSpriteManager():poof(sprite)
	end

	if self.healthBar and self.healthBar:getIsSpawned() then
		self.game:getSpriteManager():poof(self.healthBar)
	end
end

function ActorView:getSceneNode()
	return self.sceneNode
end

function ActorView:getLayer()
	return self.layer
end

local function _sortAnimation(a, b)
	return a.value.priority < b.value.priority
end

function ActorView:sortAnimations()
	self.sortedAnimations = {}
	do
		for slot, animation in pairs(self.animations) do
			if animation.instance then
				table.insert(self.sortedAnimations, { value = animation, key = slot })
			end
		end
		table.sort(self.sortedAnimations, _sortAnimation)
	end
end

function ActorView:_loadAnimation(a, definition, slot, animation, priority, time)
	if (a.definition and a.definition:getFadesOut()) or
	   (a.instance and definition:getResource():getFadesIn())
	then
		a.next = {
			cacheRef = animation,
			definition = definition:getResource(),
			priority = priority,
			time = time
		}
	else
		local oldID = a.id
		if a.instance then
			a.instance:stop()
		end

		a.cacheRef = animation
		a.definition = definition:getResource()
		a.instance = a.definition:play(self.animatable)
		a.time = time or 0
		a.priority = priority or -math.huge
		a.id = self.animatable:addPlayingAnimation(a.instance, a.time)

		self.animatable:removePlayingAnimation(oldID)
	end

	self.animations[slot] = a
	self:sortAnimations()
	self:updateAnimations(0)
end

function ActorView:_stopAnimation(slot)
	local animation = self.animations[slot]
	if animation then
		self.animatable:removePlayingAnimation(animation.id)
	end

	self.animations[slot] = nil
	self:sortAnimations()
	self:updateAnimations(0)
end

function ActorView:playAnimation(slot, animation, priority, time)
	local a = self.animations[slot] or {}

	if priority and animation then
		if self:getIsImmediate() then
			self:_loadAnimation(a, self.game:getResourceManager():loadCacheRef(animation), slot, animation, priority, time)
		else
			self.game:getResourceManager():queueAsyncEvent(self._loadAnimation, self, a, self.game:getResourceManager():loadCacheRef(animation), slot, animation, priority, time)
		end

		self.animations[slot] = a
	else
		if self:getIsImmediate() then
			self:_stopAnimation(slot, animation)
		else
			self.game:getResourceManager():queueAsyncEvent(self._stopAnimation, self, slot)
		end
	end
end

function ActorView:_updateSkinTexture(slot)
	if Class.isCompatibleType(slot.texture, PathTextureResource) then
		local colors = {}
		for index, color in ipairs(slot.config or {}) do
			colors[index] = Color(unpack(color))
		end

		slot.canvas = slot.texture:getResource():draw(slot.canvas, slot.instance:mapPathsToColors(colors))

		local resource = TextureResource(slot.canvas)
		slot.texture:copyPerPassTextures(resource)

		slot.model:getMaterial():setTextures(resource)
	elseif slot.texture then
		slot.model:getMaterial():setTextures(slot.texture)
	elseif slot.sceneNode then
		local translucentTexture = self.game:getTranslucentTexture()
		slot.model:getMaterial():setTextures(translucentTexture)
	end
end

function ActorView:_doApplySkin(slotNodes, slot, generation)
	local resourceManager = self.game:getResourceManager()

	for i = 1, #slotNodes do
		if self.skins[slot] and self.skins[slot].generation ~= generation then
			if coroutine.running() then
				self.currentApplySkin = self.currentApplySkin - 1
			end

			return
		end

		local slot = slotNodes[i]
		local skin = slot.definition

		if slot.sceneNode then
			slot.sceneNode:setParent(nil)
		end

		if slot.instance and self.body == slot.body then
			slot.sceneNode:setParent(self.sceneNode)
			self:_updateSkinTexture(slot)
		elseif self.body then
			if Class.isDerived(skin:getResourceType(), ModelSkin) then
				local instance = resourceManager:loadCacheRef(skin)

				slot.instance = instance
				slot.sceneNode = SceneNode()
				slot.model = ModelSceneNode()
				slot.body = self.body

				if slot.instance:getModel() then
					local model = resourceManager:loadCacheRef(slot.instance:getModel(), self.body:getSkeleton())
					slot.model:setModel(model)

					if coroutine.running() then
						coroutine.yield()
					end
				end

				local textureCacheRef = slot.instance:getTexture()
				if textureCacheRef then
					slot.texture = resourceManager:loadCacheRef(textureCacheRef)
					self:_updateSkinTexture(slot)

					if coroutine.running() then
						coroutine.yield()
					end
				end

				local shaderCacheRef = slot.instance:getShader()
				if shaderCacheRef then
					local shaderResource = resourceManager:loadCacheRef(shaderCacheRef)
					slot.shader = shaderResource
					slot.model:getMaterial():setShader(shaderResource)

					if coroutine.running() then
						coroutine.yield()
					end

					local multiShaderCacheRef = slot.instance:getMultiShader()
					if multiShaderCacheRef then
						local multiShaderResource = resourceManager:loadCacheRef(multiShaderCacheRef)
						slot.multiShader = multiShaderResource

						if coroutine.running() then
							coroutine.yield()
						end
					end
				end

				if slot.instance:getIsTranslucent() then
					slot.model:getMaterial():setIsTranslucent(true)
					slot.model:getMaterial():setIsZWriteDisabled(true)
				end
				slot.model:getMaterial():setIsFullLit(slot.instance:getIsFullLit())
				slot.model:getMaterial():setOutlineThreshold(slot.instance:getOutlineThreshold())

				if slot.instance:getIsReflective() then
					slot.model:getMaterial():setIsReflectiveOrRefractive(true)
					slot.model:getMaterial():setReflectionPower(slot.instance:getReflectionPower())
				end

				local transform = slot.model:getTransform()
				transform:setLocalTranslation(slot.instance:getPosition())
				transform:setLocalScale(slot.instance:getScale())
				transform:setLocalRotation(slot.instance:getRotation())

				slot.sceneNode:setParent(self.sceneNode)
				slot.model:setTransforms(self.animatable:getTransforms())

				if self:getIsImmediate() then
					slot.model:setParent(slot.sceneNode)
				end

				local lights = slot.instance:getLights()
				if #lights > 0 then
					slot.lights = {}

					for i = 1, #lights do
						local inputLight = lights[i].light
						local outputLight

						if inputLight:isPoint() then
							outputLight = PointLightSceneNode()
						elseif inputLight:getAmbience() > 0 then
							outputLight = AmbientLightSceneNode()
						end

						-- Only the client's player's lights should be global.
						if self.game:getGame():getPlayer() and self.actor == self.game:getGame():getPlayer():getActor() then
							outputLight:setIsGlobal(true)
						end
						
						if outputLight then
							outputLight:fromLight(inputLight)
							outputLight:setParent(slot.sceneNode)
							table.insert(slot.lights, {
								sceneNode = outputLight,
								info = lights[i].info
							})
						end
					end
				end

				local particles = slot.instance:getParticles()
				if #particles > 0 then
					slot.particles = {}

					for i = 1, #particles do
						local p = ParticleSceneNode()
						p:initParticleSystemFromDef(particles[i].system, self.game:getResourceManager())
						p:setParent(slot.sceneNode)

						table.insert(slot.particles, {
							sceneNode = p,
							attach = particles[i].attach
						})
					end
				end

				local material = slot.model:getMaterial()
				material:send(material.UNIFORM_FLOAT, "scape_BumpHeight", slot.instance:getBumpHeight())

				if coroutine.running() then
					coroutine.yield()
				end
			end
		else
			slot.instance = false
			slot.sceneNode = false
		end
	end

	if self.skins[slot] and self.skins[slot].generation ~= generation then
		return
	end

	for i = 1, #slotNodes do
		local slotNode = slotNodes[i]

		if i + 1 < #slotNodes and slotNode.instance:getIsOccluded() then
			if not slotNodes[i + 1].instance:getIsGhosty() then
				slotNode.sceneNode:setParent(nil)
			end
		end

		if slotNode.instance:getIsOccluding() then
			for j = i + 1, #slotNodes do
				if not slotNodes[j].instance:getIsGhosty() then
					slotNodes[j].sceneNode:setParent(nil)
				end
			end
		end

		if slotNode.instance:getIsBlocking() then
			for j = 1, i - 1 do
				slotNodes[j].sceneNode:setParent(nil)
			end
		end
	end

	if coroutine.running() then
		self.currentApplySkin = self.currentApplySkin - 1
	end
end

function ActorView:applySkin(slot, slotNodes)
	local copySlotNodes = {}
	for _, slotNode in ipairs(slotNodes) do
		table.insert(copySlotNodes, slotNode)
	end

	self.currentApplySkin = self.currentApplySkin + 1

	local resourceManager = self.game:getResourceManager()
	resourceManager:queueAsyncEvent(self._doApplySkin, self, copySlotNodes, slot, slotNodes.generation)
end

function ActorView:transmogrify(body)
	local skeletonResource = self.game:getResourceManager():load(SkeletonResource, body:getFilename())
	self.body = Body(skeletonResource:getResource())

	self.animatable:_newTransforms()
	self.localTransforms = self.body:getSkeleton():createTransforms()

	for slot, slotNodes in pairs(self.skins) do
		if self:getIsImmediate() then
			self:_doApplySkin(slotNodes, slot, slotNodes.generation)
		else
			self:applySkin(slot, slotNodes)
		end
	end
end

function ActorView:getSkeleton()
	return self.body and self.body:getSkeleton()
end

function ActorView:getSkins(slot)
	if not slot then
		return self.skins
	end

	return self.skins[slot]
end

local function _sortSlotNodes(a, b)
	return a.priority < b.priority
end

function ActorView:changeSkin(slot, priority, skin, config)
	if not skin then
		return
	end

	local slotNodes = self.skins[slot] or { generation = 0 }

	local oldSkinSlotNode
	for i = 1, #slotNodes do
		local s = slotNodes[i]
		if s.priority == priority or s.definition == skin then
			table.remove(slotNodes, i)
			oldSkinSlotNode = s

			break
		end
	end

	if priority then
		local s = {
			definition = skin,
			priority = priority,
			config = config or {}
		}

		table.insert(slotNodes, s)
		table.sort(slotNodes, _sortSlotNodes)
	end

	slotNodes.generation = slotNodes.generation + 1
	if self.body then
		if self:getIsImmediate() then
			self:_doApplySkin(slotNodes, slot, slotNodes.generation)
		else
			self:applySkin(slot, slotNodes, slotNodes.generation)
		end
	end

	if oldSkinSlotNode and oldSkinSlotNode.sceneNode then
		oldSkinSlotNode.sceneNode:setParent(nil)
	end

	self.skins[slot] = slotNodes
end

function ActorView:_getPosition(position, layer)
	position = position or self.position or Vector.ZERO
	layer = layer or self.layer or 1

	local curves = self.game:getMapCurves(layer)
	if curves then
		return MapCurve.transformAll(position, curves)
	end

	return position
end

function ActorView:_getRotation(rotation, layer)
	rotation = (rotation or self.rotation or Quaternion()):keep()
	layer = layer or self.layer or 1

	local position = self.position or Vector.ZERO
	local curves = self.game:getMapCurves(layer)
	if curves then
		local _, r = MapCurve.transformAll(position, rotation, curves)
		return r
	end

	return rotation
end

function ActorView:move(position, layer, instant)
	local previousLayer = self.layer
	local previousPosition = self.position

	self.position = position
	self.layer = layer

	if instant then
		local currentPosition = self:_getPosition(position, layer)
		self.sceneNode:getTransform():setPreviousTransform(currentPosition)
	end

	local parent = self.game:getMapSceneNode(layer)
	if parent ~= self.sceneNode:getParent() then
		self.sceneNode:setParent(parent)
	end
end

function ActorView:face(direction, rotation)
	if not rotation then
		if math.sign(direction.x) < 0 then
			rotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, -math.pi)
		else
			rotation = Quaternion.IDENTITY
		end
	end

	self.rotation = rotation:keep()
end

function ActorView:damage(damageType, damage)
	local spriteManager = self.game:getSpriteManager()
	local sprite = spriteManager:add("Damage", self.sceneNode, Vector(0, 1, 0), damageType, damage)

	self.sprites[sprite] = true

	if self.healthBar and self.healthBar:getIsSpawned() then
		self.game:getSpriteManager():reset(self.healthBar)
	else
		self.healthBar = self.game:getSpriteManager():add(
			"HealthBar",
			self.sceneNode,
			Vector(0, 2, 0),
			self.actor)
	end
end

function ActorView:flash(message, anchor, ...)
	local spriteManager = self.game:getSpriteManager()

	if type(anchor) == 'number' then
		anchor = Vector(0, anchor, 0)
	end

	local min, max = self.actor:getBounds()
	min = min or Vector.ZERO
	max = max or Vector.ZERO

	local size = max - min

	local sprite = spriteManager:add(message, self.sceneNode, size * anchor, ...)
	self.sprites[sprite] = true
end

function ActorView:tick()
	self.sceneNode:getTransform():setLocalScale(self.actor:getScale())
end

function ActorView:update(delta)
	self:updateAnimations(delta)
	self.animatable:update()

	if self.layer then
		if self.position then
			self.sceneNode:getTransform():setLocalTranslation(self:_getPosition(self.position, self.layer))
		end

		if self.rotation then
			self.sceneNode:getTransform():setLocalRotation(self:_getRotation(self.rotation, self.layer))
		end
	end
end

function ActorView:draw()
	if self.currentApplySkin ~= 0 then
		return
	end

	for _, slotNodes in pairs(self.skins) do
		for _, slot in ipairs(slotNodes) do
			local modelSceneNode = slot.model
			if modelSceneNode then
				local material = modelSceneNode:getMaterial()

				local hasMultiShader = (not slot.shader and not slot.multiShader) or (slot.shader and slot.multiShader)
				local isForward = material:getIsFullLit() or material:getIsTranslucent()
				local isTextureCompatible = material:getNumTextures() ~= 1 or (material:getNumTextures() == 1 and material:getTexture(1):isCompatibleType(TextureResource))
				local isImmediate = self:getIsImmediate()

				if not _CONF.featureFlagEnableCombinedActorModel or not hasMultiShader or isForward or isMultiTexture or isImmediate then
					modelSceneNode:setParent(slot.sceneNode)
				else
					local texture = material:getTexture(1)
					local multiShader = material.multiShader or ActorView.DEFAULT_MULTI_SHADER

					modelSceneNode:setParent(nil)

					local combinedModel
					for _, c in ipairs(self.combinedModelSceneNodes) do
						if c:getShader():getID() == multiShader:getID() then
							combinedModel = c
							break
						end
					end

					if not combinedModel or slot.combinedModel ~= combinedModel and slot.sceneNode:getParent() then
						if slot.combinedModel then
							slot.combinedModel:remove(modelSceneNode)
							slot.combinedModel = nil
						end

						if not combinedModel then
							combinedModel = ActorView.CombinedModel(self, multiShader)
							table.insert(self.combinedModelSceneNodes, combinedModel)
						end

						slot.combinedModel = combinedModel
						combinedModel:add(modelSceneNode, slot.texture)
					end

					if combinedModel and not slot.sceneNode:getParent() then
						combinedModel:remove(modelSceneNode)
					end
				end
			end
		end
	end

	for i = #self.combinedModelSceneNodes, 1, -1 do
		local combinedModel = self.combinedModelSceneNodes[i]
		local sceneNode = combinedModel:getSceneNode()

		if combinedModel:getIsEmpty() then
			sceneNode:setParent(nil)
			table.remove(self.combinedModelSceneNodes, i)
		else
			combinedModel:update(delta)

			if not sceneNode:getParent() and combinedModel:getIsReady() then
				sceneNode:setParent(self.sceneNode)
				sceneNode:setTransforms(self.animatable:getTransforms())
			end
		end
	end
end

function ActorView:getBoneTransform(boneName)
	local transform = love.math.newTransform()
	if not self.localTransforms then
		return transform
	end

	local transforms = self.localTransforms
	local skeleton = self.animatable:getSkeleton()

	transform:apply(transforms:getTransform(skeleton:getBoneIndex(boneName)))
	return transform, MathCommon.decomposeTransform(transform)
end

function ActorView:getLocalBoneTransform(boneName, rotation)
	rotation = rotation or -Quaternion.X_90

	local transform = love.math.newTransform()
	transform:applyQuaternion(rotation:get())

	if not self.localTransforms then
		return transform
	end

	local transforms = self.localTransforms
	local skeleton = self.animatable:getSkeleton()

	return skeleton:getLocalBoneTransform(boneName, transforms, transform)
end

function ActorView:getLocalBonePosition(boneName, position, rotation)
	position = position or Vector.ZERO
	rotation = rotation or Quaternion.IDENTITY

	local boneTransform = self:getLocalBoneTransform(boneName)
	local bone = self:getSkeleton():getBoneByName(boneName)
	if not bone then
		return Vector.ZERO
	end

	local composedTransform = love.math.newTransform()
	composedTransform:applyQuaternion(rotation:get())
	composedTransform:apply(boneTransform)

	return Vector(composedTransform:transformPoint(position:get()))
end

function ActorView:decomposeBoneLocalTransform(boneName)
	local boneTransform = self:getLocalBoneTransform(boneName)
	return MathCommon.decomposeTransform(boneTransform)
end

function ActorView:getBoneWorldPosition(boneName, position, rotation)
	position = position or Vector.ZERO
	rotation = rotation or Quaternion.IDENTITY

	local nodeTransform = self.sceneNode:getTransform():getGlobalTransform()
	local boneTransform = self:getLocalBoneTransform(boneName)
	local bone = self:getSkeleton():getBoneByName(boneName)
	if not bone then
		return Vector.ZERO
	end

	local inverseBindPoseTransform = bone:getInverseBindPose()

	local composedTransform = love.math.newTransform()
	composedTransform:apply(nodeTransform)
	composedTransform:applyQuaternion(rotation:get())
	composedTransform:apply(boneTransform)
	composedTransform:applyQuaternion((-Quaternion.X_90):getNormal():get())

	return Vector(composedTransform:transformPoint(position:get()))
end

function ActorView:nextAnimation(animation)
	local oldID = animation.id

	animation.cacheRef = animation.next.cacheRef
	animation.definition = animation.next.definition
	animation.instance = animation.definition:play(self.animatable)
	animation.time = animation.next.time or 0
	animation.priority = animation.next.priority or -math.huge
	animation.next = nil
	animation.id = self.animatable:addPlayingAnimation(animation.instance, animation.time)

	self.animatable:removePlayingAnimation(oldID)

	animation.done = animation.instance:play(animation.time)
end

function ActorView:updateAnimations(delta)
	local transforms = self.animatable:getTransforms()
	transforms:reset()

	local animations = self.sortedAnimations or {}
	for index, a in ipairs(animations) do
		local animation = a.value
		local slot = a.key

		animation.time = animation.time + delta
		if animation.done then
			if animation.next then
				self:nextAnimation(animation)
			else
				self.animatable:removePlayingAnimation(animation.id)
				self.animations[slot] = nil
				self.actor:onAnimationPlayed(slot, false)
			end
		else
			animation.done = animation.instance:play(animation.time, animation.next ~= nil)
			if animation.done and animation.next then
				self:nextAnimation(animation)
			end
		end
	end

	self:onPreComputeBoneTransforms(transforms, self.animatable)
	if self.localTransforms then
		transforms:copy(self.localTransforms)
	end

	for _, slotNodes in pairs(self.skins) do
		for i = 1, #slotNodes do
			if slotNodes[i].particles then
				for j = 1, #slotNodes[i].particles do
					local p = slotNodes[i].particles[j]
					if p.attach then
						local localPosition = self:getLocalBonePosition(p.attach)
						p.sceneNode:updateLocalPosition(localPosition)
					end
				end
			end

			if slotNodes[i].lights then
				for j = 1, #slotNodes[i].lights do
					local l = slotNodes[i].lights[j]
					if l.info.attach then
						local localPosition = self:getLocalBonePosition(l.info.attach, Vector(unpack(l.info.position or {})))
						l.sceneNode:getTransform():setLocalTranslation(localPosition)
					end
				end
			end
		end
	end

	local skeleton = self.animatable:getSkeleton()
	do
		skeleton:applyTransforms(transforms)
		self.animatable:flushPendingComposedTransforms()

		skeleton:applyBindPose(transforms)
	end
	self:onPostComputeBoneTransforms(transforms, self.animatable)
end

function ActorView:dirty()
	for _, skin in pairs(self.skins) do
		for _, slot in ipairs(skin) do
			self:_updateSkinTexture(slot)
		end
	end

	for _, model in ipairs(self.combinedModelSceneNodes) do
		model:dirty()
	end
end

return ActorView
