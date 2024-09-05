--------------------------------------------------------------------------------
-- ItsyScape/Editor/Map/BrushToolPanel.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Button = require "ItsyScape.UI.Button"
local DraggablePanel = require "ItsyScape.UI.DraggablePanel"
local GridLayout = require "ItsyScape.UI.GridLayout"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Label = require "ItsyScape.UI.Label"
local TextInput = require "ItsyScape.UI.TextInput"
local Widget = require "ItsyScape.UI.Widget"

local BrushToolPanel = Class(Widget)
BrushToolPanel.WIDTH = 320
BrushToolPanel.HEIGHT = 64
BrushToolPanel.SIZE_HILL = -1
BrushToolPanel.SIZE_SINGLE = 1

function BrushToolPanel:new(application)
	Widget.new(self)

	self.application = application

	self:setPosition(16, 16)
	self:setSize(BrushToolPanel.WIDTH, BrushToolPanel.HEIGHT)

	local panel = DraggablePanel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	local titleLabel = Label()
	titleLabel:setText("Terrain Tool")
	titleLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
		fontSize = 24,
		color = { 1, 1, 1, 1 },
		textShadow = true
	}, application:getUIView():getResources()))
	titleLabel:setPosition(16, -24)
	self:addChild(titleLabel)

	local gridLayout = GridLayout()
	gridLayout:setPadding(8, 8)
	gridLayout:setSize(self:getSize())
	self:addChild(gridLayout)

	self.sizeInput = TextInput()
	self.sizeInput:setSize(128, 48)
	self.sizeInput:setText("1")
	self.sizeInput.onValueChanged = function()
		self.toolSize = math.max(tonumber(self.sizeInput.text) or 1, 1)
	end
	gridLayout:addChild(self.sizeInput)

	self.pressureInput = TextInput()
	self.pressureInput:setSize(128, 48)
	self.pressureInput:setText("0.5")
	self.pressureInput.onValueChanged = function()
		self.pressure = tonumber(self.pressureInput.text)
	end
	gridLayout:addChild(self.pressureInput)

	self.toolSize = 1
	self.pressure = 0.5
end

function BrushToolPanel:getToolSize()
	return self.toolSize
end

function BrushToolPanel:getPressure()
	return self.pressure
end

function BrushToolPanel:setToolSize(value)
	self.toolSize = math.max(value or self.toolSize, 1)
end

function BrushToolPanel:open(x, y, parent)
	local currentX, currentY = self:getPosition()
	self:setPosition(x or currentX, y or currentY)

	local root = parent or self.application:getUIView():getRoot()
	root:addChild(self)
end

function BrushToolPanel:close()
	local p = self:getParent()
	if p then
		p:removeChild(self)
	end
end

return BrushToolPanel
