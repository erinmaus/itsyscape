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
local Button = require "ItsyScape.UI.Button"
local Icon = require "ItsyScape.UI.Icon"
local Interface = require "ItsyScape.UI.Interface"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local GamepadToolTip = require "ItsyScape.UI.GamepadToolTip"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Widget = require "ItsyScape.UI.Widget"

local SillyClick = Class(Interface)

SillyClick.PADDING = 8

SillyClick.WIDTH  = 480
SillyClick.HEIGHT = 320

SillyClick.ICON_SIZE = 48

SillyClick.DURATION = 1

SillyClick.TITLE_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowTitle.png"
}

SillyClick.CONTENT_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowContent.png"
}

SillyClick.TITLE_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	color = { 1, 1, 1, 1 },
	textShadow = true,
	center = true
}

SillyClick.LABEL_STYLE = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = _MOBILE and 26 or 24,
	textShadow = true,
	align = "center",
	center = true
}

function SillyClick:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self:setData(GamepadSink, GamepadSink())
	self:setZDepth(4000)

	local width, height = itsyrealm.graphics.getScaledMode()
	self:setSize(width, height)

	self.background = Panel()
	self.background:setStyle({
		color = { 0, 0, 0, 0.5 },
		radius = 0
	}, PanelStyle)
	self.background:setSize(width, height)
	self:addChild(self.background)

	self.content = Widget()
	self.content:setSize(self.WIDTH, self.HEIGHT)
	self:addChild(self.content)

	self.titlePanel = Panel()
	self.titlePanel:setStyle(self.TITLE_PANEL_STYLE, PanelStyle)
	self.titlePanel:setSize(self.WIDTH, self.ICON_SIZE + self.PADDING * 2)
	self.content:addChild(self.titlePanel)

	local icon = Icon()
	icon:setPosition(self.PADDING, self.PADDING)
	icon:setSize(self.ICON_SIZE, self.ICON_SIZE)
	icon:setIcon("Resources/Game/UI/Icons/Things/Compass.png")
	self.titlePanel:addChild(icon)

	self.titleLabel = Label()
	self.titleLabel:setText("By the way...")
	self.titleLabel:setStyle(self.TITLE_LABEL_STYLE, LabelStyle)
	self.titleLabel:setPosition(self.ICON_SIZE + self.PADDING * 2, self.PADDING)
	self.titleLabel:setSize(self.WIDTH - self.ICON_SIZE - self.PADDING * 3, self.ICON_SIZE)
	self.titlePanel:addChild(self.titleLabel)

	self.contentPanel = Panel()
	self.contentPanel:setStyle(self.CONTENT_PANEL_STYLE, PanelStyle)
	self.contentPanel:setSize(self.WIDTH, self.HEIGHT - self.ICON_SIZE - self.PADDING * 2)
	self.contentPanel:setPosition(0, self.ICON_SIZE + self.PADDING * 2)
	self.content:addChild(self.contentPanel)

	local contentWidth, contentHeight = self.contentPanel:getSize()

	self.label = Label()
	self.label:setSize(contentWidth - self.PADDING * 2, contentHeight - self.ICON_SIZE - self.PADDING * 3)
	self.label:setPosition(self.PADDING, self.PADDING)
	self.contentPanel:addChild(self.label)

	self.button = Button()
	self.button:setText("Got it!")
	self.button:setSize(self.WIDTH - self.PADDING * 2, self.ICON_SIZE)
	self.button:setPosition(self.PADDING, contentHeight - self.ICON_SIZE - self.PADDING)
	self.button.onClick:register(self.close, self)
	self:performLayout()

	self.pendingTime = self.DURATION
end

function SillyClick:restoreFocus()
	self:focusChild(self.button)
end

function SillyClick:close()
	self:sendPoke("close", nil, {})
end

function SillyClick:performLayout()
	local width, height = itsyrealm.graphics.getScaledMode()
	self:setSize(width, height)
	self.background:setSize(width, height)

	local selfWidth, selfHeight = self.content:getSize()
	self.content:setPosition((width - selfWidth) / 2, (height - selfHeight) / 2)
end

function SillyClick:attach()
	Interface.attach(self)
	self:updateLabel()
end

function SillyClick:updateLabel()
	local inputProvider = self:getInputProvider()
	if inputProvider:getCurrentJoystick() then
		self.label:setText("You don't need to mash the button so much! Your peep will keep performing the action until completion or failure after a single press.")
	elseif _MOBILE then
		self.label:setText("You don't need to tap so much! Your peep will keep performing the action until completion or failure after a single tap.")
	else
		self.label:setText("You don't need to click so much! Your peep will keep performing the action until completion or failure after a single click.")
	end
end

function SillyClick:update(delta)
	Interface.update(self, delta)

	self:updateLabel()

	self.pendingTime = math.max(self.pendingTime - delta, 0)
	if self.pendingTime == 0 then
		if self.button:getParent() ~= self.contentPanel then
			self.contentPanel:addChild(self.button)
			self:getView():getInputProvider():setFocusedWidget(self.button)
		end
	end
end

return SillyClick
