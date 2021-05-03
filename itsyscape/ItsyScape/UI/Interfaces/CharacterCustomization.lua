--------------------------------------------------------------------------------
-- ItsyScape/UI/CharacterCustomization.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Interface = require "ItsyScape.UI.Interface"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local TextInput = require "ItsyScape.UI.TextInput"
local Widget = require "ItsyScape.UI.Widget"

local CharacterCustomization = Class(Interface)

CharacterCustomization.BUTTON_SIZE = 48
CharacterCustomization.PADDING = 16
CharacterCustomization.CUSTOMIZATION_WIDTH = 480
CharacterCustomization.CUSTOMIZATION_HEIGHT = 544
CharacterCustomization.INPUT_HEIGHT = 64

CharacterCustomization.BUTTON_STYLE = {
	inactive = "Resources/Renderers/Widget/Button/Purple-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/Purple-Hover.9.png",
	pressed = "Resources/Renderers/Widget/Button/Purple-Pressed.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 24
}

CharacterCustomization.ACTIVE_BUTTON_STYLE = {
	inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png",
	pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 24
}

CharacterCustomization.DESCRIPTION_STYLE = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 32,
	textShadow = true
}

function CharacterCustomization:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(w, h)

	self.panel = Panel()
	self.panel:setSize(w, h)
	self.panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/FullscreenInterface.9.png"
	}, ui:getResources()))
	self:addChild(self.panel)

	do
		local LABEL_WIDTH = 96
		local ARROW_BUTTON_WIDTH = 64
		local ARROW_BUTTON_WIDTH = 64
		local VALUE_WIDTH = 196

		local panel = Panel()
		panel:setStyle(PanelStyle({ image = false }, self:getView():getResources()))
		panel:setSize(CharacterCustomization.CUSTOMIZATION_WIDTH, CharacterCustomization.CUSTOMIZATION_HEIGHT)
		panel:setPosition(
			CharacterCustomization.PADDING,
			CharacterCustomization.BUTTON_SIZE + CharacterCustomization.PADDING)

		local gridLayout = GridLayout()
		gridLayout:setSize(CharacterCustomization.CUSTOMIZATION_WIDTH, CharacterCustomization.CUSTOMIZATION_HEIGHT)
		gridLayout:setPadding(4, 4)
		panel:addChild(gridLayout)

		self.peepSnippet = SceneSnippet()
		self.peepSnippet:setSize(
			VALUE_WIDTH,
			CharacterCustomization.CUSTOMIZATION_HEIGHT - CharacterCustomization.PADDING * 2)
		self.peepSnippet:setPosition(
			ARROW_BUTTON_WIDTH + LABEL_WIDTH + CharacterCustomization.PADDING * 2,
			CharacterCustomization.PADDING)
		panel:addChild(self.peepSnippet)

		local function addOption(description, slot)
			local descriptionLabel = Label()
			descriptionLabel:setText(description .. ":")
			descriptionLabel:setStyle(LabelStyle(CharacterCustomization.DESCRIPTION_STYLE, self:getView():getResources()))
			descriptionLabel:setSize(LABEL_WIDTH, CharacterCustomization.INPUT_HEIGHT)
			gridLayout:addChild(descriptionLabel)

			local descriptionPrev = Button()
			descriptionPrev:setSize(ARROW_BUTTON_WIDTH, CharacterCustomization.INPUT_HEIGHT)
			descriptionPrev:setText("<")
			descriptionPrev:setStyle(ButtonStyle(CharacterCustomization.BUTTON_STYLE, ui:getResources()))
			descriptionPrev.onClick:register(self.previousWardrobe, self, slot)
			gridLayout:addChild(descriptionPrev)

			local panel = Panel()
			panel:setSize(VALUE_WIDTH, CharacterCustomization.INPUT_HEIGHT)
			panel:setStyle(PanelStyle({ image = false }, self:getView():getResources()))
			gridLayout:addChild(panel)

			local descriptionNext = Button()
			descriptionNext:setSize(ARROW_BUTTON_WIDTH, CharacterCustomization.INPUT_HEIGHT)
			descriptionNext:setText(">")
			descriptionNext.onClick:register(self.nextWardrobe, self, slot)
			descriptionNext:setStyle(ButtonStyle(CharacterCustomization.BUTTON_STYLE, ui:getResources()))
			gridLayout:addChild(descriptionNext)
		end

		addOption("Hair", "hair")
		addOption("Eyes", "eyes")
		addOption("Head", "head")
		addOption("Body", "body")
		addOption("Hands", "hands")
		addOption("Feet", "feet")

		self:addChild(panel)
	end

	self.closeButton = Button()
	self.closeButton:setStyle(ButtonStyle(CharacterCustomization.BUTTON_STYLE, ui:getResources()))
	self.closeButton:setSize(CharacterCustomization.BUTTON_SIZE, CharacterCustomization.BUTTON_SIZE)
	self.closeButton:setPosition(w - CharacterCustomization.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	self.onChangeSlot = Callback()
	self.onChangeGender = Callback()

	self.camera = ThirdPersonCamera()
	self.camera:setDistance(2.5)
	self.camera:setUp(Vector(0, -1, 0))
end

return CharacterCustomization
