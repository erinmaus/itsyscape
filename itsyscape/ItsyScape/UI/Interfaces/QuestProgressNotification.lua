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
QuestProgressNotification.HEIGHT = 300
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

	local titlePanel = Panel()
	titlePanel:setStyle({
		image = "Resources/Game/UI/Panels/WindowTitle.png"
	}, PanelStyle)
	titlePanel:setSize(self.WIDTH, self.ICON_SIZE + self.PADDING * 2)
	self:addChild(titlePanel)

	local contentPanel = Panel()
	contentPanel:setStyle(PanelStyle({
		image = "Resources/Game/UI/Panels/WindowContent.png"
	}, self:getView():getResources()))
	contentPanel:setSize(self.WIDTH, self.HEIGHT - self.ICON_SIZE - self.PADDING * 2)
	contentPanel:setPosition(0, self.ICON_SIZE + self.PADDING * 2)
	self:addChild(contentPanel)

	self.closeButton = Button()
	self.closeButton:setSize(QuestProgressNotification.BUTTON_SIZE, QuestProgressNotification.BUTTON_SIZE)
	self.closeButton:setPosition(QuestProgressNotification.WIDTH - QuestProgressNotification.BUTTON_SIZE - QuestProgressNotification.PADDING, QuestProgressNotification.PADDING)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	local icon = Icon()
	icon:setPosition(QuestProgressNotification.PADDING, QuestProgressNotification.PADDING)
	icon:setSize(QuestProgressNotification.ICON_SIZE, QuestProgressNotification.ICON_SIZE)
	icon:setIcon("Resources/Game/UI/Icons/Things/Compass.png")
	titlePanel:addChild(icon)

	self.title = Label()
	self.title:setStyle({
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		color = { 1, 1, 1, 1 },
		fontSize = QuestProgressNotification.ICON_SIZE / 2 - 2,
		textShadow = true,
		spaceLines = true
	}, LabelStyle)
	self.title:setPosition(
		QuestProgressNotification.ICON_SIZE + QuestProgressNotification.PADDING * 2,
		QuestProgressNotification.PADDING)
	self.title:setSize(
		QuestProgressNotification.WIDTH - QuestProgressNotification.ICON_SIZE * 2 - QuestProgressNotification.PADDING * 4,
		QuestProgressNotification.ICON_SIZE)
	titlePanel:addChild(self.title)

	local contentWidth, contentHeight = contentPanel:getSize()

	self.infoPanel = ScrollablePanel(GridLayout)
	self.infoPanel:setSize(contentWidth - self.PADDING * 2, contentHeight - self.PADDING * 2)
	self.infoPanel:setPosition(QuestProgressNotification.PADDING, QuestProgressNotification.PADDING)
	self.infoPanel:getInnerPanel():setWrapContents(true)
	self.infoPanel:getInnerPanel():setPadding(0, 0)
	self.infoPanel:getInnerPanel():setUniformSize(true, 1, 0)
	self.infoPanel:setFloatyScrollBars(false)
	contentPanel:addChild(self.infoPanel)

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
end

function QuestProgressNotification:getOverflow()
	return true
end

function QuestProgressNotification:updatePosition()
	local w, h = love.graphics.getScaledMode()
	local x, y = w - QuestProgressNotification.WIDTH - QuestProgressNotification.PADDING, QuestProgressNotification.PADDING

	self:setPosition(x, y)
end

function QuestProgressNotification:updateQuestSteps(steps)
	local state = self:getState()

	self.title:setText(state.questName or "")

	local label = steps and {
		steps[#steps - 1] or "",
		steps[#steps] or "",
	}

	self.guideLabel:setText(label or "")
end

function QuestProgressNotification:updateQuestHints(hints)
	Log.info("Updating hints: %s", Log.dump(hints))
end

function QuestProgressNotification:update(delta)
	Interface.update(self, delta)

	self:updatePosition()

	if self:getState().id == "Tutorial" then
		self:removeChild(self.closeButton)
		self.title:setSize(
			QuestProgressNotification.WIDTH - QuestProgressNotification.ICON_SIZE - QuestProgressNotification.PADDING * 3,
			QuestProgressNotification.ICON_SIZE)
	elseif not self.closeButton:getParent() then
		self:addChild(self.closeButton)
		self.title:setSize(
			QuestProgressNotification.WIDTH - QuestProgressNotification.ICON_SIZE * 2 - QuestProgressNotification.PADDING * 4,
			QuestProgressNotification.ICON_SIZE)
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
