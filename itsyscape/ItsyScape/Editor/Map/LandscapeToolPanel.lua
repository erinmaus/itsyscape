--------------------------------------------------------------------------------
-- ItsyScape/Editor/Map/LandscapeToolPanel.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local DraggablePanel = require "ItsyScape.UI.DraggablePanel"
local GridLayout = require "ItsyScape.UI.GridLayout"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Label = require "ItsyScape.UI.Label"
local TextInput = require "ItsyScape.UI.TextInput"
local Widget = require "ItsyScape.UI.Widget"

local LandscapeToolPanel = Class(Widget)
LandscapeToolPanel.WIDTH = 320
LandscapeToolPanel.HEIGHT = 128
LandscapeToolPanel.SIZE_HILL = -1
LandscapeToolPanel.SIZE_SINGLE = 1
LandscapeToolPanel.MODE_FLAT = 1
LandscapeToolPanel.MODE_EDGE = 2
LandscapeToolPanel.MODE_DECAL = 3

function LandscapeToolPanel:new(application)
	Widget.new(self)

	self.application = application

	self:setPosition(16, 16)
	self:setSize(LandscapeToolPanel.WIDTH, LandscapeToolPanel.HEIGHT)

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
	self.sizeInput:setText("0")
	self.sizeInput.onValueChanged = function()
		self.toolSize = math.max(tonumber(self.sizeInput.text) or 0, -1)
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

	local flatButton = Button()
	flatButton:setText("Flat")
	flatButton:setData('mode', LandscapeToolPanel.MODE_FLAT)
	flatButton:setSize(96, 48)
	flatButton.onClick:register(function()
		self:setMode(LandscapeToolPanel.MODE_FLAT)
	end)
	gridLayout:addChild(flatButton)

	local cliffButton = Button()
	cliffButton:setText("Cliff")
	cliffButton:setData('mode', LandscapeToolPanel.MODE_EDGE)
	cliffButton:setSize(96, 48)
	cliffButton.onClick:register(function()
		self:setMode(LandscapeToolPanel.MODE_EDGE)
	end)
	gridLayout:addChild(cliffButton)

	local decalButton = Button()
	decalButton:setText("Decal")
	decalButton:setData('mode', LandscapeToolPanel.MODE_DECAL)
	decalButton:setSize(96, 48)
	decalButton.onClick:register(function()
		self:setMode(LandscapeToolPanel.MODE_DECAL)
	end)
	gridLayout:addChild(decalButton)

	self.buttons = {
		flatButton,
		cliffButton,
		decalButton
	}

	self.toolSize = 0
	self:setMode(LandscapeToolPanel.MODE_FLAT)
end

function LandscapeToolPanel:increaseSize(distance)
	if distance > 0 then
		self.toolSize = math.max(self.toolSize + 1, -1)
	elseif distance < 0 then
		self.toolSize = math.max(self.toolSize - 1, -1)
	end

	self.sizeInput:setText(tostring(self.toolSize))
end

function LandscapeToolPanel:setMode(mode)
	self.mode = mode

	for i = 1, #self.buttons do
		local button = self.buttons[i]
		if button:getData('mode') == mode then
			button:setStyle(ButtonStyle({
				pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
				inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
				hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png",
				color = { 1, 1, 1, 1 },
				font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
				fontSize = 24,
				textShadow = true,
				padding = 4
			}, self.application:getUIView():getResources()))
		else
			button:setStyle(nil)
		end
	end
end

function LandscapeToolPanel:getMode()
	return self.mode
end

function LandscapeToolPanel:setToolSize(value)
	self.toolSize = math.max(value or self.toolSize, 0)
	self.sizeInput:setText(tostring(self.toolSize))
end

function LandscapeToolPanel:getToolSize()
	return self.toolSize
end

function LandscapeToolPanel:open(x, y, parent)
	local currentX, currentY = self:getPosition()
	self:setPosition(x or currentX, y or currentY)

	local root = parent or self.application:getUIView():getRoot()
	root:addChild(self)
end

function LandscapeToolPanel:close()
	local p = self:getParent()
	if p then
		p:removeChild(self)
	end
end

return LandscapeToolPanel
