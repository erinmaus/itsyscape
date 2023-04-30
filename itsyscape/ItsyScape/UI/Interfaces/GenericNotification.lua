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
	local x, y = love.graphics.getScaledPoint(love.mouse.getPosition())

	self.panel = Panel()
	self.panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/GenericNotification.9.png"
	}, self:getView():getResources()))
	self.panel:setSize(self:getSize())
	self.panel:setIsClickThrough(true)
	self:addChild(self.panel)

	local state = self:getState()

	self.text = Label()
	self.text:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = 22,
		textShadow = true,
		width = GenericNotification.WIDTH - GenericNotification.PADDING * 2,
		align = 'left'
	}, self:getView():getResources()))
	self.text:setPosition(GenericNotification.PADDING, GenericNotification.PADDING)
	self.text:setText(state.message)
	self.text:setIsClickThrough(true)
	self:addChild(self.text)

	self.message = state.message

	local textStyle = self.text:getStyle()
	local _, lines = textStyle.font:getWrap(self.text:getText(), GenericNotification.WIDTH - GenericNotification.PADDING * 2)
	local wrappedHeight = #lines * textStyle.font:getHeight() * textStyle.font:getLineHeight()

	self:setSize(
		GenericNotification.WIDTH,
		wrappedHeight + GenericNotification.PADDING * 2)
	self:setPosition(x + GenericNotification.PADDING, y - wrappedHeight - GenericNotification.PADDING)

	self.panel:setSize(self:getSize())
	self:push()

	self:setZDepth(500)
	self:setIsClickThrough(true)
end

function GenericNotification:push()
	local x, y  = self:getPosition()
	local width, height = self:getSize()

	local screenWidth, screenHeight = love.graphics.getScaledMode()

	if x < GenericNotification.PADDING then
		x = GenericNotification.PADDING
	end

	if y < GenericNotification.PADDING then
		y = GenericNotification.PADDING
	end

	if x + width > screenWidth then
		x = screenWidth - width - GenericNotification.PADDING
	end

	if y + height > screenHeight then
		y = screenHeight - height - GenericNotification.PADDING
	end

	self:setPosition(x, y)
end

function GenericNotification:update(...)
	Interface.update(self, ...)

	local state = self:getState()
	if state.message ~= self.message then
		self.text:setText(state.message)

		local textStyle = self.text:getStyle()
		local _, lines = textStyle.font:getWrap(self.text:getText(), GenericNotification.WIDTH - GenericNotification.PADDING * 2)
		local wrappedHeight = #lines * textStyle.font:getHeight() * textStyle.font:getLineHeight()

		local x, y = love.graphics.getScaledPoint(love.mouse.getPosition())
		self:setSize(
			GenericNotification.WIDTH,
			wrappedHeight + GenericNotification.PADDING * 2)
		self:setPosition(x + GenericNotification.PADDING, y - wrappedHeight - GenericNotification.PADDING)
		self.panel:setSize(self:getSize())

		self:push()

		self.message = state.message
	end
end

return GenericNotification
