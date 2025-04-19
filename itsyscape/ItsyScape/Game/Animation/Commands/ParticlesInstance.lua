--------------------------------------------------------------------------------
-- ItsyScape/Game/Animation/Commands/ParticlesInstance.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local CommandInstance = require "ItsyScape.Game.Animation.Commands.CommandInstance"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local ParticlesInstance = Class(CommandInstance)

function ParticlesInstance:new(command)
	self.command = command or false
end

function ParticlesInstance:bind(animatable, animationInstance)
	self.doesFadeOut = animationInstance:getAnimationDefinition():getFadesOut()
end

function ParticlesInstance:start(animatable)
	if self.command then
		local resources = animatable:getResourceManager()

		self.sceneNode = animatable:addSceneNode(ParticleSceneNode)
		self.sceneNode:initParticleSystemFromDef(self.command:getParticleSystem(), resources)
	end
end

function ParticlesInstance:pending(time, windingDown)
	if self.command then
		return time <= self.command:getDuration() and (self.doesFadeOut or not windingDown)
	end
end

function ParticlesInstance:getDuration(windingDown)
	return self.command:getDuration()
end

function ParticlesInstance:play(animatable, time)
	if self.command then
		local attach = self.command:getAttach()
		local rotation = Quaternion[self.command:getRotation()]
		local reverseRotation = Quaternion[self.command:getReverseRotation()]
		local direction = self.command:getDirection()
		local scale = self.command:getScale()
		if attach then
			local transform = love.math.newTransform()

			if reverseRotation and Class.isCompatibleType(reverseRotation, Quaternion) then
				transform:applyQuaternion((-reverseRotation):get())
			end

			if rotation and Class.isCompatibleType(rotation, Quaternion) then
				transform:applyQuaternion(rotation:get())
			end

			transform:scale(scale:get())

			animatable:getPostComposedTransform(attach, function(otherTransform)
				local combinedTransform = love.math.newTransform()
				combinedTransform:applyQuaternion((-Quaternion.X_90):get())
				combinedTransform:apply(transform)
				combinedTransform:apply(otherTransform)

				local localPosition = Vector(combinedTransform:transformPoint(0, 0, 0)) * Vector(1, 1, 1)
				self.sceneNode:updateLocalPosition(localPosition)

				if direction:getLength() > 0 then
					local _, q = MathCommon.decomposeTransform(otherTransform)
					self.sceneNode:updateLocalDirection(q:getNormal():transformVector(direction:getNormal()))
				end
			end)
		end
	end
end

function ParticlesInstance:stop(animatable)
	if self.sceneNode then
		animatable:removeSceneNode(self.sceneNode)
	end
end

return ParticlesInstance
