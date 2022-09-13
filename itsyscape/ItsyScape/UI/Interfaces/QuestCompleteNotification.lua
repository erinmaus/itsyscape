--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/QuestCompleteNotification.lua
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

local QuestCompleteNotification = Class(Interface)
QuestCompleteNotification.WIDTH = 420
QuestCompleteNotification.HEIGHT = 160
QuestCompleteNotification.PADDING = 4
QuestCompleteNotification.ICON_SIZE = 48

function QuestCompleteNotification:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	local x, y = w / 2 - QuestCompleteNotification.WIDTH / 2, 0
	do
		for _, interface in self:getView():getInterfaces("LevelUpNotification") do
			local interfaceWidth, interfaceHeight = interface:getSize()
			local interfaceX, interfaceY = interface:getPosition()
			y = math.max(interfaceY + interfaceHeight, y)
		end
	end

	self:setSize(QuestCompleteNotification.WIDTH, QuestCompleteNotification.HEIGHT)
	self:setPosition(x + QuestCompleteNotification.PADDING, y + QuestCompleteNotification.PADDING)

	local panel = Panel()
	panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/LevelUpNotification.9.png"
	}, self:getView():getResources()))
	panel:setSize(self:getSize())
	self:addChild(panel)

	local state = self:getState()

	local compassIcon = Icon()
	compassIcon:setPosition(
		QuestCompleteNotification.WIDTH / 2 - QuestCompleteNotification.ICON_SIZE / 2,
		QuestCompleteNotification.PADDING)
	compassIcon:setSize(
		QuestCompleteNotification.ICON_SIZE,
		QuestCompleteNotification.ICON_SIZE)
	compassIcon:setIcon(string.format("Resources/Game/UI/Icons/Things/Compass.png", state.skill))

	self:addChild(compassIcon)

	local text = Label()
	text:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = 22,
		textShadow = true,
		width = QuestCompleteNotification.WIDTH,
		align = 'center'
	}, self:getView():getResources()))
	text:setPosition(
		0,
		QuestCompleteNotification.ICON_SIZE + QuestCompleteNotification.PADDING * 2)
	text:setText(string.format(
		"Quest complete!\n%s",
		state.quest))
	self:addChild(text)

	panel:setSize(self:getSize())

	self:setZDepth(math.huge)
end

return QuestCompleteNotification
