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
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
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
Theme.MINI_TITLE_HEIGHT = 48 + Theme.DEFAULT_OUTER_PADDING * 2

Theme.DEFAULT_INACTIVE_BUTTON_STYLE = {
	inactive = "Resources/Game/UI/Buttons/Button-Default.png",
	pressed = "Resources/Game/UI/Buttons/Button-Pressed.png",
	hover = "Resources/Game/UI/Buttons/Button-Hover.png",
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	textShadow = true,
	padding = 4
}

Theme.DEFAULT_ACTIVE_BUTTON_STYLE = {
	inactive = "Resources/Game/UI/Buttons/ButtonActive-Default.png",
	pressed = "Resources/Game/UI/Buttons/ButtonActive-Pressed.png",
	hover = "Resources/Game/UI/Buttons/ButtonActive-Hover.png",
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	textShadow = true,
	padding = 4
}

Theme.DEFAULT_ALTERNATE_BUTTON_STYLE = {
	inactive = "Resources/Game/UI/Buttons/AlternateButtonActive-Default.png",
	pressed = "Resources/Game/UI/Buttons/AlternateButtonActive-Pressed.png",
	hover = "Resources/Game/UI/Buttons/AlternateButtonActive-Hover.png",
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	textShadow = true,
	padding = 4
}

Theme.WINDOW_TITLE_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowTitle.png"
}

Theme.WINDOW_TITLE_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	color = { 1, 1, 1, 1 },
	textShadow = true
}

function Theme.override(a, b, e)
	e = e or {}
	assert(not (e[a] or e[b]), "cyclic table")
	assert(not (getmetatable(a) or getmetatable(b)), "only simple types allowed")

	if a then
		e[a] = true
	end

	if b then
		e[b] = true
	end

	local result = {}

	if a then
		for k, v in pairs(a) do
			if type(v) == "table" then
				result[k] = Theme.override(v, nil, e)
			else
				result[k] = v
			end
		end
	end

	if b then
		for k, v in pairs(b) do
			if type(v) == "table" then
				if type(a[k]) == "table" then
					result[k] = Theme.override(a[k], v, e)
				else
					result[k] = Theme.override(v, nil, e)
				end
			else
				result[k] = v
			end
		end
	end

	return result
end

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

function Theme.newMiniTitlePanelWithLabel(parent, windowWidth)
	windowWidth = windowWidth or Theme.calculateTiledSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.CONTENT_WIDTH, 2)

	local panel = Panel()
	panel:setSize(windowWidth, Theme.MINI_TITLE_HEIGHT)
	panel:setStyle(Theme.WINDOW_TITLE_PANEL_STYLE, PanelStyle)

	local label = Label()
	label:setStyle(Theme.WINDOW_TITLE_LABEL_STYLE, LabelStyle)
	label:setPosition(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	panel:addChild(label)

	if parent then
		parent:addChild(panel)
	end

	return panel, label
end

local function onCloseButtonClicked(button, buttonIndex)
	if buttonIndex == 1 then
		local parent = button:getParentOfType(Interface)

		if parent then
			parent:sendPoke("close", nil, {})
		end
	end
end

function Theme.newCloseButton(parent, includeDefaultAction)
	includeDefaultAction = includeDefaultAction == nil and true or includeDefaultAction

	local width, height = parent:getSize()
	local buttonSize = math.min(height - Theme.DEFAULT_OUTER_PADDING * 2, Theme.DEFAULT_ITEM_SIZE_WITH_PADDING)

	local button = CloseButton()
	button:setSize(buttonSize, buttonSize)
	button:setPosition(
		width - Theme.DEFAULT_OUTER_PADDING - buttonSize,
		Theme.DEFAULT_OUTER_PADDING)
	if includeDefaultAction then
		button.onClick:register(onCloseButtonClicked)
	end

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

function Theme.newContentPanel(parent, contentWidth, contentHeight, titlePanel)
	contentWidth = contentWidth or Theme.calculateTiledSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.CONTENT_WIDTH, 2)
	contentHeight = contentHeight or Theme.calculateTiledSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.CONTENT_HEIGHT, 1)

	local titleHeight = Theme.TITLE_HEIGHT
	if titlePanel then
		local w, h = titlePanel:getSize()
		titleHeight = h
	end

	local panel = Panel()
	panel:setSize(contentWidth, contentHeight)
	panel:setPosition(0, titleHeight)
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

Theme.BUTTON_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 24,
	color = { 1, 1, 1, 1 },
	align = "center",
	textShadow = true,
	spaceLines = true
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

function Theme.setSceneSnippet(sceneSnippet, camera, gameView, object, offset, zoom)
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

	offset = offset or Vector.UNIT_Y
	zoom = zoom or 2

	local distance = math.max(max.x - min.x, max.y - min.y, max.z - min.z)

	sceneSnippet:setChildNode(node)
	camera:copy(gameView:getCamera())
	camera:setPosition(Vector.ZERO:transform(node:getTransform():getGlobalTransform(_APP:getFrameDelta())) + (offset * distance / 2))
	camera:setRotation(-node:getTransform():getLocalRotation())
	camera:setDistance(distance * zoom + 2)

	local width, height = sceneSnippet:getSize()
	camera:setWidth(width)
	camera:setHeight(height)

	return true
end

function Theme.calculateTileSizeWithPadding(padding, size, n)
	n = n or 1

	return math.floor((size - padding * (n + 1)) / n)
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

Theme.DEFAULT_TEXT_INPUT_STYLE = {
	inactive = "Resources/Game/UI/TextInputs/Default-Inactive.png",
	active = "Resources/Game/UI/TextInputs/Default-Active.png",
	hover = "Resources/Game/UI/TextInputs/Default-Hover.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 32,
	color = { 0.2, 0.2, 0.2, 0.2 },
	padding = 0,
	textShadow = true
}

function Theme.layoutScrollablePanelWithGridLayout(panel, elementWidth, elementHeight)
	local panelWidth, panelHeight = panel:getSize()
	local innerPanel = panel:getInnerPanel()

	innerPanel:setUniformSize(true, elementWidth, elementHeight)
	innerPanel:setSize(panelWidth, 0)
	innerPanel:setWrapContents(true)
	innerPanel:performLayout()

	local scrollableWidth, scrollableHeight = innerPanel:getSize()
	local hasScrollbars = scrollableHeight > panelHeight
	local paddingX = innerPanel:getPadding()

	if hasScrollbars then
		innerPanel:setUniformSize(
			true,
			Theme.calculateRemainingSizeWithPadding(paddingX / 2, elementWidth, ScrollablePanel.DEFAULT_SCROLL_SIZE),
			elementHeight)
		innerPanel:setSize(panelWidth, 0)
		innerPanel:performLayout()

		scrollableWidth, scrollableHeight = innerPanel:getSize()
	end

	panel:setScrollSize(scrollableWidth, scrollableHeight)

	do
		local scrollX, scrollY = panel:getScroll()

		if scrollY > scrollableHeight - panelHeight then
			scrollY = 0
		end

		if scrollX > scrollableWidth - panelWidth then
			scrollX = 0
		end

		panel:setScroll(scrollX, scrollY)
	end

	return hasScrollbars
end

Theme.DEFAULT_TEXT_INPUT_HEIGHT = 48

return Theme
