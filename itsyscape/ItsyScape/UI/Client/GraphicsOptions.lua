--------------------------------------------------------------------------------
-- ItsyScape/UI/Client/GraphicsOptions.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"

local GraphicsOptions = Class(Widget)
GraphicsOptions.WIDTH = 640
GraphicsOptions.HEIGHT = 480
GraphicsOptions.INPUT_WIDTH = 64
GraphicsOptions.INPUT_HEIGHT = 64
GraphicsOptions.BUTTON_WIDTH = 128
GraphicsOptions.BUTTON_HEIGHT = 64
GraphicsOptions.PADDING = 8

GraphicsOptions.MIN_RESOLUTION_WIDTH = 1024
GraphicsOptions.MIN_RESOLUTION_HEIGHT = 576

GraphicsOptions.SELECT_INACTIVE_BOX_BUTTON_STYLE = {
	inactive = Color(0, 0, 0, 0),
	pressed = Color(29 / 255, 25 / 255, 19 / 255, 1),
	hover = Color(147 / 255, 124 / 255, 94 / 255, 1),
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = 24,
	textX = 0.0,
	textY = 0.5,
	textAlign = 'left'
}

GraphicsOptions.SELECT_ACTIVE_BOX_BUTTON_STYLE = {
	inactive = Color(147 / 255, 124 / 255, 94 / 255, 1),
	pressed = Color(29 / 255, 25 / 255, 19 / 255, 1),
	hover = Color(147 / 255, 124 / 255, 94 / 255, 1),
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = 24,
	textX = 0.0,
	textY = 0.5,
	textAlign = 'left'
}

GraphicsOptions.ACTIVE_ITEM_STYLE = {
	pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
	inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = 26,
	textShadow = true,
	textY = 0.5,
	textAlign = 'center'
}

GraphicsOptions.INACTIVE_ITEM_STYLE = {
	pressed = "Resources/Renderers/Widget/Button/Default-Pressed.9.png",
	inactive = "Resources/Renderers/Widget/Button/Default-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/Default-Hover.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = 26,
	textShadow = true,
	textY = 0.5,
	textAlign = 'center'
}

GraphicsOptions.INPUT_STYLE = {
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 24,
	color = { 1, 1, 1, 1 },
	textShadow = true
}

function GraphicsOptions:new(application)
	Widget.new(self)

	self.application = application

	local currentResWidth, currentResHeight = love.window.getMode()
	_CONF.width = _CONF.width or currentResWidth
	_CONF.height = _CONF.height or currentResHeight

	-- So by:
	--  1. Setting the size to the full screen resolution
	--  2. Setting the scroll to the center of screen (adjusted by window size)
	-- ...we prevent the user clicking anything underneath the settings screen
	-- and can position things relative to the top left corner of the window,
	-- rather than the top left corner of the screen.
	local w, h = love.graphics.getScaledMode()
	self:setSize(w, h)
	self:setScroll(
		-(w - GraphicsOptions.WIDTH) / 2,
		-(h - GraphicsOptions.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(GraphicsOptions.WIDTH, GraphicsOptions.HEIGHT)
	panel:setPosition(0, 0)
	self:addChild(panel)

	do
		self.resolutions = ScrollablePanel(GridLayout)
		self.resolutions:getInnerPanel():setPadding(0, 0)
		self.resolutions:getInnerPanel():setSize(
			GraphicsOptions.WIDTH / 2 - GraphicsOptions.PADDING * 3 - ScrollablePanel.DEFAULT_SCROLL_SIZE,
			0)
		self.resolutions:getInnerPanel():setUniformSize(
			true,
			self.resolutions:getInnerPanel():getSize(),
			GraphicsOptions.INPUT_HEIGHT)
		self.resolutions:getInnerPanel():setWrapContents(true)
		self.resolutions:setSize(
			GraphicsOptions.WIDTH / 2 - GraphicsOptions.PADDING * 3,
			GraphicsOptions.HEIGHT - GraphicsOptions.PADDING * 2)
		self.resolutions:setPosition(
			GraphicsOptions.PADDING,
			GraphicsOptions.PADDING)

		local function addResolution(width, height)
			local text = string.format("%d x %d", width, height)

			local button = Button()
			button:setText(text)

			if width == _CONF.width and height == _CONF.height then
				button:setStyle(
					ButtonStyle(
						GraphicsOptions.SELECT_ACTIVE_BOX_BUTTON_STYLE,
						self.application:getUIView():getResources()))
				self.activeResolutionButton = button
			else
				button:setStyle(
					ButtonStyle(
						GraphicsOptions.SELECT_INACTIVE_BOX_BUTTON_STYLE,
						self.application:getUIView():getResources()))
			end

			button:setData('width', width)
			button:setData('height', height)
			button.onClick:register(self.setResolution, self, width, height)
			button:setToolTip(ToolTip.Text(text))

			self.resolutions:addChild(button)
		end

		local resolutions = love.window.getFullscreenModes()
		table.sort(resolutions,
			function(a, b)
				return a.width * a.height < b.width * b.height
			end)

		for i = 1, #resolutions do
			if resolutions[i].width > GraphicsOptions.MIN_RESOLUTION_WIDTH and
			   resolutions[i].height > GraphicsOptions.MIN_RESOLUTION_HEIGHT
			then
				addResolution(resolutions[i].width, resolutions[i].height)
			end
		end

		self.resolutions:setScrollSize(self.resolutions:getInnerPanel():getSize())
		self:addChild(self.resolutions)
	end

	do
		local label = Label()
		label:setStyle(
			LabelStyle(
				GraphicsOptions.INPUT_STYLE,
				self.application:getUIView():getResources()))
		label:setText("Fullscreen")
		label:setPosition(
			GraphicsOptions.WIDTH / 2 + GraphicsOptions.PADDING * 2,
			GraphicsOptions.PADDING * 3)
		label:setSize(GraphicsOptions.WIDTH / 4, GraphicsOptions.INPUT_HEIGHT)
		self:addChild(label)

		local onButton = Button()
		onButton:setText('On')
		onButton:setToolTip(
			ToolTip.Text("Enable full screen mode."),
			ToolTip.Text("Fullscreen mode automatically matches the resolution of your primary monitor."))
		onButton:setPosition(
			GraphicsOptions.WIDTH * (2 / 3) + GraphicsOptions.PADDING * 3,
			GraphicsOptions.PADDING)
		onButton:setSize(
			GraphicsOptions.INPUT_WIDTH,
			GraphicsOptions.INPUT_HEIGHT)
		self.fullscreenOnButton = onButton

		if _CONF.fullscreen then
			onButton:setStyle(
				ButtonStyle(
					GraphicsOptions.ACTIVE_ITEM_STYLE,
					self.application:getUIView():getResources()))
		else
			onButton:setStyle(
				ButtonStyle(
					GraphicsOptions.INACTIVE_ITEM_STYLE,
					self.application:getUIView():getResources()))
		end
		onButton.onClick:register(self.setFullscreen, self, true)
		self:addChild(onButton)

		local offButton = Button()
		offButton:setText('Off')
		offButton:setToolTip(
			ToolTip.Text("Disable full screen mode."),
			ToolTip.Text("The game will use the specified display resolution in a window."))
		offButton:setPosition(
			GraphicsOptions.WIDTH * (2 / 3) + GraphicsOptions.INPUT_WIDTH + GraphicsOptions.PADDING * 4,
			GraphicsOptions.PADDING)
		offButton:setSize(
			GraphicsOptions.INPUT_WIDTH,
			GraphicsOptions.INPUT_HEIGHT)
		if not _CONF.fullscreen then
			offButton:setStyle(
				ButtonStyle(
					GraphicsOptions.ACTIVE_ITEM_STYLE,
					self.application:getUIView():getResources()))
		else
			offButton:setStyle(
				ButtonStyle(
					GraphicsOptions.INACTIVE_ITEM_STYLE,
					self.application:getUIView():getResources()))
		end
		offButton.onClick:register(self.setFullscreen, self, false)
		self:addChild(offButton)
		self.fullscreenOffButton = offButton
	end

	do
		local label = Label()
		label:setStyle(
			LabelStyle(
				GraphicsOptions.INPUT_STYLE,
				self.application:getUIView():getResources()))
		label:setText("V. Sync")
		label:setPosition(
			GraphicsOptions.WIDTH / 2 + GraphicsOptions.PADDING * 2,
			GraphicsOptions.PADDING * 3 + GraphicsOptions.INPUT_HEIGHT)
		label:setSize(GraphicsOptions.WIDTH / 4, GraphicsOptions.INPUT_HEIGHT)
		self:addChild(label)

		local onButton = Button()
		onButton:setText('On')
		onButton:setToolTip(
			ToolTip.Text("Enable vertical sync."),
			ToolTip.Text("The refresh rate will match the monitor's refresh rate."),
			ToolTip.Text("Adaptive vertical sync will be used if possible."))
		onButton:setPosition(
			GraphicsOptions.WIDTH * (2 / 3) + GraphicsOptions.PADDING * 3,
			GraphicsOptions.PADDING * 2 + GraphicsOptions.INPUT_HEIGHT)
		onButton:setSize(
			GraphicsOptions.INPUT_WIDTH,
			GraphicsOptions.INPUT_HEIGHT)

		if _CONF.vsync ~= 0 and _CONF.vsync ~= nil then
			onButton:setStyle(
				ButtonStyle(
					GraphicsOptions.ACTIVE_ITEM_STYLE,
					self.application:getUIView():getResources()))
		else
			onButton:setStyle(
				ButtonStyle(
					GraphicsOptions.INACTIVE_ITEM_STYLE,
					self.application:getUIView():getResources()))
		end
		onButton.onClick:register(self.setVSync, self, true)
		self:addChild(onButton)
		self.vsyncOnButton = onButton

		local offButton = Button()
		offButton:setText('Off')
		offButton:setToolTip(
			ToolTip.Text("Disable vertical sync mode."),
			ToolTip.Text("The refresh rate will be unlocked, which can cause screen tearing."))
		offButton:setPosition(
			GraphicsOptions.WIDTH * (2 / 3) + GraphicsOptions.INPUT_WIDTH + GraphicsOptions.PADDING * 4,
			GraphicsOptions.PADDING * 2 + GraphicsOptions.INPUT_HEIGHT)
		offButton:setSize(
			GraphicsOptions.INPUT_WIDTH,
			GraphicsOptions.INPUT_HEIGHT)
		if _CONF.vsync == 0 or _CONF.vsync == nil then
			offButton:setStyle(
				ButtonStyle(
					GraphicsOptions.ACTIVE_ITEM_STYLE,
					self.application:getUIView():getResources()))
		else
			offButton:setStyle(
				ButtonStyle(
					GraphicsOptions.INACTIVE_ITEM_STYLE,
					self.application:getUIView():getResources()))
		end
		offButton.onClick:register(self.setVSync, self, false)
		self:addChild(offButton)
		self.vsyncOffButton = offButton
	end

	do
		local confirmButton = Button()
		confirmButton:setText("Confirm")
		confirmButton:setStyle(
			ButtonStyle(
				GraphicsOptions.INACTIVE_ITEM_STYLE,
				self.application:getUIView():getResources()))
		confirmButton:setSize(GraphicsOptions.BUTTON_WIDTH, GraphicsOptions.BUTTON_HEIGHT)
		confirmButton:setPosition(
			GraphicsOptions.WIDTH - GraphicsOptions.BUTTON_WIDTH - GraphicsOptions.PADDING,
			GraphicsOptions.HEIGHT - GraphicsOptions.BUTTON_HEIGHT - GraphicsOptions.PADDING)
		confirmButton.onClick:register(self.confirm, self, true)
		confirmButton:setToolTip(
			ToolTip.Text("Save the changes you've made."),
			ToolTip.Text("You don't need to restart the game for these changes to take effect."))
		self:addChild(confirmButton)

		local cancelButton = Button()
		cancelButton:setText("Cancel")
		cancelButton:setStyle(
			ButtonStyle(
				GraphicsOptions.INACTIVE_ITEM_STYLE,
				self.application:getUIView():getResources()))
		cancelButton:setSize(GraphicsOptions.BUTTON_WIDTH, GraphicsOptions.BUTTON_HEIGHT)
		cancelButton:setPosition(
			GraphicsOptions.WIDTH / 2 + GraphicsOptions.PADDING * 2,
			GraphicsOptions.HEIGHT - GraphicsOptions.BUTTON_HEIGHT - GraphicsOptions.PADDING)
		cancelButton.onClick:register(self.confirm, self, false)
		cancelButton:setToolTip(ToolTip.Text("Discard the changes you've made."))
		self:addChild(cancelButton)
	end

	self.conf = {
		width = _CONF.width,
		height = _CONF.height,
		vsync = _CONF.vsync,
		fullscreen = _CONF.fullscreen
	}

	self.onClose = Callback()
end

function GraphicsOptions:setResolution(width, height, button)
	if self.activeResolutionButton then
		self.activeResolutionButton:setStyle(
			ButtonStyle(
				GraphicsOptions.SELECT_INACTIVE_BOX_BUTTON_STYLE,
				self.application:getUIView():getResources()))
		self.activeResolutionButton = nil
	end

	self.activeResolutionButton = button
	button:setStyle(
		ButtonStyle(
			GraphicsOptions.SELECT_ACTIVE_BOX_BUTTON_STYLE,
			self.application:getUIView():getResources()))

	self.conf.width = width
	self.conf.height = height
end

function GraphicsOptions:setVSync(enabled)
	if enabled then
		self.conf.vsync = -1

		self.vsyncOnButton:setStyle(
			ButtonStyle(
				GraphicsOptions.ACTIVE_ITEM_STYLE,
				self.application:getUIView():getResources()))
		self.vsyncOffButton:setStyle(
			ButtonStyle(
				GraphicsOptions.INACTIVE_ITEM_STYLE,
				self.application:getUIView():getResources()))
	else
		self.conf.vsync = 0

		self.vsyncOnButton:setStyle(
			ButtonStyle(
				GraphicsOptions.INACTIVE_ITEM_STYLE,
				self.application:getUIView():getResources()))
		self.vsyncOffButton:setStyle(
			ButtonStyle(
				GraphicsOptions.ACTIVE_ITEM_STYLE,
				self.application:getUIView():getResources()))
	end
end

function GraphicsOptions:setFullscreen(enabled)
	self.conf.fullscreen = enabled
	if enabled then
		self.fullscreenOnButton:setStyle(
			ButtonStyle(
				GraphicsOptions.ACTIVE_ITEM_STYLE,
				self.application:getUIView():getResources()))
		self.fullscreenOffButton:setStyle(
			ButtonStyle(
				GraphicsOptions.INACTIVE_ITEM_STYLE,
				self.application:getUIView():getResources()))
	else
		self.fullscreenOnButton:setStyle(
			ButtonStyle(
				GraphicsOptions.INACTIVE_ITEM_STYLE,
				self.application:getUIView():getResources()))
		self.fullscreenOffButton:setStyle(
			ButtonStyle(
				GraphicsOptions.ACTIVE_ITEM_STYLE,
				self.application:getUIView():getResources()))
	end
end

function GraphicsOptions:confirm(save)
	if save then
		_CONF.width = self.conf.width
		_CONF.height = self.conf.height
		_CONF.fullscreen = self.conf.fullscreen
		_CONF.vsync = self.conf.vsync
	end

	self.onClose(save)
end

return GraphicsOptions
