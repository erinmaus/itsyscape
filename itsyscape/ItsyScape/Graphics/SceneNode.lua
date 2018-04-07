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
local SceneNodeTransform = require "ItsyScape.Graphics.SceneNodeTransform"
local Material = require "ItsyScape.Graphics.Material"

-- Represents the base scene node.
--
-- A scene node renders something.
local SceneNode = Class()

function SceneNode:new()
	self.transform = SceneNodeTransform()
	self.material = Material()
	self.parent = false
	self.children = {}
end

function SceneNode:setParent(parent)
	if self.parent then
		self.parent.children[self] = nil
	end

	if not parent then
		self.transform:setParentTransform(false)

		self.parent = false
	else
		self.parent = parent
		self.transform:setParentTransform(parent:getTransform())
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

return SceneNode
