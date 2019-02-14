--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/LevelUpNotification.lua
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

local LevelUpNotification = Class(Interface)
LevelUpNotification.WIDTH = 320
LevelUpNotification.HEIGHT = 120
LevelUpNotification.PADDING = 4
LevelUpNotification.BOTTOM = 16
LevelUpNotification.ICON_SIZE = 46

function LevelUpNotification:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.window.getMode()
	local x, y = w / 2 - LevelUpNotification.WIDTH / 2, 0
	do
		for _, interface in self:getView():getInterfaces(id) do
			local interfaceWidth, interfaceHeight = interface:getSize()
			local interfaceX, interfaceY = interface:getPosition()
			y = math.max(interfaceY + interfaceHeight, y)
		end
	end

	self:setPosition(x + LevelUpNotification.PADDING, y + LevelUpNotification.PADDING)

	local panel = Panel()
	panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/LevelUpNotification.9.png"
	}, self:getView():getResources()))
	self:addChild(panel)

	local state = self:getState()

	local skillIcon = Icon()
	skillIcon:setPosition(
		LevelUpNotification.WIDTH / 2 - LevelUpNotification.ICON_SIZE / 2,
		LevelUpNotification.PADDING)
	skillIcon:setSize(
		LevelUpNotification.ICON_SIZE,
		LevelUpNotification.ICON_SIZE)
	skillIcon:setIcon(string.format("Resources/Game/UI/Icons/Skills/%s.png", state.skill))

	self:addChild(skillIcon)

	local text = Label()
	text:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = 22,
		textShadow = true,
		width = LevelUpNotification.WIDTH,
		align = 'center'
	}, self:getView():getResources()))
	text:setPosition(
		0,
		LevelUpNotification.ICON_SIZE + LevelUpNotification.PADDING * 2)
	text:setText(string.format(
		"Congratulations on level %d %s!\nClick here to see the skill guide.",
		state.level, state.skill))
	self:addChild(text)

	self:setSize(LevelUpNotification.WIDTH, LevelUpNotification.HEIGHT)
	panel:setSize(self:getSize())

	self:setZDepth(math.huge)
end

function LevelUpNotification:getIsFocusable()
	return true
end

function LevelUpNotification:mouseRelease(x, y, button, ...)
	print 'yes'
	Interface.mouseRelease(self, x, y, button, ...)

	print('button', button)
	if button == 1 then
		self:sendPoke("open", nil, {})
	end
end

return LevelUpNotification
