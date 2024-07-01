--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ParticleSceneNode.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local NParticleSceneNode = require "nbunny.optimaus.scenenode.particlescenenode"

local ParticleSceneNode = Class(SceneNode)
ParticleSceneNode.DEFAULT_SHADER = ShaderResource()
do
	ParticleSceneNode.DEFAULT_SHADER:loadFromFile("Resources/Shaders/Particle")
end

function ParticleSceneNode:new()
	SceneNode.new(self, NParticleSceneNode)

	self:getMaterial():setShader(ParticleSceneNode.DEFAULT_SHADER)
	self:getMaterial():setIsTranslucent(true)
	self:getMaterial():setIsFullLit(true)

	self.isReady = false
	self._texture = false
end

function ParticleSceneNode:pause()
	self:getHandle():pause()
end

function ParticleSceneNode:play()
	self:getHandle():play()
end

function ParticleSceneNode:getIsPlaying()
	return self:getHandle():getIsPlaying()
end

function ParticleSceneNode:getIsReady()
	return self.isReady
end

function ParticleSceneNode:initParticleSystemFromDef(def, resources)
	if def.texture then
		if def.texture ~= self._texture then
			resources:queue(TextureResource, def.texture, function(texture)
				self._texture = def.texture

				self:getMaterial():setTextures(texture)
				self:getHandle():initParticleSystemFromDef(def)

				self.isReady = true
			end)
		else
			self:getHandle():initParticleSystemFromDef(def)
		end
	else
		self:getHandle():initParticleSystemFromDef(def)
		self.isReady = true
	end
end

function ParticleSceneNode:initEmittersFromDef(def)
	self:getHandle():initEmittersFromDef(def)
end

function ParticleSceneNode:initPathsFromDef(def)
	self:getHandle():initPathsFromDef(def)
end

function ParticleSceneNode:initEmissionStrategyFromDef(def)
	self:getHandle():initEmissionStrategyFromDef(def)
end

function ParticleSceneNode:updateLocalPosition(position)
	self:getHandle():updateLocalPosition(position:get())
end

function ParticleSceneNode:updateLocalDirection(position)
	self:getHandle():updateLocalDirection(position:get())
end

function ParticleSceneNode:frame(delta)
	SceneNode.frame(self, delta)
	self:getHandle():frame(delta, love.timer.getDelta())
end

return ParticleSceneNode
