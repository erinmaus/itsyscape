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
local CommandInstance = require "ItsyScape.Game.Animation.Commands.CommandInstance"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local ParticlesInstance = Class(CommandInstance)

function ParticlesInstance:new(command)
	self.command = command or false
end

function ParticlesInstance:bind(animatable)
	if self.command then
		local resources = animatable:getResourceManager()

		self.sceneNode = animatable:addSceneNode(ParticleSceneNode)
		self.sceneNode:initParticleSystemFromDef(self.command:getParticleSystem(), resources)
	end
end

function ParticlesInstance:pending(time, windingDown)
	if self.command then
		return time < self.command:getDuration()
	end
end

function ParticlesInstance:getDuration(windingDown)
	return self.command:getDuration()
end

function ParticlesInstance:play(animatable, time)
	-- Nothing.
end

function ParticlesInstance:stop(animatable)
	if self.sceneNode then
		animatable:removeSceneNode(self.sceneNode)
	end
end

return ParticlesInstance
