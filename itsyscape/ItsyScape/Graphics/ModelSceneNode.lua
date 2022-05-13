--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ModelSceneNode.lua
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
local NModelSceneNode = require "nbunny.optimaus.scenenode.modelscenenode"

local ModelSceneNode = Class(SceneNode)
-- Because of skeletal animation, the bounds may expand.
ModelSceneNode.BOUNDS_BUFFER = 2
ModelSceneNode.DEFAULT_SHADER = ShaderResource()
ModelSceneNode.STATIC_SHADER = ShaderResource()
do
	ModelSceneNode.DEFAULT_SHADER:loadFromFile("Resources/Shaders/SkinnedModel")
	ModelSceneNode.STATIC_SHADER:loadFromFile("Resources/Shaders/StaticModel")
end

function ModelSceneNode:new()
	SceneNode.new(self, NModelSceneNode)

	self:getMaterial():setShader(ModelSceneNode.DEFAULT_SHADER)
end

function ModelSceneNode:getModel()
	local model = self:getHandle():getModel()
	if model then
		return model:getResource()
	end

	return nil
end

function ModelSceneNode:setModel(model)
	if model then
		self:getHandle():setModel(model:getHandle())

		local min, max = model:getResource():getBounds()
		local size = max - min
		local center = min + size / 2
		size = size * ModelSceneNode.BOUNDS_BUFFER
		self:setBounds(center - size, center + size)
	else
		self:getHandle():setModel()
	end
end

-- Sets the bone transforms.
--
-- Transforms is expected to be an array of love.math.Transform objects.
function ModelSceneNode:setTransforms(transforms)
	self:getHandle():setTransforms(transforms)
end

-- Sets identity bone transforms.
--
-- If count is unspecified, defaults to number of bones in the Model. If no
-- bones are in the model, or the model has no skeleton bound, count defaults to
-- one.
function ModelSceneNode:setIdentity(count)
	local transforms = {}
	if not count then
		count = 1

		local model = self:getModel()
		if model and model:getIsReady() then
			model = model:getResource()
			local skeleton = model:getSkeleton()
			if skeleton then
				count = skeleton:getNumBones()
			end
		end
	end

	local identityTransform = love.math.newTransform()
	local transforms = {}
	for i = 1, count do
		table.insert(transforms, identityTransform)
	end

	self:setTransforms(transforms)
end

-- function ModelSceneNode:beforeDraw(renderer, delta)
-- 	SceneNode.beforeDraw(self, renderer, delta)

-- 	-- XXX: Terrible hack. Models are rotated when animated. The exporter needs
-- 	-- to correct this but that's a problem for another day.
-- 	love.graphics.rotate(1, 0, 0, -math.pi / 2)
-- end

-- Gets the transforms and the number of transforms.
--
-- The returned transforms array may contain more transforms than in use. Use
-- the numTransforms return value to properly handle this case.
--
-- Returns a tuple (transforms, numTransforms).
function ModelSceneNode:getTransforms()
	return self:getHandle():getTransforms()
end

-- function ModelSceneNode:draw(renderer, delta)
-- 	local shader = renderer:getCurrentShader()
-- 	if shader and self.model and self.model:getIsReady() then
-- 		local diffuseTexture = self:getMaterial():getTexture(1)
-- 		if shader:hasUniform("scape_DiffuseTexture") and
-- 		   diffuseTexture and diffuseTexture:getIsReady()
-- 		then
-- 			shader:send("scape_DiffuseTexture", diffuseTexture:getResource())
-- 		end

-- 		if shader:hasUniform("scape_Bones") then
-- 			shader:send("scape_Bones", unpack(self.cachedTransforms, 1, self.numTransforms))
-- 		end

-- 		love.graphics.draw(self.model:getResource():getMesh())
-- 	end
-- end

return ModelSceneNode
