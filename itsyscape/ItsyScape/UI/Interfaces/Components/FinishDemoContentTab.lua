--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/FinishDemoContentTab.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Config = require "ItsyScape.Game.Config"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Icon = require "ItsyScape.UI.Icon"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local Theme = require "ItsyScape.UI.Interfaces.Theme"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"
local StatBar = require "ItsyScape.UI.Interfaces.Components.StatBar"

local FinishDemoContentTab = Class(GamepadContentTab)

FinishDemoContentTab.PROMPT_LABEL_STYLE = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/Serif/Regular.ttf",
	fontSize = 26,
	textShadow = true,
	center = true,
	align = "center"
}

FinishDemoContentTab.GROUP_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowGroup.png"
}

FinishDemoContentTab.WISHLIST_CTA_LINK = "https://store.steampowered.com/app/1662510/ItsyRealm/"
FinishDemoContentTab.DISCORD_CTA_LINK = "https://discord.gg/ItsyRealm"

function FinishDemoContentTab:new(interface)
	GamepadContentTab.new(self, interface)

	local buttonWidth = Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, self.WIDTH)
	local buttonHeight = Theme.calculateSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_ICON_SIZE)

	self.layout = GamepadGridLayout()
	self.layout:setSize(self:getSize())
	self.layout:setPadding(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	self.layout:setWrapContents(true)
	self.layout.onWrapFocus:register(self._onButtonsWrapFocus, self)
	self:addChild(self.layout)

	self.wishlistPrompt = Label()
	self.wishlistPrompt:setText(self:T("ui.demo.wishlistCTA"))
	self.wishlistPrompt:setStyle(self.PROMPT_LABEL_STYLE, LabelStyle)
	self.wishlistPrompt:setSize(
		buttonWidth,
		Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, Theme.calculateTiledSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, buttonHeight, 2)))
	self.layout:addChild(self.wishlistPrompt)

	self.wishlistButton = Button()
	self.wishlistButton:setSize(buttonWidth, buttonHeight)
	self.wishlistButton.onClick:register(self._onClickWishlistButton, self)
	self.layout:addChild(self.wishlistButton)

	self.discordPrompt = Label()
	self.discordPrompt:setText(self:T("ui.demo.discordCTA"))
	self.discordPrompt:setStyle(self.PROMPT_LABEL_STYLE, LabelStyle)
	self.discordPrompt:setSize(
		buttonWidth,
		Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, Theme.calculateTiledSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, buttonHeight, 2)))
	self.layout:addChild(self.discordPrompt)

	self.joinDiscordButton = Button()
	self.joinDiscordButton:setSize(buttonWidth, buttonHeight)
	self.joinDiscordButton.onClick:register(self._onClickDiscordButton, self)
	self.layout:addChild(self.joinDiscordButton)

	local iconWidth = Theme.calculateRemainingSizeWithPadding(
		Theme.DEFAULT_OUTER_PADDING,
		buttonWidth)
	local iconHeight = Theme.calculateRemainingSizeWithPadding(
		Theme.DEFAULT_OUTER_PADDING,
		buttonHeight)

	local steamIcon = Icon()
	steamIcon:setSize(iconWidth, iconHeight)
	steamIcon:setPosition(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	steamIcon:setIcon("Resources/Game/UI/Icons/Platforms/Logos/SteamLight.png")
	self.wishlistButton:addChild(steamIcon)

	local discordIcon = Icon()
	discordIcon:setSize(iconWidth, iconHeight)
	discordIcon:setPosition(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	discordIcon:setIcon("Resources/Game/UI/Icons/Platforms/Logos/DiscordLight.png")
	self.joinDiscordButton:addChild(discordIcon)

	self.layout:setID("FinishDemoContent")
	self.layout:performLayout()
end

function FinishDemoContentTab:focus(reason)
	GamepadContentTab.focus(self, reason)

	local inputProvider = self:getInputProvider()
	if inputProvider then
		inputProvider:setFocusedWidget(self.layout, reason)
	end
end

function FinishDemoContentTab:_onButtonsWrapFocus(_, child, directionX, directionY)
	self:onWrapFocus(directionX, directionY)
end

function FinishDemoContentTab:_onClickWishlistButton(button, buttonIndex)
	if buttonIndex == 1 then
		love.system.openURL(self.WISHLIST_CTA_LINK)
	end
end

function FinishDemoContentTab:_onClickDiscordButton(button, buttonIndex)
	if buttonIndex == 1 then
		love.system.openURL(self.DISCORD_CTA_LINK)
	end
end

return FinishDemoContentTab
