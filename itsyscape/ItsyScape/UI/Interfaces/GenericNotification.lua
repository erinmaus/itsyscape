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

	local panel = Panel()
	panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/LevelUpNotification.9.png"
	}, self:getView():getResources()))
	panel:setSize(self:getSize())
	self:addChild(panel)

	local state = self:getState()

	local text = Label()
	text:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = 22,
		textShadow = true,
		width = GenericNotification.WIDTH - GenericNotification.PADDING * 2,
		align = 'left'
	}, self:getView():getResources()))
	text:setPosition(GenericNotification.PADDING, GenericNotification.PADDING)
	text:setText(state.message)
	self:addChild(text)

	local textStyle = text:getStyle()
	local _, lines = textStyle.font:getWrap(text:getText(), GenericNotification.WIDTH - GenericNotification.PADDING * 2)
	local wrappedHeight = #lines * textStyle.font:getHeight() * textStyle.font:getLineHeight()

	self:setSize(
		GenericNotification.WIDTH,
		wrappedHeight + GenericNotification.PADDING * 2)
	self:setPosition(x + GenericNotification.PADDING, y - wrappedHeight - GenericNotification.PADDING)

	panel:setSize(self:getSize())

	self:setZDepth(math.huge)
end

return GenericNotification
