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
CharacterCustomization.WIDTH = 480
CharacterCustomization.HEIGHT = 496
CharacterCustomization.TAB_SIZE = 48
CharacterCustomization.INPUT_HEIGHT = 64
CharacterCustomization.PADDING = 12
CharacterCustomization.DESCRIPTION_STYLE = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 32,
	textShadow = true
}
CharacterCustomization.VALUE_STYLE = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 24,
	textShadow = true
}
CharacterCustomization.SELECT_INACTIVE_BOX_BUTTON_STYLE = {
	inactive = Color(0, 0, 0, 0),
	pressed = Color(29 / 255, 25 / 255, 19 / 255, 1),
	hover = Color(147 / 255, 124 / 255, 94 / 255, 1),
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = 24,
	textX = 0.0,
	textY = 0.5,
	textAlign = 'left'
}
CharacterCustomization.SELECT_ACTIVE_BOX_BUTTON_STYLE = {
	inactive = Color(147 / 255, 124 / 255, 94 / 255, 1),
	pressed = Color(29 / 255, 25 / 255, 19 / 255, 1),
	hover = Color(147 / 255, 124 / 255, 94 / 255, 1),
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = 24,
	textX = 0.0,
	textY = 0.5,
	textAlign = 'left'
}

CharacterCustomization.ACTIVE_TAB_STYLE = function(icon)
	return {
		inactive = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
		hover = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
		pressed = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
		icon = { filename = string.format("Resources/Game/UI/Icons/%s.png", icon), x = 0.5, y = 0.5 }
	}
end

CharacterCustomization.INACTIVE_TAB_STYLE = function(icon)
	return {
		inactive = "Resources/Renderers/Widget/Button/Ribbon-Inactive.9.png",
		hover = "Resources/Renderers/Widget/Button/Ribbon-Hover.9.png",
		pressed = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
		icon = { filename = string.format("Resources/Game/UI/Icons/%s.png", icon), x = 0.5, y = 0.5 }
	}
end

function CharacterCustomization:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.window.getMode()
	self:setSize(CharacterCustomization.WIDTH, CharacterCustomization.HEIGHT)
	self:setPosition(
		(w - CharacterCustomization.WIDTH) / 2,
		(h - CharacterCustomization.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.onChangeSlot = Callback()
	self.onChangeGender = Callback()

	local contentWidth = CharacterCustomization.WIDTH
	local contentHeight = CharacterCustomization.HEIGHT - CharacterCustomization.TAB_SIZE - CharacterCustomization.PADDING * 3

	self.tabsLayout = GridLayout()
	do
		self.tabsLayout:setSize(CharacterCustomization.WIDTH, CharacterCustomization.TAB_SIZE + CharacterCustomization.PADDING * 2)
		self.tabsLayout:setUniformSize(
			true,
			CharacterCustomization.TAB_SIZE,
			CharacterCustomization.TAB_SIZE)
		self.tabsLayout:setPadding(CharacterCustomization.PADDING, CharacterCustomization.PADDING)
		self:addChild(self.tabsLayout)

		local tabButtons = {}
		local function addTab(tab, active, icon)
			local button = Button()
			button:setData('icon', icon)
			if active then
				button:setStyle(
					ButtonStyle(
						CharacterCustomization.ACTIVE_TAB_STYLE(icon),
						self:getView():getResources()))
			else
				button:setStyle(
					ButtonStyle(
						CharacterCustomization.INACTIVE_TAB_STYLE(icon),
						self:getView():getResources()))
			end
			self.tabsLayout:addChild(button)

			button.onClick:register(function()
				tabButtons[self.currentTab]:setStyle(
					ButtonStyle(
						CharacterCustomization.INACTIVE_TAB_STYLE(tabButtons[self.currentTab]:getData('icon')),
						self:getView():getResources()))
				button:setStyle(
					ButtonStyle(
						CharacterCustomization.ACTIVE_TAB_STYLE(icon),
						self:getView():getResources()))

				self:removeChild(self.tabs[self.currentTab].panel)
				self:addChild(self.tabs[tab].panel)
				self.currentTab = tab
			end)

			tabButtons[tab] = button
		end

		addTab('info', true, "Concepts/Identity")
		addTab('wardrobe', false, "Concepts/Appearance")
	end

	self.tabs = {}
	self.tabs.info = {}
	do
		local INPUT_WIDTH = contentWidth - CharacterCustomization.PADDING * 2
		local INPUT_HEIGHT = 32

		local info = self.tabs.info
		info.panel = ScrollablePanel(GridLayout)
		info.panel:getInnerPanel():setPadding(0, 0)
		info.panel:getInnerPanel():setSize(contentWidth, 0)
		info.panel:getInnerPanel():setWrapContents(true)
		info.panel:setSize(contentWidth, 0)
		info.panel:setPosition(0, CharacterCustomization.TAB_SIZE + CharacterCustomization.PADDING)

		-- title, name, gender (x3)
		local BASIC_HEIGHT = INPUT_HEIGHT * 7 + CharacterCustomization.PADDING * 5
		info.basic = GridLayout()
		info.basic:setSize(contentWidth, BASIC_HEIGHT)
		info.basic:setPadding(CharacterCustomization.PADDING, CharacterCustomization.PADDING)

		local basicTitleLabel = Label()
		basicTitleLabel:setText("Basics")
		basicTitleLabel:setStyle(LabelStyle(CharacterCustomization.DESCRIPTION_STYLE, self:getView():getResources()))
		basicTitleLabel:setSize(INPUT_WIDTH, INPUT_HEIGHT)
		info.basic:addChild(basicTitleLabel)

		local nameLabel = Label()
		nameLabel:setText("Name:")
		nameLabel:setStyle(LabelStyle(CharacterCustomization.VALUE_STYLE, self:getView():getResources()))
		nameLabel:setSize(INPUT_WIDTH, INPUT_HEIGHT)
		info.basic:addChild(nameLabel)

		local nameInput = TextInput()
		nameInput:setText(self:getView():getGame():getPlayer():getActor():getName())
		nameInput.onValueChanged:register(function()
			self:changeName(nameInput.text)
		end)
		nameInput:setSize(INPUT_WIDTH, INPUT_HEIGHT)
		info.basic:addChild(nameInput)

		local genderLabel = Label()
		genderLabel:setText("Gender:")
		genderLabel:setStyle(LabelStyle(CharacterCustomization.VALUE_STYLE, self:getView():getResources()))
		genderLabel:setSize(INPUT_WIDTH, INPUT_HEIGHT)
		info.basic:addChild(genderLabel)

		local genderSelect = ScrollablePanel(GridLayout)
		genderSelect:setScrollBarVisible(true, false)
		genderSelect:getInnerPanel():setPadding(0, 0)
		genderSelect:getInnerPanel():setUniformSize(true,
			INPUT_WIDTH,
			INPUT_HEIGHT)
		genderSelect:getInnerPanel():setSize(
			INPUT_WIDTH,
			INPUT_HEIGHT * 3)
		genderSelect:setSize(
			INPUT_WIDTH,
			INPUT_HEIGHT * 3)

		local function addGender(name, value)
			local button = Button()
			button:setText(name)
			button:setStyle(ButtonStyle(CharacterCustomization.SELECT_INACTIVE_BOX_BUTTON_STYLE, self:getView():getResources()))
			button:setSize(contentWidth - ScrollablePanel.DEFAULT_SCROLL_SIZE)
			button.onClick:register(self.changeGender, self, value)
			self.onChangeGender:register(function(newValue)
				if value == newValue then
					button:setStyle(ButtonStyle(CharacterCustomization.SELECT_ACTIVE_BOX_BUTTON_STYLE, self:getView():getResources()))
				else
					button:setStyle(ButtonStyle(CharacterCustomization.SELECT_INACTIVE_BOX_BUTTON_STYLE, self:getView():getResources()))
				end
			end)

			genderSelect:addChild(button)
		end

		addGender("- Male", 'male')
		addGender("- Female", 'female')
		addGender("- Other", 'x')

		info.basic:addChild(genderSelect)

		info.panel:addChild(info.basic)
		info.panel:setSize(contentWidth, contentHeight)
		info.panel:setScrollSize(info.panel:getInnerPanel():getSize())
	end

	self.tabs.wardrobe = {}
	do
		local wardrobe = self.tabs.wardrobe
		local LABEL_WIDTH = 96
		local ARROW_BUTTON_WIDTH = 64
		local ARROW_BUTTON_WIDTH = 64
		local VALUE_WIDTH = 196

		wardrobe.panel = Panel()
		wardrobe.panel:setStyle(PanelStyle({ image = false }, self:getView():getResources()))
		wardrobe.panel:setSize(contentWidth, contentHeight)
		wardrobe.panel:setPosition(
			CharacterCustomization.PADDING,
			CharacterCustomization.TAB_SIZE + CharacterCustomization.PADDING)

		local gridLayout = GridLayout()
		gridLayout:setSize(contentWidth, contentHeight)
		gridLayout:setPadding(4, 4)
		wardrobe.panel:addChild(gridLayout)

		wardrobe.peep = SceneSnippet()
		wardrobe.peep:setSize(
			VALUE_WIDTH,
			contentHeight - CharacterCustomization.PADDING * 2)
		wardrobe.peep:setPosition(
			ARROW_BUTTON_WIDTH + LABEL_WIDTH + CharacterCustomization.PADDING * 2,
			CharacterCustomization.PADDING)
		wardrobe.panel:addChild(wardrobe.peep)

		local function addOption(description, slot)
			local descriptionLabel = Label()
			descriptionLabel:setText(description .. ":")
			descriptionLabel:setStyle(LabelStyle(CharacterCustomization.DESCRIPTION_STYLE, self:getView():getResources()))
			descriptionLabel:setSize(LABEL_WIDTH, CharacterCustomization.INPUT_HEIGHT)
			gridLayout:addChild(descriptionLabel)

			local descriptionPrev = Button()
			descriptionPrev:setSize(ARROW_BUTTON_WIDTH, CharacterCustomization.INPUT_HEIGHT)
			descriptionPrev:setText("<")
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
			gridLayout:addChild(descriptionNext)
		end

		addOption("Hair", "hair")
		addOption("Eyes", "eyes")
		addOption("Head", "head")
		addOption("Body", "body")
		addOption("Hands", "hands")
		addOption("Feet", "feet")
	end

	self:addChild(self.tabs.info.panel)
	self:setSize(CharacterCustomization.WIDTH, CharacterCustomization.HEIGHT)

	self.camera = ThirdPersonCamera()
	self.camera:setDistance(2.5)
	self.camera:setUp(Vector(0, -1, 0))
	self.tabs.wardrobe.peep:setCamera(self.camera)

	self.currentTab = 'info'

	self.closeButton = Button()
	self.closeButton:setSize(CharacterCustomization.TAB_SIZE, CharacterCustomization.TAB_SIZE)
	self.closeButton:setPosition(CharacterCustomization.WIDTH - CharacterCustomization.TAB_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	self.ready = false
end

function CharacterCustomization:update(...)
	Interface.update(self, ...)

	if not self.ready then
		local state = self:getState()
		self.onChangeGender(state.gender)
		self.ready = true
	end

	self:updatePeep()
end

function CharacterCustomization:updatePeep()
	local state = self:getState()

	local gameCamera = self:getView():getGameView():getRenderer():getCamera()
	self.camera:setHorizontalRotation(gameCamera:getHorizontalRotation())
	self.camera:setVerticalRotation(gameCamera:getVerticalRotation())

	local actor = self:getView():getGame():getPlayer():getActor()
	do
		local gameView = self:getView():getGameView()
		local actorView = gameView:getActor(actor)
		self.tabs.wardrobe.peep:setRoot(actorView:getSceneNode())
	end

	local offset
	local zoom
	if actor then
		local min, max = actor:getBounds()
		offset = (max.y - min.y) / 2 - 0.5
		zoom = (max.z - min.z) + math.max((max.y - min.y), (max.x - min.x)) + 4

		-- Flip if facing left.
		if actor:getDirection().x < 0 then
			self.camera:setVerticalRotation(
				self.camera:getVerticalRotation() + math.pi)
		end
	else
		offset = 0
		zoom = 1
	end

	local root = self.tabs.wardrobe.peep:getRoot()
	local transform = root:getTransform():getGlobalTransform()

	local x, y, z = transform:transformPoint(0, offset, 0)

	local w, h = self.tabs.wardrobe.peep:getSize()
	self.camera:setWidth(w)
	self.camera:setHeight(h)
	self.camera:setPosition(Vector(x, y, z))
	self.camera:setDistance(zoom)
end

function CharacterCustomization:previousWardrobe(slot)
	self:sendPoke("previousWardrobe", nil, {
		slot = slot
	})
end

function CharacterCustomization:nextWardrobe(slot)
	self:sendPoke("nextWardrobe", nil, {
		slot = slot
	})
end

function CharacterCustomization:changeSlot(slot, value)
	self.onChangeSlot(slot, value)
end

function CharacterCustomization:changeGender(value)
	self.onChangeGender(value)
	self:sendPoke("changeGender", nil, {
		gender = value
	})
end

function CharacterCustomization:changeName(value)
	self:sendPoke("changeName", nil, {
		name = value
	})
end

return CharacterCustomization
