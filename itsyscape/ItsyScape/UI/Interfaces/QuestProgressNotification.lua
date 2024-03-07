--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/QuestProgressNotification.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Tween = require "ItsyScape.Common.Math.Tween"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Drawable = require "ItsyScape.UI.Drawable"
local Icon = require "ItsyScape.UI.Icon"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Interface = require "ItsyScape.UI.Interface"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local RichTextLabel = require "ItsyScape.UI.RichTextLabel"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local Widget = require "ItsyScape.UI.Widget"

local QuestProgressNotification = Class(Interface)
QuestProgressNotification.WIDTH = 320
QuestProgressNotification.HEIGHT = 240
QuestProgressNotification.PADDING = 8
QuestProgressNotification.ICON_SIZE = 48
QuestProgressNotification.BUTTON_SIZE = 48
QuestProgressNotification.HINT_WIDTH = 240
QuestProgressNotification.HINT_HEIGHT = 128
QuestProgressNotification.SCROLL_TIME = 0.75

function QuestProgressNotification:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self:updatePosition()
	self:setSize(QuestProgressNotification.WIDTH, QuestProgressNotification.HEIGHT)

	local panel = Panel()
	panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Group.9.png"
	}, self:getView():getResources()))
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.closeButton = Button()
	self.closeButton:setSize(QuestProgressNotification.BUTTON_SIZE, QuestProgressNotification.BUTTON_SIZE)
	self.closeButton:setPosition(QuestProgressNotification.WIDTH - QuestProgressNotification.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	local icon = Icon()
	icon:setPosition(
		QuestProgressNotification.WIDTH / 2 - QuestProgressNotification.ICON_SIZE / 2,
		QuestProgressNotification.PADDING)
	icon:setSize(
		QuestProgressNotification.ICON_SIZE,
		QuestProgressNotification.ICON_SIZE)
	icon:setIcon("Resources/Game/UI/Icons/Things/Compass.png")
	self:addChild(icon)

	self.title = Label()
	self.title:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = 22,
		textShadow = true,
		width = QuestProgressNotification.WIDTH,
		align = 'center'
	}, self:getView():getResources()))
	self.title:setPosition(
		0,
		QuestProgressNotification.ICON_SIZE + QuestProgressNotification.PADDING * 2)
	self:addChild(self.title)

	self.infoPanel = ScrollablePanel(GridLayout)
	self.infoPanel:setSize(
		QuestProgressNotification.WIDTH - QuestProgressNotification.PADDING * 2,
		QuestProgressNotification.HEIGHT - QuestProgressNotification.PADDING * 3 - QuestProgressNotification.ICON_SIZE - 24)
	self.infoPanel:getInnerPanel():setWrapContents(true)
	self.infoPanel:getInnerPanel():setPadding(0, 0)
	self.infoPanel:getInnerPanel():setUniformSize(true, 1, 0)
	self.infoPanel:setFloatyScrollBars(false)
	self.infoPanel:setPosition(
		QuestProgressNotification.PADDING,
		QuestProgressNotification.PADDING * 3 + QuestProgressNotification.ICON_SIZE + 24)
	self:addChild(self.infoPanel)

	self.guideLabel = RichTextLabel()
	self.guideLabel:setSize(
		QuestProgressNotification.WIDTH,
		0)
	self.guideLabel:setWrapContents(true)
	self.guideLabel.onScroll:register(function(_, targetScroll)
		if self.targetScroll == targetScroll then
			return
		end

		local _

		_, self.currentScroll = self.infoPanel:getInnerPanel():getScroll()
		self.targetScroll = targetScroll
		self.scrollTime = 0
	end)
	self.guideLabel.onSize:register(function()
		self.infoPanel:performLayout()
	end)
	self.infoPanel:addChild(self.guideLabel)

	self:setZDepth(-1)

	self:updateQuest()
end

function QuestProgressNotification:getOverflow()
	return true
end

function QuestProgressNotification:updatePosition()
	local w, h = love.graphics.getScaledMode()
	local x, y = w - QuestProgressNotification.WIDTH - QuestProgressNotification.PADDING, QuestProgressNotification.PADDING

	self:setPosition(x, y)
end

function QuestProgressNotification:updateQuest()
	local state = self:getState()

	self.title:setText(state.questName or "")

	local label = state.steps and {
		state.steps[#state.steps - 1] or "",
		state.steps[#state.steps] or "",
	}

	self.guideLabel:setText(label or "")
end

function QuestProgressNotification:update(delta)
	Interface.update(self, delta)

	self:updatePosition()

	if self:getState().id == "PreTutorial" then
		self:removeChild(self.closeButton)
	elseif not self.closeButton:getParent() then
		self:addChild(self.closeButton)
	end

	if self.scrollTime then
		self.scrollTime = math.min(self.scrollTime + delta, QuestProgressNotification.SCROLL_TIME)
		local mu = Tween.sineEaseIn(self.scrollTime / QuestProgressNotification.SCROLL_TIME)

		local _, scrollSizeY = self.infoPanel:getScrollSize()
		local _, height = self.infoPanel:getSize()

		local scrollY = self.targetScroll * mu + self.currentScroll * (1 - mu)
		self.infoPanel:getInnerPanel():setScroll(0, math.min(scrollY, scrollSizeY - height))

		if mu >= 1 then
			self.scrollTime = nil
		end
	end
end

return QuestProgressNotification
