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
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Widget = require "ItsyScape.UI.Widget"

local GenericNotification = Class(Interface)
GenericNotification.WIDTH = 420
GenericNotification.PADDING = 8

function GenericNotification:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	local x, y = itsyrealm.graphics.getScaledPoint(itsyrealm.mouse.getPosition())

	self:setIsSelfClickThrough(true)
	self:setAreChildrenClickThrough(true)

	self.panel = Panel()
	self.panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/GenericNotification.9.png"
	}, self:getView():getResources()))
	self.panel:setSize(self:getSize())
	self:addChild(self.panel)

	local state = self:getState()

	self.text = Label()
	self.text:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = 22,
		textShadow = true,
		width = self.WIDTH - self.PADDING * 2,
		align = 'left'
	}, self:getView():getResources()))
	self.text:setPosition(self.PADDING, self.PADDING)
	self.text:setText(state.message)
	self.text:setIsSelfClickThrough(true)
	self:addChild(self.text)

	self.message = state.message

	local textStyle = self.text:getStyle()
	local _, lines = textStyle.font:getWrap(self.text:getText(), self.WIDTH - self.PADDING * 2)
	local wrappedHeight = #lines * textStyle.font:getHeight() * textStyle.font:getLineHeight()

	self:setSize(
		self.WIDTH,
		wrappedHeight + self.PADDING * 2)

	local inputProvider = self:getView():getInputProvider()
	if inputProvider and inputProvider:getCurrentJoystick() then
		local screenWidth, screenHeight = itsyrealm.graphics.getScaledMode()
		self:setPosition(
			(screenWidth - self.WIDTH) / 2,
			screenHeight / 2 + (screenHeight / 2 + wrappedHeight) / 2)
	else
		self:setPosition(x + self.PADDING, y - wrappedHeight - self.PADDING)
	end

	self.panel:setSize(self:getSize())
	self:push()

	self:setZDepth(500)
	self:setIsSelfClickThrough(true)
end

function GenericNotification:push()
	local x, y  = self:getPosition()
	local width, height = self:getSize()

	local screenWidth, screenHeight = love.graphics.getScaledMode()

	if x < self.PADDING then
		x = self.PADDING
	end

	if y < self.PADDING then
		y = self.PADDING
	end

	if x + width > screenWidth then
		x = screenWidth - width - self.PADDING
	end

	if y + height > screenHeight then
		y = screenHeight - height - self.PADDING
	end

	self:setPosition(x, y)
end

function GenericNotification:update(...)
	Interface.update(self, ...)

	local state = self:getState()
	if state.message ~= self.message then
		self.text:setText(state.message)

		local textStyle = self.text:getStyle()
		local _, lines = textStyle.font:getWrap(self.text:getText(), self.WIDTH - self.PADDING * 2)
		local wrappedHeight = #lines * textStyle.font:getHeight() * textStyle.font:getLineHeight()

		local x, y = itsyrealm.graphics.getScaledPoint(itsyrealm.mouse.getPosition())
		self:setSize(
			self.WIDTH,
			wrappedHeight + self.PADDING * 2)
		self:setPosition(x + self.PADDING, y - wrappedHeight - self.PADDING)
		self.panel:setSize(self:getSize())

		self:push()

		self.message = state.message
	end
end

return GenericNotification
