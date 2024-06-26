--------------------------------------------------------------------------------
-- ItsyScape/UI/SceneSnippet.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local Widget = require "ItsyScape.UI.Widget"

local SceneSnippet = Class(Widget)

function SceneSnippet:new()
	Widget.new(self)

	self.root = SceneNode()
	self.camera = false
	self.isFullLit = false
end

function SceneSnippet:getRoot()
	return self.root
end

function SceneSnippet:setRoot(value)
	self.root = value or SceneNode()
end

function SceneSnippet:setParentNode(parentNode)
	self.parentNode = parentNode or false
end

function SceneSnippet:getParentNode(parentNode)
	return self.parentNode
end

function SceneSnippet:setChildNode(childNode)
	self.childNode = childNode or false
end

function SceneSnippet:getChildNode(childNode)
	return self.childNode
end

function SceneSnippet:getIsFullLit()
	return self.isFullLit
end

function SceneSnippet:setIsFullLit(value)
	self.isFullLit = value or false
end

function SceneSnippet:getCamera()
	return self.camera
end

function SceneSnippet:setCamera(camera)
	self.camera = camera or self.camera
end

return SceneSnippet
