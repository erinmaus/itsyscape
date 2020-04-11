--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ActorView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Equipment = require "ItsyScape.Game.Equipment"
local Animatable = require "ItsyScape.Game.Animation.Animatable"
local ModelSkin = require "ItsyScape.Game.Skin.ModelSkin"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local Skeleton = require "ItsyScape.Graphics.Skeleton"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"

local ActorView = Class()
ActorView.Animatable = Class(Animatable)
function ActorView.Animatable:new(actor)
	self.actor = actor
	self.transforms = {}
	self.animations = {}
	self.sceneNodes = {}
	self.sounds = {}
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

function ActorView.Animatable:playSound(filename)
	local sound = self.sounds[filename]
	if not sound then
		sound = love.audio.newSource(filename, 'static')
		self.sounds[filename] = sound
	end

	sound:seek(0)
	sound:play()
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

function ActorView.Animatable:getTransforms()
	local skeleton = self:getSkeleton()
	local numBones = skeleton:getNumBones()
	if #self.transforms ~= numBones then
		for i = 1, numBones do
			if not self.transforms[i] then
				self.transforms[i] = love.math.newTransform()
			end
		end
	end

	return self.transforms
end

function ActorView.Animatable:setTransforms(transforms, animation, time)
	for k, transform in pairs(transforms) do
		if type(k) == 'number' then
			self:setTransform(k, transform, animation, time)
		end
	end
end

function ActorView.Animatable:getAnimationForBone(index)
	local a = self.animations[index]
	if not a then
		return nil, nil
	else
		return unpack(self.animations[index])
	end
end

function ActorView.Animatable:setTransform(index, transform, animation, time)
	for i = 1, index do
		if self.transforms[index] == nil then
			self.transforms[index] = love.math.newTransform()
		end
	end

	self.transforms[index]:reset()
	self.transforms[index]:apply(transform)
	self.animations[index] = { animation, time }
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
	self._onAnimationPlayed = function(_, slot, priority, animation)
		self:playAnimation(slot, animation, priority, 0)
	end
	actor.onAnimationPlayed:register(self._onAnimationPlayed)

	self.skins = {}
	self.models = {}
	self._onSkinChanged = function(_, slot, priority, skin)
		self:changeSkin(slot, priority, skin)
	end
	actor.onSkinChanged:register(self._onSkinChanged)

	self.body = false
	self._onTransmogrified = function(_, body)
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
end

function ActorView:attach(game)
	self.game = game
end

function ActorView:poof()
	self.sceneNode:setParent(nil)

	self.actor.onDirectionChanged:unregister(self._onDirectionChanged)
	self.actor.onMove:unregister(self._onMove)
	self.actor.onTeleport:unregister(self._onTeleport)
	self.actor.onAnimationPlayed:unregister(self._onAnimationPlayed)
	self.actor.onTransmogrified:unregister(self._onTransmogrified)
	self.actor.onSkinChanged:unregister(self._onSkinChanged)
	self.actor.onDamage:unregister(self._onDamage)
	self.actor.onHUDMessage:unregister(self._onHUDMessage)

	for sprite in pairs(self.sprites) do
		self.game:getSpriteManager():poof(sprite)
	end
end

function ActorView:getSceneNode()
	return self.sceneNode
end

function ActorView:getLayer()
	return self.layer
end

function ActorView:playAnimation(slot, animation, priority, time)
	-- TODO blending
	local a = self.animations[slot] or {}

	-- TODO load queue
	if priority and animation then
		self.game:getResourceManager():queueCacheRef(animation, function(definition)
			if (a.definition and a.definition:getFadesOut()) or
			   (a.instance and definition:getResource():getFadesIn())
			then
				Log.info("Queueing animation.")
				a.next = {
					definition = definition:getResource(),
					priority = priority,
					time = time
				}
			else
				if a.instance then
					a.instance:stop()
				end

				a.definition = definition:getResource()
				a.instance = a.definition:play(self.animatable)
				a.time = time or 0
				a.priority = priority or -math.huge
			end

			if self.animations[slot] then
				self.animations[slot] = a
			end
		end)

		self.animations[slot] = a
	else
		self.animations[slot] = nil
	end
end

function ActorView:applySkin(slotNodes)
	slotNodes.index = (slotNodes.index or 0) + 1
	local index = slotNodes.index

	local i = #slotNodes
	local iterate
	local function step()
		-- This ensures we give up if another skin has been applied.
		-- Only the latest will take affect.
		if slotNodes.index ~= index then
			return
		end

		if i > 1 then
			self.game:getResourceManager():queueEvent(iterate)
			i = i - 1
		else
			for i = 1, #slotNodes do
				local slotNode = slotNodes[i]
				if i + 1 < #slotNodes and slotNode.instance:getIsOccluded() then
					if not slotNodes[i + 1].instance:getIsGhosty() then
						slotNode.sceneNode:setParent(nil)
					end
				elseif slotNode.instance:getIsBlocking() then
					for j = 1, i - 1 do
						slotNodes[j].sceneNode:setParent(nil)
					end
				end
			end
		end
	end

	iterate = function()
		local slot = slotNodes[i]
		if not slot then
			step()
			return
		end

		local skin = slot.definition
		if slot.sceneNode then
			slot.sceneNode:setParent(false)
		end

		if self.body then
			if Class.isDerived(skin:getResourceType(), ModelSkin) then
				self.game:getResourceManager():queueCacheRef(skin, function(instance)
					slot.instance = instance
					slot.sceneNode = ModelSceneNode()

					self.game:getResourceManager():queueCacheRef(slot.instance:getModel(), function(model)
						model:getResource():bindSkeleton(self.body:getSkeleton())
						slot.sceneNode:setModel(model)
						slot.sceneNode:onWillRender(function()
							self:updateAnimations()
						end)

						local texture = slot.instance:getTexture()
						if texture then
							self.game:getResourceManager():queueCacheRef(texture, function(textureResource)
								slot.sceneNode:getMaterial():setTextures(textureResource)
							end)
						end

						if slot.instance:getIsTranslucent() then
							slot.sceneNode:getMaterial():setIsTranslucent(true)
							slot.sceneNode:getMaterial():setIsZWriteDisabled(true)
						end

						local transform = slot.sceneNode:getTransform()
						transform:setLocalTranslation(slot.instance:getPosition())
						transform:setLocalScale(slot.instance:getScale())
						transform:setLocalRotation(slot.instance:getRotation())

						slot.sceneNode:getMaterial():setIsFullLit(slot.instance:getIsFullLit())

						slot.sceneNode:setParent(self.sceneNode)
						slot.sceneNode:getMaterial():setTextures(self.game.whiteTexture)

						local lights = slot.instance:getLights()
						if #lights >= 0 then
							slot.lights = {}

							for i = 1, #lights do
								local inputLight = lights[i]
								local outputLight

								if inputLight:isPoint() then
									outputLight = PointLightSceneNode()
								elseif inputLight:getAmbience() > 0 then
									outputLight = AmbientLightSceneNode()
								end
								
								if outputLight then
									outputLight:fromLight(inputLight)
									outputLight:setParent(slot.sceneNode)
									table.insert(slot.lights, outputLight)
								end
							end
						end

						self.models[slot.sceneNode] = true

						step()
					end)
				end, self.body:getSkeleton())
			end
		else
			if slot.sceneNode then
				self.models[slot.sceneNode] = nil
			end

			slot.instance = false
			slot.sceneNode = false

			step()
		end
	end

	if i > 0 then
		self.game:getResourceManager():queueEvent(iterate)
	end
end

function ActorView:transmogrify(body)
	self.body = body:load()

	for _, slotNodes in pairs(self.skins) do
		self:applySkin(slotNodes)
	end
end

function ActorView:changeSkin(slot, priority, skin)
	if not skin then
		return
	end

	local slotNodes = self.skins[slot] or {}
	if not priority then
		for i = 1, #slotNodes do
			local s = slotNodes[i]
			if s.definition == skin then
				table.remove(slotNodes, i)

				if s.sceneNode then
					s.sceneNode:setParent(nil)
				end

				break
			end
		end
	else
		for i = 1, #slotNodes do
			local s = slotNodes[i]
			if s.priority == priority then
				table.remove(slotNodes, i)

				if s.sceneNode then
					s.sceneNode:setParent(nil)
				end

				break
			end
		end

		local s = {
			definition = skin,
			priority = priority
		}

		table.insert(slotNodes, s)
		table.sort(slotNodes, function(a, b) return a.priority < b.priority end)
	end

	self:applySkin(slotNodes)
	self.skins[slot] = slotNodes
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
	local sprite = self.game:getSpriteManager()
	sprite:add("Damage", self.sceneNode, Vector(0, 1, 0), damageType, damage)

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
	local sprite = self.game:getSpriteManager()

	self.sprites[sprite] = true

	if type(anchor) == 'number' then
		anchor = Vector(0, anchor, 0)
	end

	local min, max = self.actor:getBounds()
	local size = max - min

	sprite:add(message, self.sceneNode, size * anchor, ...)
end

function ActorView:tick()
	self.sceneNode:getTransform():setLocalScale(self.actor:getScale())
end

function ActorView:update(delta)
	self.animationsDirty = true
	self.animationDelta = delta

	self.animatable:update()
end

function ActorView:updateAnimations()
	if self.animationsDirty then
		local delta = self.animationDelta

		local animations = {}
		do
			for slot, animation in pairs(self.animations) do
				if animation.instance then
					table.insert(animations, { value = animation, key = slot })
				end
			end
			table.sort(animations, function(a, b) return a.value.priority < b.value.priority end)
		end

		for index, a in ipairs(animations) do
			local animation = a.value
			local slot = a.key

			animation.time = animation.time + delta
			if animation.done then
				if animation.next then
					animation.definition = animation.next.definition
					animation.instance = animation.definition:play(self.animatable)
					animation.time = animation.next.time or 0
					animation.priority = animation.next.priority or -math.huge
					animation.next = nil
				else
					self.animations[slot] = nil
					self.actor:playAnimation(slot, false)
				end

				animation.done = false
			else
				animation.done = animation.instance:play(animation.time, animation.next ~= nil, animations)
			end
		end

		local transforms = self.animatable:getTransforms()
		do
			for i = 1, #transforms do
				local animation, time = self.animatable:getAnimationForBone(i)
				if animation then
					animation:computeTransform(time, transforms, i)
				end
			end


			for i = 1, #transforms do
				local animation, time = self.animatable:getAnimationForBone(i)
				if animation then
					animation:applyBindPose(time, transforms, i)
				end
			end
		end

		for model in pairs(self.models) do
			model:setTransforms(self.animatable:getTransforms())
		end

		self.animationsDirty = false
	end
end

return ActorView
