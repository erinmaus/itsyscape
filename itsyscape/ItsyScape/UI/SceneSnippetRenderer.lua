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
local OutlinePostProcessPass = require "ItsyScape.Graphics.OutlinePostProcessPass"
local Renderer = require "ItsyScape.Graphics.Renderer"
local WidgetRenderer = require "ItsyScape.UI.WidgetRenderer"

local SceneSnippetRenderer = Class(WidgetRenderer)
SceneSnippetRenderer.MAX_RENDERS_PER_FRAME = 4

function SceneSnippetRenderer:new(resources, gameView)
	WidgetRenderer.new(self, resources)

	self.gameView = gameView

	self.renderers = {}
	self.outlinePostProcessPasses = {}
	self.renders = {}
end

function SceneSnippetRenderer:add(widget)
	WidgetRenderer.add(self, widget)

	local renderer = Renderer()
	renderer:setClearColor(Color(0, 0, 0, 0))
	renderer:setCullEnabled(false)

	local outlinePostProcessPass = OutlinePostProcessPass(renderer)
	outlinePostProcessPass:load(self.gameView:getResourceManager())
	outlinePostProcessPass:setMinOutlineThickness(1)
	outlinePostProcessPass:setMaxOutlineThickness(1)
	outlinePostProcessPass:setMinOutlineDepthAlpha(1.0)
	outlinePostProcessPass:setOutlineThicknessNoiseJitter(1)

	self.renderers[widget] = renderer
	self.outlinePostProcessPasses[widget] = { outlinePostProcessPass }
end

function SceneSnippetRenderer:drop(widget)
	WidgetRenderer.drop(self, widget)

	self.renderers[widget]:clean()
	self.renderers[widget] = nil
	self.outlinePostProcessPasses[widget] = nil
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

			local oldShimmer
			if widget:getChildNode() then
				oldShimmer = widget:getChildNode():getMaterial():getIsShimmerEnabled()
				widget:getChildNode():getMaterial():setIsShimmerEnabled(false)
			end

			local w, h = widget:getSize()
			w = w * widget:getDPIScale()
			h = h * widget:getDPIScale()

			love.graphics.push('all')
			love.graphics.setScissor()
			renderer:setCamera(camera)
			renderer:draw(widget:getRoot(), _APP:getPreviousFrameDelta(), w, h, self.outlinePostProcessPasses[widget])
			love.graphics.pop()

			if oldParent then
				widget:getChildNode():setParent(oldParent)
			end

			if oldShimmer ~= nil then
				widget:getChildNode():getMaterial():setIsShimmerEnabled(oldShimmer)
			end

			self.renders[widget] = true
			self.currentNumRenders = self.currentNumRenders + 1
		elseif isRendered == nil then
			self.renders[widget] = false
		end

		local color = renderer:getOutputBuffer():getColor()
		if color then
			itsyrealm.graphics.uncachedDraw(renderer:getOutputBuffer():getColor(), 0, 0, 0, 1 / widget:getDPIScale(), 1 / widget:getDPIScale())
		end
	end
end

return SceneSnippetRenderer
