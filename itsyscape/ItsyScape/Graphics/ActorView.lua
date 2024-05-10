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
local Class = require "ItsyScape.Common.Class"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Vector = require "ItsyScape.Common.Math.Vector"
local Equipment = require "ItsyScape.Game.Equipment"
local NullActor = require "ItsyScape.Game.Null.Actor"
local Animatable = require "ItsyScape.Game.Animation.Animatable"
local ModelSkin = require "ItsyScape.Game.Skin.ModelSkin"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Color = require "ItsyScape.Graphics.Color"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local Skeleton = require "ItsyScape.Graphics.Skeleton"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local PathTextureResource = require "ItsyScape.Graphics.PathTextureResource"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"

local ActorView = Class()
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

function ActorView:new(actor, actorID)
	self.actor = actor
	self.actorID = actorID
	self.animatable = ActorView.Animatable(self)

	self.sceneNode = SceneNode()

	self.layer = false

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
	self.models = {}
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

	self.onPreComputeBoneTransforms = Callback()
	self.onPostComputeBoneTransforms = Callback()
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

function ActorView:sortAnimations()
	self.sortedAnimations = {}
	do
		for slot, animation in pairs(self.animations) do
			if animation.instance then
				table.insert(self.sortedAnimations, { value = animation, key = slot })
			end
		end
		table.sort(self.sortedAnimations, function(a, b) return a.value.priority < b.value.priority end)
	end
end

function ActorView:playAnimation(slot, animation, priority, time)
	local a = self.animations[slot] or {}

	if priority and animation then
		local function loadAnimation(definition)
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

		if self:getIsImmediate() then
			loadAnimation(self.game:getResourceManager():loadCacheRef(animation))
		else
			self.game:getResourceManager():queueCacheRef(animation, loadAnimation)
		end

		self.animations[slot] = a
	else
		local function stopAnimation()
			local animation = self.animations[slot]
			if animation then
				self.animatable:removePlayingAnimation(animation.id)
			end

			self.animations[slot] = nil
			self:sortAnimations()
			self:updateAnimations(0)
		end

		if self:getIsImmediate() then
			stopAnimation()
		else
			self.game:getResourceManager():queueEvent(stopAnimation)
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
		slot.sceneNode:getMaterial():setTextures(TextureResource(slot.canvas))
	elseif slot.texture then
		slot.sceneNode:getMaterial():setTextures(slot.texture)
	else
		local translucentTexture = self.game:getTranslucentTexture()
		slot.sceneNode:getMaterial():setTextures(translucentTexture)
	end
end

function ActorView:_doApplySkin(slotNodes)
	local resourceManager = self.game:getResourceManager()

	for i = 1, #slotNodes do
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
				slot.sceneNode = ModelSceneNode()
				slot.body = self.body

				if slot.instance:getModel() then
					local model = resourceManager:loadCacheRef(slot.instance:getModel())
					model:getResource():bindSkeleton(self.body:getSkeleton())
					slot.sceneNode:setModel(model)

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
					slot.sceneNode:getMaterial():setShader(shaderResource)

					if coroutine.running() then
						coroutine.yield()
					end
				end

				if slot.instance:getIsTranslucent() then
					slot.sceneNode:getMaterial():setIsTranslucent(true)
					slot.sceneNode:getMaterial():setIsZWriteDisabled(true)
				end
				slot.sceneNode:getMaterial():setIsFullLit(slot.instance:getIsFullLit())

				local transform = slot.sceneNode:getTransform()
				transform:setLocalTranslation(slot.instance:getPosition())
				transform:setLocalScale(slot.instance:getScale())
				transform:setLocalRotation(slot.instance:getRotation())

				slot.sceneNode:setParent(self.sceneNode)
				slot.sceneNode:setTransforms(self.animatable:getTransforms())

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

				self.models[slot.sceneNode] = true
			end
		else
			if slot.sceneNode then
				self.models[slot.sceneNode] = nil
			end

			slot.instance = false
			slot.sceneNode = false
		end
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
end

function ActorView:applySkin(slotNodes)
	local copySlotNodes = {}
	for _, slotNode in ipairs(slotNodes) do
		table.insert(copySlotNodes, slotNode)
	end

	local resourceManager = self.game:getResourceManager()
	resourceManager:queueEvent(self._doApplySkin, self, copySlotNodes)
end

function ActorView:transmogrify(body)
	self.body = body:load()

	self.animatable:_newTransforms()
	self.localTransforms = self.body:getSkeleton():createTransforms()

	for _, slotNodes in pairs(self.skins) do
		if self:getIsImmediate() then
			self:_doApplySkin(slotNodes)
		else
			self:applySkin(slotNodes)
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

function ActorView:changeSkin(slot, priority, skin, config)
	if not skin then
		return
	end

	local slotNodes = self.skins[slot] or {}

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
		table.sort(slotNodes, function(a, b) return a.priority < b.priority end)
	end

	if self:getIsImmediate() then
		self:_doApplySkin(slotNodes)
	else
		self:applySkin(slotNodes)
	end
	self.skins[slot] = slotNodes

	if oldSkinSlotNode then
		local function unsetSkin()
			oldSkinSlotNode.sceneNode:setParent(nil)

			Log.engine(
				"Unset skin for '%s' (%d) @ slot '%s' (%s): '%s'.",
				self.actor:getName(), self.actor:getID(),
				Equipment.PLAYER_SLOT_NAMES[slot] or tostring(slot), tostring(slot),
				oldSkinSlotNode.definition:getFilename())
		end

		if self:getIsImmediate() then
			unsetSkin()
		else
			self.game:getResourceManager():queueEvent(unsetSkin)
		end
	end
end

function ActorView:move(position, layer, instant)
	self.sceneNode:getTransform():setLocalTranslation(position)

	if instant or layer ~= self.layer then
		self.sceneNode:getTransform():setPreviousTransform(position)
	end

	local parent = self.game:getMapSceneNode(layer)
	if parent ~= self.sceneNode:getParent() then
		self.sceneNode:setParent(parent)
	end

	self.layer = layer
end

function ActorView:face(direction, rotation)
	if rotation then
		self.sceneNode:getTransform():setLocalRotation(rotation)
	else
		-- Assumes models face right.
		if direction.x < -0.5 then
			self.sceneNode:getTransform():setLocalRotation(Quaternion.fromAxisAngle(Vector.UNIT_Y, -math.pi))
		elseif direction.x > 0.5 then
			self.sceneNode:getTransform():setLocalRotation(Quaternion.IDENTITY)
		end
	end
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
	for skin in pairs(self.skins) do
		for slot in ipairs(skin) do
			self:_updateSkinTexture(slot)
		end
	end
end

return ActorView
