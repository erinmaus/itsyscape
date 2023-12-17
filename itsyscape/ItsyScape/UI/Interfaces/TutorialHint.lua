--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/TutorialHint.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Drawable = require "ItsyScape.UI.Drawable"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Interface = require "ItsyScape.UI.Interface"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"

local TutorialHint = Class(Interface)
TutorialHint.PADDING = 8
TutorialHint.Z_DEPTH = 100000

TutorialHint.Circle = Class(Drawable)
function TutorialHint.Circle:new()
	Drawable.new(self)

	self.radius = 32
end

function TutorialHint.Circle:getOverflow()
	return true
end

function TutorialHint.Circle:getRadius()
	return self.radius
end

function TutorialHint.Circle:setRadius(value)
	self.radius = value or self.radius
end

function TutorialHint.Circle:draw()
	local time = love.timer.getTime()
	local alpha = math.sin(time * math.pi * 2)

	love.graphics.setLineWidth(4)
	love.graphics.setBlendMode('alpha')
	love.graphics.setColor(0, 0, 0, alpha)
	itsyrealm.graphics.circle('line', 1, 1, self.radius)
	love.graphics.setColor(1, 1, 0, alpha)
	itsyrealm.graphics.circle('line', 0, 0, self.radius)
	love.graphics.setColor(1, 1, 1, 1)
end

TutorialHint.Rectangle = Class(Drawable)
function TutorialHint.Rectangle:getOverflow()
	return true
end

function TutorialHint.Rectangle:draw()
	local time = love.timer.getTime()
	local alpha = math.sin(time * math.pi * 2)

	love.graphics.setLineWidth(4)

	local w, h = self:getSize()
	love.graphics.setColor(0, 0, 0, alpha)
	itsyrealm.graphics.rectangle('line', 1, 1, w, h, 4, 4)
	love.graphics.setColor(1, 1, 0, alpha)
	itsyrealm.graphics.rectangle('line', 0, 0, w, h, 4, 4)
	love.graphics.setColor(1, 1, 1, 1)
end

function TutorialHint:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local _, _, _, _, offsetX, offsetY = love.graphics.getScaledMode()
	self:setPosition(-offsetX, -offsetY)

	local state = self:getState()

	self.panel = Panel()
	self.panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Hint.9.png"
	}, ui:getResources()))
	self:addChild(self.panel)

	self.label = Label()
	self.label:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = 24,
		textShadow = true,
		color = { 1, 1, 1, 1 },
		align = 'center'
	}, ui:getResources()))
	self.label:setText(state.message)
	self:addChild(self.label)

	self:setZDepth(TutorialHint.Z_DEPTH)
end

function TutorialHint:getOverflow()
	return true
end

function TutorialHint:place(widget)
	local state = self:getState()

	local targetX, targetY = widget:getAbsolutePosition()
	local targetWidth, targetHeight = widget:getSize()

	local textWidth, textHeight
	do
		local font = self.label:getStyle().font
		textWidth = font:getWidth(state.message or "")

		local numLines = select(2, state.message:gsub("\n", ""))
		textHeight = (numLines + 1) * font:getHeight() * font:getLineHeight()
	end

	local x, y
	if state.position == 'center' then
		x = (targetX + targetWidth / 2) - textWidth / 2
		y = (targetY + targetHeight / 2) - textHeight / 2
	else
		if state.position == 'up' then
			x = (targetX + targetWidth / 2) - textWidth / 2
			y = targetY - textHeight - TutorialHint.PADDING * 3
		elseif state.position == 'down' then
			x = (targetX + targetWidth / 2) - textWidth / 2
			y = targetY + targetHeight + TutorialHint.PADDING * 3
		elseif state.position == 'left' then
			x = targetX - textWidth - TutorialHint.PADDING * 3
			y = (targetY + targetHeight / 2) - textHeight / 2
		elseif state.position == 'right' then
			x = targetX + targetWidth + TutorialHint.PADDING * 3
			y = (targetY + targetHeight / 2) - textHeight / 2
		end

		local screenWidth, screenHeight = love.graphics.getScaledMode()

		x = math.min(math.max(x, 0), screenWidth - textWidth)
		y = math.min(math.max(y, 0), screenHeight - textHeight)
	end

	self.messageX = x
	self.messageY = y

	self.label:setPosition(x, y)
	self.label:setSize(textWidth, textHeight)
	self.panel:setPosition(
		x - TutorialHint.PADDING,
		y - TutorialHint.PADDING)
	self.panel:setSize(
		textWidth + TutorialHint.PADDING * 2,
		textHeight + TutorialHint.PADDING * 2)
end

function TutorialHint:getTargetWidget(Type)
	if not self.targetWidget or not self.targetWidget:isCompatibleType(Type) then
		if self.targetWidget then
			self:removeChild(self.targetWidget)
		end

		self.targetWidget = Type()
		self:addChild(self.targetWidget)
	end

	return self.targetWidget
end

function TutorialHint:highlight(widget)
	local state = self:getState()

	local targetX, targetY = widget:getAbsolutePosition()
	local targetWidth, targetHeight = widget:getSize()

	if state.style == 'circle' then
		local circle = self:getTargetWidget(TutorialHint.Circle)

		local radius = (math.max(targetWidth, targetHeight) * (3 / 4)) + 4
		circle:setRadius(radius)
		circle:setPosition(targetX + targetWidth / 2, targetY + targetHeight / 2)
	elseif state.style == 'rectangle' then
		local rectangle = self:getTargetWidget(TutorialHint.Rectangle)

		rectangle:setPosition(targetX - 4, targetY - 4)
		rectangle:setSize(targetWidth + 8, targetHeight + 8)
	end
end

function TutorialHint:update(...)
	Interface.update(self, ...)

	local state = self:getState()
	local uiView = self:getView()
	local widget = uiView:findWidgetByID(state.id)

	if widget then
		self:place(widget)

		if widget ~= self:getView():getRoot() then
			self:highlight(widget)
		end
	end
end

return TutorialHint
