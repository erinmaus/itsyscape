--------------------------------------------------------------------------------
-- ItsyScape/Graphics/SceneNode.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local SceneNodeTransform = require "ItsyScape.Graphics.SceneNodeTransform"
local Material = require "ItsyScape.Graphics.Material"
local NSceneNode = require "nbunny.scenenode"
local NCamera = require "nbunny.camera"

-- Represents the base scene node.
--
-- A scene node renders something.
local SceneNode = Class()

function SceneNode:new()
	self._handle = NSceneNode(self)
	self.transform = SceneNodeTransform(self)
	self.material = Material(self)
	self.parent = false
	self.children = {}
	self.min, self.max = Vector(), Vector()
	self.boundsDirty = true
	self.willRender = false
end

function SceneNode:onWillRender(func)
	if func then
		self.willRender = func
	else
		self.willRender = false
	end
end

function SceneNode:getBounds()
	return self.min, self.max
end

function SceneNode:_debugDrawBounds(renderer, delta)
	if not Class.isCompatibleType(self, require "ItsyScape.Graphics.ParticleSceneNode") then
		return
	end

	love.graphics.setMeshCullMode('back')
	love.graphics.setDepthMode('lequal', true)

	love.graphics.setShader()
	love.graphics.setLineWidth(2)
	love.graphics.setWireframe(true)

	if self.boundsDirty then
		if self._boundsMesh then
			self._boundsMesh:release()
		end

		local min, max = self.min, self.max
		local vertices = {
			-- Front
			{ min.x, min.y, max.z },
			{ max.x, min.y, max.z },
			{ max.x, max.y, max.z },
			{ min.x, min.y, max.z },
			{ max.x, max.y, max.z },
			{ min.x, max.y, max.z },

			-- Back.
			{ max.x, min.y, min.z },
			{ min.x, min.y, min.z },
			{ max.x, max.y, min.z },
			{ max.x, max.y, min.z },
			{ min.x, min.y, min.z },
			{ min.x, max.y, min.z },

			-- Left.
			{ min.x, min.y, min.z },
			{ min.x, min.y, max.z },
			{ min.x, max.y, max.z },
			{ min.x, max.y, min.z },
			{ min.x, min.y, min.z },
			{ min.x, max.y, max.z },

			-- Right.
			{ max.x, max.y, max.z },
			{ max.x, min.y, max.z },
			{ max.x, min.y, min.z },
			{ max.x, max.y, max.z },
			{ max.x, min.y, min.z },
			{ max.x, max.y, min.z },

			-- Top
			{ max.x, max.y, min.z },
			{ min.x, max.y, min.z },
			{ max.x, max.y, max.z },
			{ min.x, max.y, min.z },
			{ min.x, max.y, max.z },
			{ max.x, max.y, max.z },

			-- Bottom.
			{ min.x, min.y, min.z },
			{ max.x, min.y, min.z },
			{ max.x, min.y, max.z },
			{ max.x, min.y, max.z },
			{ min.x, min.y, max.z },
			{ min.x, min.y, min.z },
		}

		self._boundsMesh = love.graphics.newMesh({
				{ "VertexPosition", 'float', 3 }
			}, vertices, 'triangles', 'static')
		self._boundsMesh:setAttributeEnabled("VertexPosition", true)

		self.boundsDirty = false
	end

	love.graphics.push()
	love.graphics.applyTransform(self:getTransform():getGlobalDeltaTransform(delta))
	love.graphics.draw(self._boundsMesh)
	love.graphics.pop()

	love.graphics.setLineWidth(1)
	love.graphics.setWireframe(false)
end

function SceneNode:setBounds(min, max)
	self.min = min or self.min
	self.max = max or self.max

	self._handle:setMin(self.min.x, self.min.y, self.min.z)
	self._handle:setMax(self.max.x, self.max.y, self.max.z)
	self.boundsDirty = true
end

function SceneNode:setParent(parent)
	if self.parent then
		self.parent.children[self] = nil
	end

	if not parent then
		self._handle:setParent(nil)
		self.parent = false
	else
		self._handle:setParent(parent._handle)
		self.parent = parent
		self.parent.children[self] = true
	end

end

function SceneNode:getParent()
	return self.parent
end

function SceneNode:getTransform()
	return self.transform
end

function SceneNode:getMaterial()
	return self.material
end

function SceneNode:iterate()
	return pairs(self.children)
end

function SceneNode:tick()
	self.transform:tick()

	for child in self:iterate() do
		child:tick()
	end
end

function SceneNode:frame(delta)
	self.transform:frame(delta)

	for child in self:iterate() do
		child:frame(delta)
	end
end

function SceneNode:beforeDraw(renderer, delta)
	love.graphics.push()
	love.graphics.applyTransform(self.transform:getGlobalDeltaTransform(delta))

	if self.willRender then
		self.willRender(renderer, delta)
	end

	love.graphics.setColor(self.material:getColor():get())
end

function SceneNode:afterDraw(renderer, delta)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.pop()
end

function SceneNode:draw(renderer, delta)
	-- Nothing.
	--
	-- The Renderer is responsible for drawing children, not us.
end

function SceneNode:walkByMaterial(view, projection, delta, enableCull)
	local camera = NCamera()
	camera:setView(view:getMatrix())
	camera:setProjection(projection:getMatrix())
	if enableCull or enableCull == nil then
		camera:enableCull()
	else
		camera:disableCull()
	end

	return self._handle:walkByMaterial(camera, delta)
end

function SceneNode:walkByPosition(view, projection, delta, enableCull)
	local camera = NCamera()
	camera:setView(view:getMatrix())
	camera:setProjection(projection:getMatrix())
	if enableCull or enableCull == nil then
		camera:enableCull()
	else
		camera:disableCull()
	end

	return self._handle:walkByPosition(camera, delta)
end

return SceneNode
