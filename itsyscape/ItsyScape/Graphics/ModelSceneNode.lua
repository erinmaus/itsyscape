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

local ModelSceneNode = Class(SceneNode)

function ModelSceneNode:new()
	SceneNode.new(self)

	self.model = false

	self.transforms = {}
	self.cachedTransforms = {}
	self.numTransforms = 0
end

function ModelSceneNode:getModel()
	return self.model
end

function ModelSceneNode:setModel(model)
	if model then
		self.model = model
	else
		self.model = false
	end
end

-- Sets the bone transforms.
--
-- Transforms is expected to be an array of love.math.Transform objects.
function ModelSceneNode:setTransforms(transforms)
	for i = 1, #transforms do
		local t = self.transforms[i] or love.math.newTransform()

		t:reset()
		t:apply(transforms[i])

		self.transforms[i] = t
		self.cachedTransforms[i] = { t:getMatrix() }
	end

	self.numTransforms = #transforms
end

-- Sets identity bone transforms.
--
-- If count is unspecified, defaults to number of bones in the Model. If no
-- bones are in the model, or the model has no skeleton bound, count defaults to
-- one.
function ModelSceneNode:setIdentity(count)
	if not count then
		count = 1

		if self.model and self.model:getIsReady() then
			local model = self.model:getResource()
			local skeleton = model:getSkeleton()
			if skeleton then
				count = skeleton:getNumBones()
			end
		end
	end

	for i = 1, count do
		local t = self.transforms[i] or love.math.newTransform()
		t:reset()

		self.transforms[i] = t
		self.cachedTransforms[i] = { t:getMatrix() }
	end

	self.numTransforms = count
end

function ModelSceneNode:beforeDraw(renderer, delta)
	SceneNode.beforeDraw(self, renderer, delta)

	-- XXX: Terrible hack. Models are rotated when animated. The exporter needs
	-- to correct this but that's a problem for another day.
	love.graphics.rotate(1, 0, 0, -math.pi / 2)
end

-- Gets the transforms and the number of transforms.
--
-- The returned transforms array may contain more transforms than in use. Use
-- the numTransforms return value to properly handle this case.
--
-- Returns a truple (transforms, numTransforms).
function ModelSceneNode:getTransforms()
	return self.transforms, self.numTransforms
end

function ModelSceneNode:draw(renderer, delta)
	local shader = renderer:getCurrentShader()
	if shader and self.model and self.model:getIsReady() then
		local diffuseTexture = self:getMaterial():getTexture(1)
		if shader:hasUniform("scape_DiffuseTexture") and
		   diffuseTexture and diffuseTexture:getIsReady()
		then
			shader:send("scape_DiffuseTexture", diffuseTexture:getResource())
		end

		if shader:hasUniform("scape_Bones") then
			shader:send("scape_Bones", unpack(self.cachedTransforms, 1, self.numTransforms))
		end

		love.graphics.draw(self.model:getResource():getMesh())
	end
end

return ModelSceneNode
