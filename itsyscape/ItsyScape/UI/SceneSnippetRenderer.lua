--------------------------------------------------------------------------------
-- ItsyScape/UI/DraggablePanel.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Renderer = require "ItsyScape.Graphics.Renderer"
local WidgetRenderer = require "ItsyScape.UI.WidgetRenderer"

local SceneSnippetRenderer = Class(WidgetRenderer)

function SceneSnippetRenderer:new(resources)
	WidgetRenderer.new(self, resources)

	self.renderers = {}
end

function SceneSnippetRenderer:add(widget)
	WidgetRenderer.add(self, widget)

	self.renderers[widget] = Renderer()
	self.renderers[widget]:setClearColor(Color(0, 0, 0, 0))
	self.renderers[widget]:setCullEnabled(false)
end

function SceneSnippetRenderer:drop(widget)
	WidgetRenderer.drop(self, widget)

	self.renderers[widget]:clean()
	self.renderers[widget] = nil
end

function SceneSnippetRenderer:draw(widget)
	self:visit(widget)

	local camera = widget:getCamera()
	if camera then
		local renderer = self.renderers[widget]
		do
			love.graphics.push('all')
			love.graphics.setScissor()
			renderer:setCamera(camera)
			renderer:draw(widget:getRoot(), 0, widget:getSize())
			love.graphics.pop()
		end

		love.graphics.ortho(love.window:getMode())
		renderer:presentCurrent()

		love.graphics.setBlendMode('alpha')
	end
end

return SceneSnippetRenderer
