--------------------------------------------------------------------------------
-- ItsyScape/UI/Client/GraphicsOptions2.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Function = require "ItsyScape.Common.Function"
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local CloseButton = require "ItsyScape.UI.CloseButton"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Widget = require "ItsyScape.UI.Widget"

local GraphicsOptions = Class(Widget)

GraphicsOptions.TITLE_HEIGHT   = 128
GraphicsOptions.CONTENT_HEIGHT = 0

GraphicsOptions.WIDTH  = 480
GraphicsOptions.HEIGHT = GraphicsOptions.TITLE_HEIGHT + GraphicsOptions.CONTENT_HEIGHT

GraphicsOptions.BUTTON_SIZE = 48
GraphicsOptions.PADDING     = 8

GraphicsOptions.MIN_RESOLUTION_WIDTH = 1280
GraphicsOptions.MIN_RESOLUTION_HEIGHT = 720

GraphicsOptions.TITLE_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowTitle.png"
}

GraphicsOptions.CONTENT_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowContent.png"
}

GraphicsOptions.TITLE_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	color = { 1, 1, 1, 1 },
	textShadow = true
}

GraphicsOptions.CONFIRM_BUTTON_STYLE = {
	inactive = "Resources/Game/UI/Buttons/ButtonActive-Default.png",
	pressed = "Resources/Game/UI/Buttons/ButtonActive-Pressed.png",
	hover = "Resources/Game/UI/Buttons/ButtonActive-Hover.png",
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = _MOBILE and 28 or 24,
}

function GraphicsOptions:new(application)
	Widget.new(self)

	self.onClose = Callback()

	self.application = application

	local w, h, flags = love.window.getMode()
	self.conf = {
		width = _CONF.width or w,
		height = _CONF.height or h,
		fullscreen = _CONF.fullscreen == nil and flags.fullscreen or flags.fullscreen,
		vsync = _CONF.vsync or flags.vsync,
		volume = _CONF.volume or 1,
		probe = _CONF.probe == nil and true or _CONF.probe,
		outlineJitterInterval = _CONF.outlineJitterInterval == nil and 8 or _CONF.outlineJitterInterval,
		outlines = _CONF.outlines == nil and true or _CONF.outlines,
		reflections = _CONF.reflections == nil and true or _CONF.reflections,
		shadows = _CONF.shadows == nil and true or _CONF.shadows,
		analytics = _ANALYTICS_ENABLED == nil and true or _ANALYTICS_ENABLED
	}

	self:setSize(self.WIDTH, self.HEIGHT)
	self:setData(GamepadSink, GamepadSink())

	self.titlePanel = Panel()
	self.titlePanel:setSize(self.WIDTH, self.TITLE_HEIGHT)
	self.titlePanel:setStyle(self.TITLE_PANEL_STYLE, PanelStyle)
	self:addChild(self.titlePanel)

	self.titleLabel = Label()
	self.titleLabel:setStyle(self.TITLE_LABEL_STYLE, LabelStyle)
	self.titleLabel:setPosition(self.PADDING, self.PADDING / 2)
	self.titleLabel:setText("Settings")
	self.titlePanel:addChild(self.titleLabel)

	self.closeButton = CloseButton()
	self.closeButton:setPosition(self.WIDTH - self.PADDING - CloseButton.DEFAULT_SIZE, self.PADDING)
	self.closeButton.onClick:register(self.confirm, self, false)
	self.titlePanel:addChild(self.closeButton)

	self.contentPanel = Panel()
	self.contentPanel:setSize(self.WIDTH, self.CONTENT_HEIGHT)
	self.contentPanel:setPosition(0, self.TITLE_HEIGHT)
	self.contentPanel:setStyle(self.CONTENT_PANEL_STYLE, PanelStyle)
	self.contentPanel:setScrollSize(self.CONTENT_LAYOUT_WIDTH, self.CONTENT_HEIGHT)
	self:addChild(self.contentPanel)

	self.layout = GamepadGridLayout()
	self.layout:setWrapContents(true)
	self.layout:setPadding(self.PADDING, self.PADDING)
	self.layout:setUniformSize(true, self.WIDTH - self.PADDING * 2, self.BUTTON_SIZE)
	self.layout:setSize(self.WIDTH, 0)
	self:_addButton(self.getGraphicsResolutionText, self.getGraphicsResolutionOptions)
	self:_addButton(self.getFullscreenText, self.getFullscreenOptions)
	self:_addButton(self.getVSyncText, self.getVSyncOptions)
	self:_addButton(self.getVolumeText, self.getVolumeOptions)
	self:_addButton(self.getOneClickText, self.getOneClickOptions)
	self:_addButton(self.getOutlineAnimationIntervalText, self.getOutlineAnimationIntervalOptions)
	self:_addButton(self.getOutlinesText, self.getOutlinesOptions)
	self:_addButton(self.getReflectionsText, self.getReflectionsOptions)
	self:_addButton(self.getShadowsText, self.getShadowsOptions)
	self:_addButton(self.getAnalyticsText, self.getAnalyticsOptions)

	local confirmButton = self:_addButton(self.getConfirmText, self.getConfirmOptions)
	confirmButton:setStyle(self.CONFIRM_BUTTON_STYLE, ButtonStyle)

	self.contentPanel:addChild(self.layout)
	self.layout:performLayout()

	local w, h = self.layout:getSize()
	self.contentPanel:setSize(w, h + self.PADDING)

	self:performLayout()
end

function GraphicsOptions:_addButton(getText, getOptions)
	local button = Button()
	button:setText(getText(self))
	button.onClick:register(self._onButtonPress, self, getText, getOptions)

	self.layout:addChild(button)

	return button
end

function GraphicsOptions:getIsFocusable()
	return true
end

function GraphicsOptions:focus(reason)
	Widget.focus(self, reason)

	local inputProvider = self:getInputProvider()
	if inputProvider then
		inputProvider:setFocusedWidget(self.layout, reason)
	end
end

function GraphicsOptions:_onButtonPress(getText, getOptions, button)
	local actions = getOptions(self)

	local buttonX, buttonY = button:getAbsolutePosition()
	local buttonWidth, buttonHeight = button:getSize()
	local x, y = buttonX + buttonWidth / 2, buttonY + buttonHeight + buttonHeight / 4

	local probe = self.application:getUIView():probe(actions, x, y, true, false)
	probe.onClose:register(self._updateButtonText, self, button, getText)
end

function GraphicsOptions:_updateButtonText(button, getText)
	button:setText(getText(self))
end

function GraphicsOptions:getGraphicsResolutionText()
	return string.format("Resolution: %d x %d", self.conf.width, self.conf.height)
end

function GraphicsOptions:getGraphicsResolutionOptions()
	local resolutions = love.window.getFullscreenModes()
	table.sort(resolutions,
		function(a, b)
			return a.width * a.height < b.width * b.height
		end)

	local _, _, flags = love.window.getMode()
	local maxWidth, maxHeight = love.window.getDesktopDimensions(flags.display)

	local actions = {}
	for i, resolution in ipairs(resolutions) do
		if resolution.width > self.MIN_RESOLUTION_WIDTH and
		   resolution.height > self.MIN_RESOLUTION_HEIGHT and
		   resolution.width <= maxWidth and
		   resolution.height <= maxHeight
		then
			table.insert(actions, {
				id = i,
				type = "Choose",
				verb = "Choose",
				object = string.format("%d x %d", resolution.width, resolution.height),
				objectID = i,
				objectType = "options",
				callback = Function(self.setGraphicsResolution, self, resolution.width, resolution.height)
			})
		end
	end

	return actions
end

function GraphicsOptions:setGraphicsResolution(width, height)
	self.conf.width = width
	self.conf.height = height
end

function GraphicsOptions:getFullscreenText()
	return string.format("Fullscreen: %s", self.conf.fullscreen and "Yes" or "No")
end

function GraphicsOptions:getFullscreenOptions()
	return {
		{
				id = 1,
				type = "Choose",
				verb = "Choose",
				object = "Yes",
				objectID = 1,
				objectType = "option",
				callback = Function(self.setFullscreen, self, true)
		},
		{
				id = 2,
				type = "Choose",
				verb = "Choose",
				object = "No",
				objectID = 2,
				objectType = "option",
				callback = Function(self.setFullscreen, self, false)
		}
	}
end

function GraphicsOptions:setFullscreen(value)
	self.conf.fullscreen = value
end

function GraphicsOptions:getVSyncText()
	local value
	if self.conf.vsync < 0 then
		value = "Adaptive"
	elseif self.conf.vsync == 0 then
		value = "Off"
	else
		value = "On"
	end

	return string.format("VSync: %s", value)
end

function GraphicsOptions:getVSyncOptions()
	return {
		{
				id = 1,
				type = "Choose",
				verb = "Choose",
				object = "Adaptive",
				objectID = 1,
				objectType = "option",
				callback = Function(self.setVSync, self, -1)
		},
		{
				id = 2,
				type = "Choose",
				verb = "Choose",
				object = "On",
				objectID = 2,
				objectType = "option",
				callback = Function(self.setVSync, self, 1)
		},
		{
				id = 3,
				type = "Choose",
				verb = "Choose",
				object = "Off",
				objectID = 3,
				objectType = "option",
				callback = Function(self.setVSync, self, 0)
		}
	}
end

function GraphicsOptions:setVSync(value)
	self.conf.vsync = value
end

function GraphicsOptions:getVolumeText()
	local value = math.floor(self.conf.volume * 100)

	return string.format("Volume: %d%%", value)
end

function GraphicsOptions:getVolumeOptions()
	local actions = {}
	for i = 0, 5 do
		table.insert(actions, {
			id = 1,
			type = "Choose",
			verb = "Choose",
			object = string.format("%d%%", i / 5 * 100),
			objectID = 1,
			objectType = "option",
			callback = Function(self.setVolume, self, i / 5)
		})
	end
	return actions
end

function GraphicsOptions:setVolume(value)
	self.conf.volume = value
end

function GraphicsOptions:getOneClickText()
	return string.format("One-Button Poke: %s", self.conf.probe and "Yes" or "No")
end

function GraphicsOptions:getOneClickOptions()
	return {
		{
				id = 1,
				type = "Choose",
				verb = "Choose",
				object = "Yes",
				objectID = 1,
				objectType = "option",
				callback = Function(self.setOneClick, self, true)
		},
		{
				id = 2,
				type = "Choose",
				verb = "Choose",
				object = "No",
				objectID = 2,
				objectType = "option",
				callback = Function(self.setOneClick, self, false)
		}
	}
end

function GraphicsOptions:setOneClick(value)
	self.conf.probe = value
end

function GraphicsOptions:getOutlineAnimationIntervalText()
	if self.conf.outlineJitterInterval > 1 then
		return "Outline Animation: Fast"
	elseif self.conf.outlineJitterInterval > 0 then
		return "Outline Animation: Slow"
	end

	return "Outline Animation: Off"
end

function GraphicsOptions:getOutlineAnimationIntervalOptions()
	return {
		{
				id = 1,
				type = "Choose",
				verb = "Choose",
				object = "Fast",
				objectID = 1,
				objectType = "option",
				callback = Function(self.setOutlineAnimationInterval, self, 8)
		},
		{
				id = 2,
				type = "Choose",
				verb = "Choose",
				object = "Slow",
				objectID = 2,
				objectType = "option",
				callback = Function(self.setOutlineAnimationInterval, self, 1)
		},
		{
				id = 3,
				type = "Choose",
				verb = "Choose",
				object = "Off",
				objectID = 2,
				objectType = "option",
				callback = Function(self.setOutlineAnimationInterval, self, 0)
		}
	}
end

function GraphicsOptions:setOutlineAnimationInterval(value)
	self.conf.outlineJitterInterval = value
end

function GraphicsOptions:getOutlinesText()
	return string.format("Outlines: %s", self.conf.outlines and "On" or "Off")
end

function GraphicsOptions:getOutlinesOptions()
	return {
		{
				id = 1,
				type = "Choose",
				verb = "Choose",
				object = "On",
				objectID = 1,
				objectType = "option",
				callback = Function(self.setOutlines, self, true)
		},
		{
				id = 2,
				type = "Choose",
				verb = "Choose",
				object = "Off",
				objectID = 2,
				objectType = "option",
				callback = Function(self.setOutlines, self, false)
		}
	}
end

function GraphicsOptions:setOutlines(value)
	self.conf.outlines = value
end

function GraphicsOptions:getReflectionsText()
	return string.format("Reflections: %s", self.conf.reflections and "On" or "Off")
end

function GraphicsOptions:getReflectionsOptions()
	return {
		{
				id = 1,
				type = "Choose",
				verb = "Choose",
				object = "On",
				objectID = 1,
				objectType = "option",
				callback = Function(self.setReflections, self, true)
		},
		{
				id = 2,
				type = "Choose",
				verb = "Choose",
				object = "Off",
				objectID = 2,
				objectType = "option",
				callback = Function(self.setReflections, self, false)
		}
	}
end

function GraphicsOptions:setReflections(value)
	self.conf.reflections = value
end

function GraphicsOptions:getShadowsText()
	local value
	if self.conf.shadows == false or (type(self.conf.shadows) == "number" and self.conf.shadows <= 0) then
		value = "Off"
	elseif self.conf.shadows == 1 then
		value = "Low"
	elseif self.conf.shadows == true or self.conf.shadows == 2 then
		value = "High"
	else
		value = "Ultra"
	end

	return string.format("Shadow Quality: %s", value)
end

function GraphicsOptions:getShadowsOptions()
	return {
		{
				id = 1,
				type = "Choose",
				verb = "Choose",
				object = "Off",
				objectID = 1,
				objectType = "option",
				callback = Function(self.setShadows, self, false)
		},
		{
				id = 2,
				type = "Choose",
				verb = "Choose",
				object = "Low",
				objectID = 2,
				objectType = "option",
				callback = Function(self.setShadows, self, 1)
		},
		{
				id = 3,
				type = "Choose",
				verb = "Choose",
				object = "High",
				objectID = 3,
				objectType = "option",
				callback = Function(self.setShadows, self, 2)
		},
		{
				id = 4,
				type = "Choose",
				verb = "Choose",
				object = "Ultra",
				objectID = 4,
				objectType = "option",
				callback = Function(self.setShadows, self, 3)
		}
	}
end

function GraphicsOptions:setShadows(value)
	self.conf.shadows = value
end

function GraphicsOptions:getAnalyticsText()
	return string.format("Analytics: %s", self.conf.analytics and "On" or "Off")
end

function GraphicsOptions:getAnalyticsOptions()
	return {
		{
				id = 1,
				type = "Choose",
				verb = "Choose",
				object = "On",
				objectID = 1,
				objectType = "option",
				callback = Function(self.setAnalytics, self, true)
		},
		{
				id = 2,
				type = "Choose",
				verb = "Choose",
				object = "Off",
				objectID = 2,
				objectType = "option",
				callback = Function(self.setAnalytics, self, false)
		}
	}
end

function GraphicsOptions:setAnalytics(value)
	self.conf.analytics = value
end

function GraphicsOptions:getConfirmText()
	return "Save/Discard"
end

function GraphicsOptions:getConfirmOptions()
	return {
		{
				id = 1,
				type = "Save",
				verb = "Save",
				object = "Settings",
				objectID = 1,
				objectType = "option",
				callback = Function(self.confirm, self, true)
		},
		{
				id = 2,
				type = "Discard",
				verb = "Discard",
				object = "Settings",
				objectID = 2,
				objectType = "option",
				callback = Function(self.confirm, self, false)
		}
	}
end

function GraphicsOptions:confirm(save)
	if save then
		_CONF.width = self.conf.width
		_CONF.height = self.conf.height
		_CONF.fullscreen = self.conf.fullscreen
		_CONF.vsync = self.conf.vsync
		_CONF.volume = self.conf.volume
		_CONF.probe = self.conf.probe
		_CONF.outlineJitterInterval = self.conf.outlineJitterInterval
		_CONF.outlines = self.conf.outlines
		_CONF.reflections = self.conf.reflections
		_CONF.shadows = self.conf.shadows
		_CONF.analytics = self.conf.analytics
	end

	self:onClose(save, self.conf)
end

function GraphicsOptions:performLayout()
	local width, height = itsyrealm.graphics.getScaledMode()

	local _, titleHeight = self.titlePanel:getSize()
	local _, contentHeight = self.contentPanel:getSize()
	self:setSize(self.width, titleHeight + contentHeight)

	local selfWidth, selfHeight = self:getSize()

	self:setPosition((width - selfWidth) / 2, (height - selfHeight) / 2)
end

return GraphicsOptions
