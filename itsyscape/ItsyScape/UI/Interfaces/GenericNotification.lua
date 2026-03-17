--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/GenericNotification.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Interface = require "ItsyScape.UI.Interface"
local Icon = require "ItsyScape.UI.Icon"
local InputScheme = require "ItsyScape.UI.InputScheme"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Widget = require "ItsyScape.UI.Widget"
local Theme = require "ItsyScape.UI.Interfaces.Theme"

local GenericNotification = Class(Interface)
GenericNotification.WIDTH = 420

function GenericNotification:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self:setIsSelfClickThrough(true)
	self:setAreChildrenClickThrough(true)

	self.panel = Panel()
	self.panel:setStyle(Theme.ERROR_NOTIFICATION_PANEL_STYLE, PanelStyle)
	self.panel:setSize(self:getSize())
	self:addChild(self.panel)

	self.text = Label()
	self.text:setStyle(Theme.ERROR_NOTIFICATION_LABEL_STYLE, LabelStyle)
	self.text:setIsSelfClickThrough(true)
	self:addChild(self.text)

	local state = self:getState()
	self.text:setText(state.message)
	self.message = state.message
	self.generation = state.generation

	self:setZDepth(500)
end

function GenericNotification:attach()
	Interface.attach(self)

	self:performLayout()
end

function GenericNotification:performLayout()
	local w, h = itsyrealm.graphics.getScaledMode()
	local x, y = itsyrealm.graphics.getScaledPoint(itsyrealm.mouse.getPosition())

	local textStyle = self.text:getStyle()
	local _, lines = textStyle.font:getWrap(self.text:getText(), self.WIDTH - Theme.DEFAULT_OUTER_PADDING * 2)
	local wrappedHeight = #lines * textStyle.font:getHeight() * textStyle.font:getLineHeight()

	self:setSize(
		self.WIDTH,
		wrappedHeight + Theme.DEFAULT_OUTER_PADDING * 2)
	self.panel:setSize(self:getSize())

	local inputScheme = self:getView():getCurrentInputScheme()
	if inputScheme == InputScheme.INPUT_SCHEME_GAMEPAD then
		self:setPosition(
			(w - self.WIDTH) / 2,
			h / 2 + (h / 2 + wrappedHeight) / 2)
	else
		self:setPosition(x + Theme.DEFAULT_OUTER_PADDING, y - wrappedHeight - Theme.DEFAULT_OUTER_PADDING)
	end

	self:push()
end

function GenericNotification:push()
	local x, y  = self:getPosition()
	local width, height = self:getSize()

	local screenWidth, screenHeight = itsyrealm.graphics.getScaledMode()

	if x < Theme.DEFAULT_OUTER_PADDING then
		x = Theme.DEFAULT_OUTER_PADDING
	end

	if y < Theme.DEFAULT_OUTER_PADDING then
		y = Theme.DEFAULT_OUTER_PADDING
	end

	if x + width > screenWidth then
		x = screenWidth - width - Theme.DEFAULT_OUTER_PADDING
	end

	if y + height > screenHeight then
		y = screenHeight - height - Theme.DEFAULT_OUTER_PADDING
	end

	self:setPosition(x, y)
end

function GenericNotification:update(...)
	Interface.update(self, ...)

	local state = self:getState()
	if state.message ~= self.message or state.generation ~= self.generation then
		self.text:setText(state.message)
		self:performLayout()

		self.message = state.message
		self.generation = state.generation
	end
end

return GenericNotification
