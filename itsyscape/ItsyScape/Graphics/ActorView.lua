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
local Animatable = require "ItsyScape.Game.Animation.Animatable"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local Skeleton = require "ItsyScape.Graphics.Skeleton"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"
local ModelSkin = require "ItsyScape.Graphics.Skin.ModelSkin"

local ActorView = Class()
ActorView.Animatable = Class(Animatable)
function ActorView.Animatable:new(actor)
	self.actor = actor
	self.transforms = {}
	self.sceneNodes = {}
end

function ActorView.Animatable:getSkeleton()
	if self.actor.body then
		return self.actor.body:getSkeleton()
	else
		return Skeleton.EMPTY
	end
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
	return self.transforms
end

function ActorView:getTransforms()
	return self.transforms
end

function ActorView:setTransforms(transforms)
	for k, transform in pairs(transforms)
		if type(k) == 'number' then
			self:setTransform(k, transform)
		end
	end
end

function ActorView:setTransform(index, transform)
	for i = 1, index do
		if self.transforms[index] == nil then
			self.transforms[index] = love.math.newTransform()
		end
	end

	self.transforms[index]:reset()
	self.transforms[index]:apply(transform)
end

function ActorView:new(actor, actorID)
	self.actor = actor
	self.actorID = actorID
	self.animatable = ActorView.Animatable(self)

	self.sceneNode = SceneNode()

	self.animations = {}
	self._onAnimationPlayed = function(_, slot, priority, animation)
		self:playAnimation(slot, animation)
	end
	actor.onAnimationPlayed:register(self._onAnimationPlayed)

	self.skins = {}
	self._onSkinChanged = function(_, slot, priority, skin)
		self:changeSkin(slot, priority, skin)
	end
	actor.onSkinChanged:register(self._onSkinChanged)

	self.body = false
	self._onTransmogrify = function(_, body)
		self:transmogrify(body)
	end
	actor.onTransmogrify:register(self._onTransmogrify)

	self._onTeleport = function(_, position)
		self:move(position, true)
	end
	actor.onTeleport:register(self._onTeleport)

	self._onMove = function(_, position)
		self:move(position, false)
	end
	actor.onMove:register(self._onMove)

	self._onDirectionChanged = function(_, direction)
		self:face(direction)
	end
	actor.onDirectionChanged:register(self._onDirectionChanged)
end

function ActorView:attach(scene)
	self.sceneNode:setParent(scene)
end

function ActorView:poof()
	self.sceneNode:setParent(nil)

	self.actor.onDirectionChanged:unregister(self._onDirectionChanged)
	self.actor.onMove:unregister(self._onMove)
	self.actor.onTeleport:unregister(self._onTeleport)
	self.actor.onAnimationPlayed:unregister(self._onAnimationPlayed)
	self.actor.onTransmogrify:unregister(self._onTransmogrify)
	self.actor.onSkinChanged:unregister(self._onSkinChanged)
end

function ActorView:getSceneNode()
	return self.sceneNode
end

function ActorView:playAnimation(slot, animation, time)
	-- TODO blending
	local animation = self.animations[slot] or {}
	if animation.instance then
		animation.instance:stop()
	end

	-- TODO load queue
	animation.definition = animation:load()
	animation.instance = animation:play(self.animatable)
	animation.time = time or 0

	self.animations[slot] = animation
end

function ActorView:transmogrify(body)
	self.body = body

	for _, slot in self.skins do
		if slot.sceneNode then
			slot.sceneNode:setParent(nil)
		end

		if body then
			-- TODO load queue
			if slot.definition:isType(ModelSkin) then
				slot.instance = skin:load(body:getSkeleton())
				slot.sceneNode = ModelSceneNode(slot.instance:getModel())
			end
		else
			slot.instance = false
			slot.sceneNode = false
		end
	end
end

function ActorView:changeSkin(slot, priority, skin)
	local slot = self.skins[slot] or { priority = -math.huge }

	-- TODO actually have a skin queue; currently removing a skin doesn't work
	--      Remember to update transmogrify!
	if skin and slot.priority < priority then
		slot.priority = slot.top
		slot.definition = skin

		if slot.sceneNode then
			slot.sceneNode:setParent(nil)
		end

		-- TODO load queue
		if self.body then
			if skin:isType(ModelSkin) then
				slot.instance = skin:load(self.body:getSkeleton())
				slot.sceneNode = ModelSceneNode(slot.instance:getModel())
		else
			slot.instance = false
			slot.sceneNode = false
		end
	end
end

function ActorView:move(position, instant)
	self.sceneNode:setLocalTranslation(position)

	if instant then
		self.sceneNode:setPreviousTransform(position)
	end
end

function ActorView:onDirectionChanged(direction)
	-- Assumes models face right.
	if direction.x < -0.5 then
		self.sceneNode:setLocalRotation(Quaternion.fromAxisangle(Vector.UNIT_Y, -math.pi))
	else if direction.x > 0.5
		self.sceneNode:setLocalRotation(Quaternion.IDENTITY)
	end
end

function ActorView:update(delta)
	for _, animation in pairs(self.animations) do
		animation.time = animation.time + delta
		animation:update(animation.time)
	end

	for _, model in pairs(self.models)
		model:setTransforms(self.animatable:getTransforms())
	end
end

return ActorView
