--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/CraftWindow2.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Config = require "ItsyScape.Game.Config"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local Button = require "ItsyScape.UI.Button"
local CloseButton = require "ItsyScape.UI.CloseButton"
local Icon = require "ItsyScape.UI.Icon"
local Interface = require "ItsyScape.UI.Interface"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local GamepadToolTip = require "ItsyScape.UI.GamepadToolTip"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local CraftCategoriesContentTab = require "ItsyScape.UI.Interfaces.Components.CraftCategoriesContentTab"
local CraftItemsContentTab = require "ItsyScape.UI.Interfaces.Components.CraftItemsContentTab"
local CraftInfoContentTab = require "ItsyScape.UI.Interfaces.Components.CraftInfoContentTab"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"
local MakeContentTab = require "ItsyScape.UI.Interfaces.Components.MakeContentTab"

local CraftWindow = Class(Interface)

CraftWindow.TITLE_HEIGHT = 128
CraftWindow.PADDING = 8

CraftWindow.BACK_BUTTON_WIDTH = 104
CraftWindow.BACK_BUTTON_HEIGHT = 48
CraftWindow.BACK_BUTTON_ICON_SIZE = 24

CraftWindow.CONTENT_WIDTH = GamepadContentTab.WIDTH * 2 + CraftWindow.PADDING * 3
CraftWindow.CONTENT_HEIGHT = GamepadContentTab.HEIGHT + CraftWindow.PADDING * 2

CraftWindow.CONTENT_LAYOUT_WIDTH = GamepadContentTab.WIDTH * 4 + CraftWindow.PADDING * 5 * 2

CraftWindow.WIDTH = CraftWindow.CONTENT_WIDTH
CraftWindow.HEIGHT = CraftWindow.TITLE_HEIGHT + CraftWindow.PADDING + CraftWindow.CONTENT_HEIGHT

CraftWindow.TITLE_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowTitle.png"
}

CraftWindow.CONTENT_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowContent.png"
}

CraftWindow.TITLE_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	color = { 1, 1, 1, 1 },
	textShadow = true
}

CraftWindow.SCROLL_SPEED_UNITS = GamepadContentTab.WIDTH
CraftWindow.SCROLL_SPEED_DURATION = 0.25

function CraftWindow:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self:setSize(self.WIDTH, self.HEIGHT)
	self:setData(GamepadSink, GamepadSink())

	self.titlePanel = Panel()
	self.titlePanel:setSize(self.WIDTH, self.TITLE_HEIGHT)
	self.titlePanel:setStyle(self.TITLE_PANEL_STYLE, PanelStyle)
	self:addChild(self.titlePanel)

	self.propSnippet = SceneSnippet()
	self.propSnippet:setSize(
		self.TITLE_HEIGHT - self.PADDING * 2,
		self.TITLE_HEIGHT - self.PADDING * 2)
	self.propSnippet:setPosition(
		self.PADDING,
		self.PADDING)

	local parentNode = SceneNode()
	local ambientLight = AmbientLightSceneNode()
	ambientLight:setAmbience(1)
	ambientLight:setParent(parentNode)

	self.propSnippet:setParentNode(parentNode)
	self.propSnippet:setRoot(parentNode)

	self.camera = ThirdPersonCamera()
	self.propSnippet:setCamera(self.camera)

	self.titleLabel = Label()
	self.titleLabel:setStyle(self.TITLE_LABEL_STYLE, LabelStyle)
	self.titleLabel:setPosition(self.PADDING, self.PADDING / 2)
	self.titlePanel:addChild(self.titleLabel)

	self.contentPanel = Panel()
	self.contentPanel:setSize(self.WIDTH, self.CONTENT_HEIGHT)
	self.contentPanel:setPosition(0, self.TITLE_HEIGHT)
	self.contentPanel:setStyle(self.CONTENT_PANEL_STYLE, PanelStyle)
	self.contentPanel:setScrollSize(self.CONTENT_LAYOUT_WIDTH, self.CONTENT_HEIGHT)
	self:addChild(self.contentPanel)

	self.contentLayout = GridLayout()
	self.contentLayout:setSize(self.CONTENT_LAYOUT_WIDTH, self.CONTENT_HEIGHT)
	self.contentLayout:setPadding(self.PADDING * 2, 0)
	self.contentLayout:setEdgePadding(false)
	self.contentLayout:setUniformSize(true, GamepadContentTab.WIDTH, GamepadContentTab.HEIGHT)
	self.contentLayout:setPosition((self.WIDTH - self.CONTENT_WIDTH) / 2, self.PADDING)
	self.contentPanel:addChild(self.contentLayout)

	self.craftCategoriesContentTab = CraftCategoriesContentTab(self)
	self.craftCategoriesContentTab.onCategorySelected:register(self.onSelectCategory, self)

	self.craftItemsContentTab = CraftItemsContentTab(self)
	self.craftItemsContentTab.onGamepadRelease:register(
		self.onBack,
		self,
		self.craftCategoriesContentTab)
	self.craftItemsContentTab.onItemSelected:register(self.selectItem, self)

	self.craftInfoContentTab = CraftInfoContentTab(self)
	self.makeContentTab = MakeContentTab(self)
	self.makeContentTab.onGamepadRelease:register(
		self.onBack,
		self,
		self.craftItemsContentTab)

	self.contentLayout:addChild(self.craftCategoriesContentTab)
	self.contentLayout:addChild(self.craftItemsContentTab)
	self.contentLayout:addChild(self.craftInfoContentTab)
	self.contentLayout:addChild(self.makeContentTab)

	self:performLayout()

	self.contentTabScrollYDirection = 0
	self.contentLayoutTargetScrollX = 0
	self.currentContentTarget = self.craftCategoriesContentTab

	self.closeButton = CloseButton()
	self.closeButton:setPosition(self.WIDTH - self.PADDING - CloseButton.DEFAULT_SIZE, self.PADDING)
	self.closeButton.onClick:register(self.onCloseButtonClicked, self)
	self.titlePanel:addChild(self.closeButton)

	self.backButton = Button()
	self.backButton:setSize(self.BACK_BUTTON_WIDTH, self.BACK_BUTTON_HEIGHT)
	self.backButton:setPosition(self.WIDTH - CloseButton.DEFAULT_SIZE - self.PADDING * 2 - self.BACK_BUTTON_WIDTH, self.PADDING)
	self.backButton.onClick:register(self.onBackButtonPress, self)

	local backButtonLabel = Label()
	backButtonLabel:setPosition(self.BACK_BUTTON_ICON_SIZE + self.PADDING * 2, self.PADDING)
	backButtonLabel:setSize(self.BACK_BUTTON_WIDTH - self.BACK_BUTTON_ICON_SIZE + self.PADDING * 3, self.BACK_BUTTON_HEIGHT)
	backButtonLabel:setText("Back")
	self.backButton:addChild(backButtonLabel)

	local backButtonIcon = Icon()
	backButtonIcon:setIcon("Resources/Game/UI/Icons/Common/Back.png")
	backButtonIcon:setSize(self.BACK_BUTTON_ICON_SIZE, self.BACK_BUTTON_ICON_SIZE)
	backButtonIcon:setPosition(self.PADDING, (self.BACK_BUTTON_HEIGHT - self.BACK_BUTTON_ICON_SIZE) / 2)
	self.backButton:addChild(backButtonIcon)

	self.closeKeybindInfo = GamepadToolTip()
	self.closeKeybindInfo:setHasBackground(false)
	self.closeKeybindInfo:setKeybind("gamepadOpenRibbon")
	self.closeKeybindInfo:setText("Close")
	self.closeKeybindInfo:setPosition(
		self.WIDTH - 128,
		CloseButton.DEFAULT_SIZE)

	self.backKeybindInfo = GamepadToolTip()
	self.backKeybindInfo:setHasBackground(false)
	self.backKeybindInfo:setKeybind("gamepadBack")
	self.backKeybindInfo:setText("Back")
	self.backKeybindInfo:setPosition(
		self.WIDTH - 128,
		CloseButton.DEFAULT_SIZE + GamepadToolTip.BUTTON_SIZE)
end

function CraftWindow:close()
	self:sendPoke("close", nil, {})
end

function CraftWindow:gamepadRelease(joystick, button)
	local inputProvider = self:getInputProvider()
	if inputProvider and inputProvider:isCurrentJoystick(joystick) then
		if button == inputProvider:getKeybind("gamepadOpenRibbon") then
			self:close()
		end
	end

	Interface.gamepadRelease(self, joystick, button)
end

function CraftWindow:gamepadAxis(joystick, axis, value)
	local axisSensitivity = Config.get("Input", "KEYBIND", "type", "ui", "name", "axisSensitivity")
	local scrollYAxis = Config.get("Input", "KEYBIND", "type", "ui", "name", "scrollYAxis")


	local inputProvider = self:getInputProvider()
	if inputProvider and inputProvider:isCurrentJoystick(joystick) then
		if axis == scrollYAxis then
			if math.abs(value) > axisSensitivity then
				self.contentTabScrollYDirection = value
			else
				self.contentTabScrollYDirection = 0
			end
		end
	end
end

function CraftWindow:setFocusedTab(focusedTab, scrolledTab)
	self.contentLayoutTargetScrollX = (scrolledTab or focusedTab):getPosition()
	self.currentContentTarget = focusedTab
	self:focusChild(focusedTab)
end

function CraftWindow:onBack(tab, _, joystick, button)
	local inputProvider = self:getInputProvider()
	if inputProvider and inputProvider:isCurrentJoystick(joystick) then
		if button == inputProvider:getKeybind("gamepadBack") then
			self:setFocusedTab(tab)
		end
	end
end

function CraftWindow:onSelectCategory(_, categoryIndex)
	self.craftCategoriesContentTab:setActiveCategoryIndex(categoryIndex)
	self:setFocusedTab(self.craftItemsContentTab)

	self.currentCraftItemIndex = -1
end

function CraftWindow:selectItem(_, itemIndex)
	self.currentItemIndex = itemIndex
	self:setFocusedTab(self.makeContentTab, self.craftInfoContentTab)

	local categoryIndex = self.craftCategoriesContentTab:getCurrentCategoryIndex()
	local state = self:getState()
	local items = state.groups[categoryIndex]
	local item = items and items[itemIndex]

	if item then
		self.makeContentTab:refresh(item)
	end
end

function CraftWindow:onCloseButtonClicked(_, index)
	if index == 1 then
		self:close()
	end
end

function CraftWindow:onBackButtonPress()
	if self.currentContentTarget == self.craftItemsContentTab then
		self:setFocusedTab(self.craftCategoriesContentTab)
	elseif self.currentContentTarget == self.makeContentTab then
		self:setFocusedTab(self.craftItemsContentTab)
	end
end

function CraftWindow:attach()
	Interface.attach(self)

	self:tick()
	self:focusChild(self.craftCategoriesContentTab)

	local state = self:getState()
	self.titleLabel:setText(state.action.verb)
end

function CraftWindow:performLayout()
	Interface.performLayout(self)

	local width, height = itsyrealm.graphics.getScaledMode()
	local selfWidth, selfHeight = self:getSize()
	self:setPosition((width - selfWidth) / 2, (height - selfHeight) / 2)
end

function CraftWindow:tick()
	Interface.tick(self)

	local state = self:getState()
	self.craftCategoriesContentTab:refresh(state)
	self.craftItemsContentTab:refresh({
		index = self.craftCategoriesContentTab:getCurrentCategoryIndex(),
		group = state.groups[self.craftCategoriesContentTab:getCurrentCategoryIndex()] or {}
	})
end

function CraftWindow:updateTitleScene()
	local gameView = self:getView():getGameView()

	local state = self:getState()

	local targetType
	local targetID
	if not state.target or state.target.type == "none" then
		targetType = "actor"
		targetID = gameView:getGame():getPlayer():getActor():getID()
	else
		targetType = state.target.type
		targetID = state.target.id
	end

	local node, min, max
	if targetType == "actor" then
		local actor = gameView:getActorByID(targetID)
		local actorView = actor and gameView:getActor(actor)

		node = actorView and actorView:getSceneNode()
		if actor then
			min, max = actor:getBounds()
		end
	elseif targetType == "prop" then
		local prop = gameView:getPropByID(targetID)
		local propView = prop and gameView:getProp(prop)

		node = propView and propView:getRoot()
		if prop then
			min, max = prop:getBounds()
		end
	end

	if not node then
		if self.propSnippet:getParent() then
			self.propSnippet:getParent():removeChild(self.propSnippet)
		end

		return
	end

	if self.propSnippet:getParent() ~= self.titlePanel then
		self.titlePanel:addChild(self.propSnippet)
	end

	local offset = Vector.UNIT_Y
	local distance = math.max(max.x - min.x, max.y - min.y, max.z - min.z)

	self.propSnippet:setChildNode(node)
	self.camera:copy(gameView:getCamera())
	self.camera:setPosition(Vector.ZERO:transform(node:getTransform():getGlobalTransform(_APP:getFrameDelta())) + offset)
	self.camera:setDistance(distance * 2 + 2)
end

function CraftWindow:updateControls()
	local inputProvider = self:getInputProvider()
	if inputProvider then
		if not inputProvider:getCurrentJoystick() then
			self.contentTabScrollYDirection = 0

			if self.closeKeybindInfo:getParent() then
				self.closeKeybindInfo:getParent():removeChild(self.closeKeybindInfo)
			end

			if self.backKeybindInfo:getParent() then
				self.backKeybindInfo:getParent():removeChild(self.backKeybindInfo)
			end

			if self.currentContentTarget ~= self.craftCategoriesContentTab then
				if self.backButton:getParent() ~= self.titlePanel then
					self.titlePanel:addChild(self.backButton)
				end
			else
				if self.backButton:getParent() then
					self.backButton:getParent():removeChild(self.backButton)
				end
			end
		else
			if self.closeKeybindInfo:getParent() ~= self.titlePanel then
				self.titlePanel:addChild(self.closeKeybindInfo)
			end

			if self.currentContentTarget ~= self.craftCategoriesContentTab then
				if self.backKeybindInfo:getParent() ~= self.titlePanel then
					self.titlePanel:addChild(self.backKeybindInfo)
				end
			else
				if self.backKeybindInfo:getParent() then
					self.backKeybindInfo:getParent():removeChild(self.backKeybindInfo)
				end
			end
		end
	end
end

function CraftWindow:updateScroll(delta)
	local scrollValue = self.contentTabScrollYDirection * delta

	self.craftInfoContentTab:gamepadScroll(0, -scrollValue)
	self.makeContentTab:gamepadScroll(0, -scrollValue)
end

function CraftWindow:update(delta)
	Interface.update(self, delta)

	local currentScrollX, currentScrollY = self.contentLayout:getScroll()
	local scrollOffsetX = delta * (self.SCROLL_SPEED_UNITS / self.SCROLL_SPEED_DURATION)

	if self.contentLayoutTargetScrollX < currentScrollX then
		currentScrollX = math.max(currentScrollX - scrollOffsetX, self.contentLayoutTargetScrollX)
	elseif self.contentLayoutTargetScrollX > currentScrollX then
		currentScrollX = math.min(currentScrollX + scrollOffsetX, self.contentLayoutTargetScrollX)
	end

	self.contentLayout:setScroll(currentScrollX, currentScrollY)

	if self.currentCraftItemIndex ~= self.craftItemsContentTab:getCurrentItemIndex() then
		self.currentCraftItemIndex = self.craftItemsContentTab:getCurrentItemIndex()

		local categoryIndex = self.craftCategoriesContentTab:getCurrentCategoryIndex()
		local state = self:getState()
		local items = state.groups[categoryIndex]
		local item = items and items[self.currentCraftItemIndex]

		if item then
			self.craftInfoContentTab:refresh(item)
		end
	end

	self:updateTitleScene()
	self:updateControls()
	self:updateScroll(delta)
end

return CraftWindow
