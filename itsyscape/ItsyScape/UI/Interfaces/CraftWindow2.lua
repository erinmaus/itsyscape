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
local Theme = require "ItsyScape.UI.Interfaces.Theme"
local ArtisanInfoContentTab = require "ItsyScape.UI.Interfaces.Components.ArtisanInfoContentTab"
local CraftCategoriesContentTab = require "ItsyScape.UI.Interfaces.Components.CraftCategoriesContentTab"
local CraftItemsContentTab = require "ItsyScape.UI.Interfaces.Components.CraftItemsContentTab"
local CraftInfoContentTab = require "ItsyScape.UI.Interfaces.Components.CraftInfoContentTab"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"
local MakeContentTab = require "ItsyScape.UI.Interfaces.Components.MakeContentTab"

local CraftWindow = Class(Interface)

CraftWindow.BACK_BUTTON_WIDTH = 104
CraftWindow.BACK_BUTTON_HEIGHT = Theme.DEFAULT_BUTTON_SIZE
CraftWindow.BACK_BUTTON_ICON_SIZE = 24

CraftWindow.CONTENT_LAYOUT_WIDTH = Theme.calculateTiledSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, GamepadContentTab.WIDTH, 5)

CraftWindow.SCROLL_SPEED_UNITS = GamepadContentTab.WIDTH
CraftWindow.SCROLL_SPEED_DURATION = 0.25

function CraftWindow:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self:setSize(Theme.CONTENT_WINDOW_WIDTH, Theme.CONTENT_WINDOW_HEIGHT)
	self:setData(GamepadSink, GamepadSink({ isBlockingRibbon = true }))

	self.titlePanel, self.titleLabel = Theme.newMiniTitlePanelWithLabel(self, Theme.CONTENT_WINDOW_WIDTH)
	self.closeButton = Theme.newCloseButton(self.titlePanel)

	self.contentPanel = Theme.newContentPanel(self, Theme.CONTENT_WINDOW_WIDTH, Theme.CONTENT_WINDOW_HEIGHT, self.titlePanel)
	self.contentPanel:setScrollSize(self.CONTENT_LAYOUT_WIDTH, Theme.calculateSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.CONTENT_HEIGHT))

	self.contentLayout = GridLayout()
	self.contentLayout:setSize(self.CONTENT_LAYOUT_WIDTH, Theme.calculateSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.CONTENT_HEIGHT))
	self.contentLayout:setPadding(Theme.DEFAULT_OUTER_PADDING, 0)
	self.contentLayout:setEdgePadding(false, false)
	self.contentLayout:setUniformSize(true, GamepadContentTab.WIDTH, GamepadContentTab.HEIGHT)
	self.contentLayout:setPosition(0, Theme.DEFAULT_OUTER_PADDING)
	self.contentPanel:addChild(self.contentLayout)

	self.artisanInfoContentTab = ArtisanInfoContentTab(self)

	self.craftCategoriesContentTab = CraftCategoriesContentTab(self)
	self.craftCategoriesContentTab.onCategorySelected:register(self.onSelectCategory, self)
	self.craftCategoriesContentTab.onGamepadScroll:register(self._propagateScrollArtisanInfo, self)
	self.craftCategoriesContentTab.onGamepadRelease:register(
		self.onBack,
		self,
		self.artisanInfoContentTab)

	self.craftItemsContentTab = CraftItemsContentTab(self)
	self.craftItemsContentTab.onGamepadRelease:register(
		self.onBack,
		self,
		self.craftCategoriesContentTab)
	self.craftItemsContentTab.onItemSelected:register(self.selectItem, self)
	self.craftItemsContentTab.onGamepadScroll:register(self._propagateScrollCraftInfo, self)

	self.craftInfoContentTab = CraftInfoContentTab(self)
	self.makeContentTab = MakeContentTab(self)
	self.makeContentTab.onGamepadRelease:register(
		self.onBack,
		self,
		self.craftItemsContentTab)

	self.contentLayout:addChild(self.artisanInfoContentTab)
	self.contentLayout:addChild(self.craftCategoriesContentTab)
	self.contentLayout:addChild(self.craftItemsContentTab)
	self.contentLayout:addChild(self.craftInfoContentTab)
	self.contentLayout:addChild(self.makeContentTab)

	self:performLayout()

	self.contentTabScrollYDirection = 0
	self.contentLayoutTargetScrollX = 0
	self.currentContentTarget = self.artisanInfoContentTab

	self.backButton = Button()
	self.backButton:setSize(self.BACK_BUTTON_WIDTH, self.BACK_BUTTON_HEIGHT)
	self.backButton:setPosition(
		Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.CONTENT_WINDOW_WIDTH, CloseButton.DEFAULT_SIZE, self.BACK_BUTTON_WIDTH),
		Theme.DEFAULT_OUTER_PADDING)
	self.backButton.onClick:register(self.onBackButtonPress, self)

	local backButtonLabel = Label()
	backButtonLabel:setPosition(
		Theme.calculateSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, self.BACK_BUTTON_ICON_SIZE),
		Theme.DEFAULT_OUTER_PADDING)
	backButtonLabel:setText("Back")
	self.backButton:addChild(backButtonLabel)

	local backButtonIcon = Icon()
	backButtonIcon:setIcon("Resources/Game/UI/Icons/Common/Back.png")
	backButtonIcon:setSize(self.BACK_BUTTON_ICON_SIZE, self.BACK_BUTTON_ICON_SIZE)
	backButtonIcon:setPosition(Theme.DEFAULT_OUTER_PADDING, (self.BACK_BUTTON_HEIGHT - self.BACK_BUTTON_ICON_SIZE) / 2)
	self.backButton:addChild(backButtonIcon)

	self.closeKeybindInfo = GamepadToolTip()
	self.closeKeybindInfo:setHasBackground(false)
	self.closeKeybindInfo:setKeybind(GamepadToolTip.INPUT_SCHEME_GAMEPAD, "gamepadOpenRibbon")
	self.closeKeybindInfo:setText("Close")
	self.closeKeybindInfo:setPosition(
		Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.CONTENT_WINDOW_WIDTH, CloseButton.DEFAULT_SIZE, 128),
		(Theme.MINI_TITLE_HEIGHT - Theme.calculateSizeWithPadding(GamepadToolTip.PADDING, GamepadToolTip.BUTTON_SIZE)) / 2)

	self.backKeybindInfo = GamepadToolTip()
	self.backKeybindInfo:setHasBackground(false)
	self.backKeybindInfo:setKeybind(GamepadToolTip.INPUT_SCHEME_GAMEPAD, "gamepadBack")
	self.backKeybindInfo:setText("Back")
	self.backKeybindInfo:setPosition(
		Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.CONTENT_WINDOW_WIDTH, CloseButton.DEFAULT_SIZE, 128),
		(Theme.MINI_TITLE_HEIGHT - Theme.calculateSizeWithPadding(GamepadToolTip.PADDING, GamepadToolTip.BUTTON_SIZE)) / 2)
end

function CraftWindow:close()
	self:sendPoke("close", nil, {})
end

function CraftWindow:restoreFocus()
	if self.currentContentTarget == self.artisanInfoContentTab then
		self:focusChild(self.craftCategoriesContentTab)
	else
		self:focusChild(self.currentContentTarget)
	end
end

function CraftWindow:previewControlUp(control)
	Interface.previewControlUp(self, control)

	if control:is("openRibbon") then
		self:close()
	end
end

function CraftWindow:setFocusedTab(focusedTab, scrolledTab)
	self.contentLayoutTargetScrollX = (scrolledTab or focusedTab):getPosition()
	self.currentContentTarget = focusedTab

	if focusedTab == self.artisanInfoContentTab then
		self:focusChild(self.craftCategoriesContentTab)
	else
		self:focusChild(focusedTab)
	end
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

function CraftWindow:onBackButtonPress()
	if self.currentContentTarget == self.craftCategoriesContentTab then
		self:setFocusedTab(self.artisanInfoContentTab)
		self:focusChild(self.craftCategoriesContentTab)
	elseif self.currentContentTarget == self.craftItemsContentTab then
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

function CraftWindow:refresh(state)
	Interface.refresh(self, state)

	self.artisanInfoContentTab:refresh(state)
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

function CraftWindow:updateControls()
	local inputScheme = self:getView():getCurrentInputScheme()

	if inputScheme ~= GamepadToolTip.INPUT_SCHEME_GAMEPAD then
		self.contentTabScrollYDirection = 0

		if self.backKeybindInfo:getParent() then
			self.backKeybindInfo:getParent():removeChild(self.backKeybindInfo)
		end

		if self.currentContentTarget ~= self.artisanInfoContentTab then
			if self.backButton:getParent() ~= self.titlePanel then
				self.titlePanel:addChild(self.backButton)
			end
		else
			if self.backButton:getParent() then
				self.backButton:getParent():removeChild(self.backButton)
			end
		end
	else
		if self.backButton:getParent() then
			self.backButton:getParent():removeChild(self.backButton)
		end

		if self.currentContentTarget ~= self.artisanInfoContentTab then
			if self.backKeybindInfo:getParent() ~= self.titlePanel then
				self.titlePanel:addChild(self.backKeybindInfo)
			end

			if self.closeKeybindInfo:getParent() then
				self.closeKeybindInfo:getParent():removeChild(self.closeKeybindInfo)
			end
		else
			if self.backKeybindInfo:getParent() then
				self.backKeybindInfo:getParent():removeChild(self.backKeybindInfo)
			end

			if self.closeKeybindInfo:getParent() ~= self.titlePanel then
				self.titlePanel:addChild(self.closeKeybindInfo)
			end
		end
	end
end

function CraftWindow:_propagateScrollArtisanInfo(_, x, y)
	self.artisanInfoContentTab:gamepadScroll(x, y)
end

function CraftWindow:_propagateScrollCraftInfo(_, x, y)
	self.craftInfoContentTab:gamepadScroll(x, y)
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

	self:updateControls()
end

return CraftWindow
