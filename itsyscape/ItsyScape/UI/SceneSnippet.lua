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
end

function SceneSnippet:getRoot()
	return self.root
end

function SceneSnippet:setRoot(value)
	self.root = value or self.root
end

function SceneSnippet:getCamera()
	return self.camera
end

function SceneSnippet:setCamera(camera)
	self.camera = camera or self.camera
end

return SceneSnippet
