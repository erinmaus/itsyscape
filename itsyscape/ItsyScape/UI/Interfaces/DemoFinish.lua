--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/DemoFinish.lua
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
local ActorView = require "ItsyScape.Graphics.ActorView"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local DefaultCameraController = require "ItsyScape.Graphics.DefaultCameraController"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local NullActor = require "ItsyScape.Game.Null.Actor"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local GamepadToolTip = require "ItsyScape.UI.GamepadToolTip"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Interface = require "ItsyScape.UI.Interface"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local RichTextLabel = require "ItsyScape.UI.RichTextLabel"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local Theme = require "ItsyScape.UI.Interfaces.Theme"
local ConfigGamepadContentTab = require "ItsyScape.UI.Interfaces.Components.ConfigGamepadContentTab"
local FinishDemoContentTab = require "ItsyScape.UI.Interfaces.Components.FinishDemoContentTab"

local DemoFinish = Class(Interface)

DemoFinish.TITLE_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 48,
	color = { 1, 1, 1, 1 },
	textShadow = true,
	align = "center"
}

DemoFinish.SUMMARY_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/Regular.ttf",
	fontSize = 32,
	color = { 1, 1, 1, 1 },
	textShadow = true,
	align = "center"
}

function DemoFinish:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self.backgroundPanel = Panel()
	self.backgroundPanel:setStyle({
		color = { 0, 0, 0, 1 },
		radius = 0
	}, PanelStyle)
	self:addChild(self.backgroundPanel)

	local titleLabel = Label()
	titleLabel:setText(self:T("ui.demo.completeTitle"))
	titleLabel:setStyle(self.TITLE_LABEL_STYLE, LabelStyle)
	titleLabel:setPosition(0, Theme.DEFAULT_OUTER_PADDING)
	self:addChild(titleLabel)

	local descriptionLabel = Label()
	descriptionLabel:setText(self:T("ui.demo.completeDescription"))
	descriptionLabel:setStyle(self.SUMMARY_LABEL_STYLE, LabelStyle)
	descriptionLabel:setPosition(0, Theme.DEFAULT_OUTER_PADDING * 2 + self.TITLE_LABEL_STYLE.fontSize * 2)
	self:addChild(descriptionLabel)

	self.layout = GamepadGridLayout()
	self.layout:setID("DemoFinish-Buttons")
	self.layout:setSize(width, DemoFinish.BUTTON_HEIGHT)
	self.layout:setUniformSize(
		true,
		Theme.CONTENT_WIDTH,
		Theme.CONTENT_HEIGHT)
	self.layout:setPadding(Theme.DEFAULT_OUTER_PADDING, 0)
	self:addChild(self.layout)

	self.configGamepadContentTab = ConfigGamepadContentTab(self)
	self.finishDemoContentTab = FinishDemoContentTab(self)

	local configPanel = Panel()
	configPanel:setStyle(Theme.WINDOW_CONTENT_PANEL_STYLE, PanelStyle)
	configPanel:setSize(self.configGamepadContentTab:getSize())
	configPanel:setZDepth(-1)
	self.configGamepadContentTab:addChild(configPanel)

	local finishPanel = Panel()
	finishPanel:setStyle(Theme.WINDOW_CONTENT_PANEL_STYLE, PanelStyle)
	finishPanel:setSize(self.configGamepadContentTab:getSize())
	finishPanel:setZDepth(-1)
	self.finishDemoContentTab:addChild(finishPanel)

	self.layout:addChild(self.configGamepadContentTab)

	if not _ITSYREALM_CONF then
		self.configGamepadContentTab.onWrapFocus:register(self._onContentWrapFocus, self, self.finishDemoContentTab)
		self.finishDemoContentTab.onWrapFocus:register(self._onContentWrapFocus, self, self.configGamepadContentTab)
		self.layout:addChild(self.finishDemoContentTab)
	end

	self:refresh()
	self:performLayout()
end

function DemoFinish:_onContentWrapFocus(otherTab, _, directionX, directionY)
	if directionX ~= 0 then
		self:focusChild(otherTab)
	end
end

function DemoFinish:attach()
	Interface.attach(self)

	self:restoreFocus()
end

function DemoFinish:restoreFocus()
	Interface.restoreFocus(self)

	self:focusChild(self.configGamepadContentTab)
end

function DemoFinish:refresh()
	Interface.refresh(self)

	self.configGamepadContentTab:refresh(self:getState())
end

function DemoFinish:performLayout()
	Interface.performLayout(self)

	local width, height = itsyrealm.graphics.getScaledMode()
	self:setSize(width, height)
	self.backgroundPanel:setSize(width, height)

	local gridWidth = Theme.calculateTiledSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, Theme.CONTENT_WIDTH, self.layout:getNumChildren())
	self.layout:setSize(
		gridWidth,
		Theme.CONTENT_HEIGHT)
	self.layout:setPosition(
		(width - gridWidth) / 2,
		height / 2 + height / 8 - Theme.CONTENT_HEIGHT / 2)
	self.layout:performLayout()
end

return DemoFinish
