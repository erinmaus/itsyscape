--------------------------------------------------------------------------------
-- ItsyScape/Graphics/PropView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SceneNode = require "ItsyScape.Graphics.SceneNode"

local PropView = Class()

function PropView:new(prop, gameView)
	self.prop = prop
	self.gameView = gameView

	self.sceneNode = SceneNode()
	self.ready = false
end

function PropView:getProp()
	return self.prop
end

function PropView:getGameView()
	return self.gameView
end

function PropView:getResources()
	return self.gameView:getResourceManager()
end

function PropView:getRoot()
	return self.sceneNode
end

function PropView:load()
	-- Nothing.
end

function PropView:attach()
	self.sceneNode:setParent(self.gameView:getScene())
	self:updateTransform()
end

function PropView:updateTransform()
	local transform = self.sceneNode:getTransform()
	transform:setLocalTranslation(self.prop:getPosition())
	transform:setLocalRotation(self.prop:getRotation())
	transform:setLocalScale(self.prop:getScale())
	transform:tick()
end

function PropView:remove()
	self.sceneNode:setParent(nil)
end

function PropView:update(delta)
	if not self.ready then
		self:updateTransform()
		self.ready = true
	end
end

function PropView:tick()
	self:updateTransform()
end

return PropView
