--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Prop = require "ItsyScape.Game.Model.Prop"
local Actor = require "ItsyScape.Game.Model.Actor"
local SceneNode = require "ItsyScape.Graphics.SceneNode"

local Projectile = Class()

function Projectile:new(id, gameView, source, destination, layer)
	self.gameView = gameView
	self.id = id
	self.source = source
	self.destination = destination
	self.layer = layer
	self.time = 0
	self._didTick = false

	self.sceneNode = SceneNode()
end

function Projectile:getID()
	return self.id
end

function Projectile:attach()
	self.sceneNode:setParent(self.gameView:getScene())
end

function Projectile:poof()
	self.sceneNode:setParent(nil)
end

function Projectile:load()
	-- Nothing.
end

function Projectile:resetTime()
	self.time = 0
end

function Projectile:getTime()
	return self.time
end

function Projectile:getDuration()
	return math.huge
end

function Projectile:getDelta()
	return math.min(math.max(self.time / self:getDuration(), 0), 1)
end

function Projectile:isDone()
	return self:getDelta() >= 1.0
end

function Projectile:getGameView()
	return self.gameView
end

function Projectile:getResources()
	return self.gameView:getResourceManager()
end

function Projectile:getSource()
	return self.source
end

function Projectile:getDestination()
	return self.destination
end

function Projectile:playAnimation(target, animation, slot, priority)
	target = target or self.gameView:getGame():getPlayer():getActor()

	if Class.isCompatibleType(target, Actor) then
		local filename = string.format("Resources/Game/Animations/%s/Script.lua", animation)
		local cacheRef = CacheRef("ItsyScape.Graphics.AnimationResource", filename)

		target:onAnimationPlayed(slot or "x-projectile-fx", priority or 0, cacheRef)
	end
end

function Projectile:getTargetPosition(target, offset)
	offset = offset or Vector.ZERO

	if target then
		if target:isCompatibleType(Prop) or target:isCompatibleType(Actor) then
			local positionable

			if self.gameView:getView(target) then
				if target:isCompatibleType(Prop) then
					positionable = self.gameView:getView(target):getRoot()
				elseif target:isCompatibleType(Actor) then
					positionable = self.gameView:getView(target):getSceneNode()
				end
			end

			if positionable then
				local transform = positionable:getTransform():getGlobalDeltaTransform(0)
				local position = Vector(transform:transformPoint(offset:get()))

				local y
				if self.CLAMP_BOTTOM then
					y = 0
				else
					local min, max = target:getBounds()
					y = (max.y - min.y) / 2
				end

				return position + Vector(0, y, 0)
			end
		elseif target:isCompatibleType(Vector) then
			return target
		end
	end

	return Vector.ZERO
end

function Projectile:update(elapsed)
	self.time = self.time + elapsed
end

function Projectile:getRoot()
	return self.sceneNode
end

function Projectile:ready()
	if not self._isReady then
		self.sceneNode:tick(1)
		self._isReady = true
	end
end

function Projectile:tick()
	-- Nothing.
end

return Projectile
