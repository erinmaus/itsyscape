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
end

function SceneNode:getBounds()
	return self.min, self.max
end

function SceneNode:setBounds(min, max)
	self.min = min or self.min
	self.max = max or self.max

	self._handle:setMin(self.min.x, self.min.y, self.min.z)
	self._handle:setMax(self.max.x, self.max.y, self.max.z)
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
end

function SceneNode:afterDraw(renderer, delta)
	love.graphics.pop()
end

function SceneNode:draw(renderer, delta)
	-- Nothing.
	--
	-- The Renderer is responsible for drawing children, not us.
end

function SceneNode:walkByMaterial(view, projection, delta)
	local camera = NCamera()
	camera:setView(view:getMatrix())
	camera:setProjection(projection:getMatrix())

	return self._handle:walkByMaterial(camera, delta)
end

function SceneNode:walkByPosition(view, projection, delta)
	local camera = NCamera()
	camera:setView(view:getMatrix())
	camera:setProjection(projection:getMatrix())

	return self._handle:walkByPosition(camera, delta)
end

return SceneNode
