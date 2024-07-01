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
SceneSnippetRenderer.MAX_RENDERS_PER_FRAME = 4

function SceneSnippetRenderer:new(resources)
	WidgetRenderer.new(self, resources)

	self.renderers = {}
	self.renders = {}
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
	self.renders[widget] = nil
end

function SceneSnippetRenderer:start()
	WidgetRenderer.start(self)

	self.currentNumRenders = 0
end

function SceneSnippetRenderer:stop()
	WidgetRenderer.stop(self)

	local allRendered = true
	for _, rendered in pairs(self.renders) do
		if not rendered then
			allRendered = false
			break
		end
	end

	if allRendered then
		table.clear(self.renders)
	end
end

function SceneSnippetRenderer:draw(widget)
	self:visit(widget)

	local camera = widget:getCamera()
	if camera then
		local renderer = self.renderers[widget]
		local isRendered = self.renders[widget]

		if (not isRendered and self.currentNumRenders < self.MAX_RENDERS_PER_FRAME) or widget:getAlwaysRender() then
			local oldParent
			if widget:getChildNode() and widget:getParentNode() then
				oldParent = widget:getChildNode():getParent()
				widget:getChildNode():setParent(widget:getParentNode())
			end

			love.graphics.push('all')
			love.graphics.setScissor()
			renderer:setCamera(camera)
			renderer:draw(widget:getRoot(), 0, widget:getSize())
			love.graphics.pop()

			if oldParent then
				widget:getChildNode():setParent(oldParent)
			end

			self.renders[widget] = true
			self.currentNumRenders = self.currentNumRenders + 1
		elseif isRendered == nil then
			self.renders[widget] = false
		end

		local color = renderer:getOutputBuffer():getColor()
		if color then
			itsyrealm.graphics.uncachedDraw(renderer:getOutputBuffer():getColor())
		end
	end
end

return SceneSnippetRenderer
