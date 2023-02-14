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
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local CommandInstance = require "ItsyScape.Game.Animation.Commands.CommandInstance"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local ParticlesInstance = Class(CommandInstance)

function ParticlesInstance:new(command)
	self.command = command or false
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
		return time <= self.command:getDuration() and not windingDown
	end
end

function ParticlesInstance:getDuration(windingDown)
	return self.command:getDuration()
end

function ParticlesInstance:play(animatable, time)
	if self.command then
		local attach = self.command:getAttach()
		local rotation = Quaternion[self.command:getRotation()]
		local scale = self.command:getScale()
		if attach then
			local transform = love.math.newTransform()

			if rotation and Class.isCompatibleType(rotation, Quaternion) then
				transform:applyQuaternion(rotation:get())
			end

			transform:scale(scale:get())

			do
				local otherTransform = animatable:getComposedTransform(attach)
				transform:apply(otherTransform)
			end

			local localPosition = Vector(transform:transformPoint(0, 0, 0))
			local system = self.sceneNode:getParticleSystem()
			if system then
				system:updateEmittersLocalPosition(localPosition)
			end
		end
	end
end

function ParticlesInstance:stop(animatable)
	if self.sceneNode then
		animatable:removeSceneNode(self.sceneNode)
	end
end

return ParticlesInstance
