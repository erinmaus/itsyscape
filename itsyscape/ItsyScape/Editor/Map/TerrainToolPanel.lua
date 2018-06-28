--------------------------------------------------------------------------------
-- ItsyScape/Editor/Map/TerrainToolPanel.lua
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

local TerrainToolPanel = Class(Widget)
TerrainToolPanel.WIDTH = 320
TerrainToolPanel.HEIGHT = 64
TerrainToolPanel.SIZE_HILL = -1
TerrainToolPanel.SIZE_SINGLE = 1

function TerrainToolPanel:new(application)
	Widget.new(self)

	self.application = application

	self:setPosition(16, 16)
	self:setSize(TerrainToolPanel.WIDTH, TerrainToolPanel.HEIGHT)

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

	local plusButton = Button()
	plusButton:setText("+")
	plusButton:setSize(48, 48)
	plusButton.onClick:register(self.increaseSize, self, 1)
	gridLayout:addChild(plusButton)

	local minusButton = Button()
	minusButton:setText("-")
	minusButton:setSize(48, 48)
	minusButton.onClick:register(self.increaseSize, self, -1)
	gridLayout:addChild(minusButton)

	local hillButton = Button()
	hillButton:setText("H")
	hillButton:setSize(48, 48)
	hillButton.onClick:register(self.makeHill, self)
	gridLayout:addChild(hillButton)

	self.toolSize = 1
end

function TerrainToolPanel:increaseSize(distance)
	if distance > 0 then
		self.toolSize = math.max(self.toolSize + 1, 1)
	elseif distance < 0 then
		self.toolSize = math.max(self.toolSize - 1, 0)
	end

	if self.toolSize == 0 then
		self:makeHill()
	else
		self.sizeInput:setText(tostring(self.toolSize))
	end
end

function TerrainToolPanel:makeHill()
	self.sizeInput:setText("hill")
	self.toolSize = -1
end

function TerrainToolPanel:getToolSize()
	return self.toolSize
end

function TerrainToolPanel:setToolSize(value)
	self.toolSize = math.max(value or self.toolSize, 1)
end

function TerrainToolPanel:open(x, y, parent)
	local currentX, currentY = self:getPosition()
	self:setPosition(x or currentX, y or currentY)

	local root = parent or self.application:getUIView():getRoot()
	root:addChild(self)
end

function TerrainToolPanel:close()
	local p = self:getParent()
	if p then
		p:removeChild(self)
	end
end

return TerrainToolPanel
