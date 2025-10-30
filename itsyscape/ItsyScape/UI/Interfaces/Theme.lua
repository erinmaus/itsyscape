--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Theme.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local ActorView = require "ItsyScape.Graphics.ActorView"
local PropView = require "ItsyScape.Graphics.PropView"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local CloseButton = require "ItsyScape.UI.CloseButton"
local Interface = require "ItsyScape.UI.Interface"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"

local Theme = {}

Theme.DEFAULT_BUTTON_SIZE   = 48
Theme.DEFAULT_ICON_SIZE     = 48
Theme.DEFAULT_ITEM_SIZE     = 48

Theme.DEFAULT_INNER_PADDING = 4
Theme.DEFAULT_OUTER_PADDING = 8

Theme.DEFAULT_ITEM_SIZE_WITH_PADDING   = Theme.DEFAULT_ITEM_SIZE + Theme.DEFAULT_INNER_PADDING * 2
Theme.DEFAULT_ICON_SIZE_WITH_PADDING   = Theme.DEFAULT_ICON_SIZE + Theme.DEFAULT_INNER_PADDING * 2
Theme.DEFAULT_BUTTON_SIZE_WITH_PADDING = Theme.DEFAULT_BUTTON_SIZE + Theme.DEFAULT_INNER_PADDING * 2

Theme.CONTENT_WIDTH  = GamepadContentTab.WIDTH
Theme.CONTENT_HEIGHT = GamepadContentTab.HEIGHT

Theme.TITLE_HEIGHT = 128

Theme.WINDOW_TITLE_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowTitle.png"
}

Theme.WINDOW_TITLE_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	color = { 1, 1, 1, 1 },
	textShadow = true
}

function Theme.newTitlePanel(parent, windowWidth)
	windowWidth = windowWidth or Theme.calculateTiledSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.CONTENT_WIDTH, 2)

	local panel = Panel()
	panel:setSize(windowWidth, Theme.TITLE_HEIGHT)
	panel:setStyle(Theme.WINDOW_TITLE_PANEL_STYLE, PanelStyle)

	if parent then
		parent:addChild(panel)
	end

	return panel
end

local function onCloseButtonClicked(button, buttonIndex)
	if buttonIndex == 1 then
		local parent = button:getParentOfType(Interface)

		if parent then
			parent:sendPoke("close", nil, {})
		end
	end
end

function Theme.newCloseButton(parent)
	local width = parent:getSize()

	local button = CloseButton()
	button:setSize(Theme.DEFAULT_BUTTON_SIZE_WITH_PADDING, Theme.DEFAULT_BUTTON_SIZE_WITH_PADDING)
	button:setPosition(
		width - Theme.DEFAULT_OUTER_PADDING - Theme.DEFAULT_BUTTON_SIZE_WITH_PADDING,
		Theme.DEFAULT_OUTER_PADDING)
	button.onClick:register(onCloseButtonClicked)

	parent:addChild(button)

	return button
end

function Theme.newTitleLabel(parent)
	local label = Label()
	label:setStyle(Theme.WINDOW_TITLE_LABEL_STYLE, LabelStyle)
	label:setPosition(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	parent:addChild(label)

	return label
end

Theme.WINDOW_CONTENT_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowContent.png"
}

function Theme.newContentPanel(parent, contentWidth, contentHeight)
	contentWidth = contentWidth or Theme.calculateTiledSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.CONTENT_WIDTH, 2)
	contentHeight = contentHeight or Theme.calculateTiledSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.CONTENT_HEIGHT, 1)

	local panel = Panel()
	panel:setSize(contentWidth, Theme.TITLE_HEIGHT)
	panel:setPosition(0, Theme.TITLE_HEIGHT)
	panel:setStyle(Theme.WINDOW_CONTENT_PANEL_STYLE, PanelStyle)

	if parent then
		parent:addChild(panel)
	end

	return panel
end

Theme.ITEM_BUTTON_STYLE = {
	pressed = "Resources/Game/UI/Buttons/ItemButton-Pressed.png",
	hover = "Resources/Game/UI/Buttons/ItemButton-Hover.png",
	inactive = "Resources/Game/UI/Buttons/ItemButton-Default.png"
}

Theme.ITEM_PANEL_STYLE = {
	image = "Resources/Game/UI/Buttons/ItemButton-Default.png"
}

Theme.CONTENT_TITLE_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/SemiBold.ttf",
	fontSize = 16,
	color = { 1, 1, 1, 1 },
	lineHeight = 0.8,
	textShadow = true
}

Theme.CONTENT_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 16,
	color = { 1, 1, 1, 1 },
	textShadow = true
}

Theme.PROGRESS_BAR_LABEL_STYLE = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = 16,
	textShadow = true,
	spaceLines = true
}

function Theme.newItemParent(parent, Type)
	local instance = Type()
	instance:setSize(Theme.DEFAULT_ITEM_SIZE_WITH_PADDING, Theme.DEFAULT_ITEM_SIZE_WITH_PADDING)

	if Type == Panel then
		instance:setStyle(Theme.ITEM_PANEL_STYLE, PanelStyle)
	elseif Type == Button then
		instance:setStyle(Theme.ITEM_BUTTON_STYLE, ButtonStyle)
	end

	parent:addChild(instance)

	return instance
end

function Theme.addItemIconChild(parent)
	parent:setSize(Theme.DEFAULT_ITEM_SIZE_WITH_PADDING, Theme.DEFAULT_ITEM_SIZE_WITH_PADDING)

	local icon = ItemIcon()
	icon:setSize(Theme.DEFAULT_ICON_SIZE, Theme.DEFAULT_ICON_SIZE)
	icon:setPosition(Theme.DEFAULT_INNER_PADDING, Theme.DEFAULT_INNER_PADDING)
	parent:addChild(icon)

	return icon
end

function Theme.setSceneSnippet(sceneSnippet, camera, gameView, object, offset)
	local view = gameView:getView(object)

	local node, min, max
	if Class.isCompatibleType(view, ActorView) then
		node = view:getSceneNode()
		min, max = view:getActor():getBounds()
	elseif Class.isCompatibleType(view, PropView) then
		node = view:getRoot()
		min, max = view:getProp():getBounds()
	else
		return false
	end

	local offset = offset or Vector.UNIT_Y
	local distance = math.max(max.x - min.x, max.y - min.y, max.z - min.z)

	sceneSnippet:setChildNode(node)
	camera:copy(gameView:getCamera())
	camera:setPosition(Vector.ZERO:transform(node:getTransform():getGlobalTransform(_APP:getFrameDelta())) + (offset * distance / 2))
	camera:setRotation(-node:getTransform():getLocalRotation())
	camera:setDistance(distance * 2 + 2)

	return true
end

function Theme.calculateTiledSizeWithPadding(padding, size, n)
	n = n or 1

	return math.floor(size * n + padding * (n + 1))
end

function Theme.calculateInnerSize(padding, size)
	return math.floor(size - padding * 2)
end

function Theme.calculateSize(...)
	local t = 0 

	for i = 1, select("#", ...) do
		t = t + (select(i, ...) or 0)
	end

	return math.floor(t)
end

function Theme.calculateSizeWithPadding(padding, ...)
	local t = padding 

	for i = 1, select("#", ...) do
		t = t + (select(i, ...) or 0) + padding
	end

	return math.floor(t)
end

function Theme.calculateRemainingSizeWithPadding(padding, outerSize, ...)
	local innerSize = Theme.calculateSizeWithPadding(padding, ...)
	return math.floor(math.max(outerSize - innerSize - padding * 2, 0))
end

return Theme
