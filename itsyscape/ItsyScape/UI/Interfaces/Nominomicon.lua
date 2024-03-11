--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Nominomicon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Interface = require "ItsyScape.UI.Interface"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local RichTextLabel = require "ItsyScape.UI.RichTextLabel"
local ToolTip = require "ItsyScape.UI.ToolTip"

local Nominomicon = Class(Interface)
Nominomicon.WIDTH = 800
Nominomicon.HEIGHT = 480
Nominomicon.BUTTON_SIZE = 48
Nominomicon.BUTTON_PADDING = 4
Nominomicon.PADDING = 4

Nominomicon.INACTIVE_BUTTON_STYLE = function(icon, color)
	return {
		pressed = "Resources/Renderers/Widget/Button/Default-Pressed.9.png",
		inactive = "Resources/Renderers/Widget/Button/Default-Inactive.9.png",
		hover = "Resources/Renderers/Widget/Button/Default-Hover.9.png",
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
		icon = {
			filename = icon,
			x = 0.1,
			color = color or { 1, 1, 1, 1 }
		},
		color = color or { 1, 1, 1, 1 },
		fontSize = _MOBILE and 22 or 16,
		textShadow = true,
		textShadowOffset = 2
	}
end

Nominomicon.ACTIVE_BUTTON_STYLE = function(icon, color)
	return {
		pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
		inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
		hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png",
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
		icon = {
			filename = icon,
			x = 0.1,
			color = color or { 1, 1, 1, 1 }
		},
		color = color or { 1, 1, 1, 1 },
		fontSize = _MOBILE and 22 or 16,
		textShadow = true,
		textShadowOffset = 2
	}
end

function Nominomicon:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	local WIDTH = math.max(math.floor(w / 2), Nominomicon.WIDTH)
	local HEIGHT = math.max(math.floor(h / 2), Nominomicon.HEIGHT)

	self:setSize(WIDTH, HEIGHT)
	self:setPosition(
		(w - WIDTH) / 2,
		(h - HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.grid = ScrollablePanel(GridLayout)
	self.grid:getInnerPanel():setUniformSize(
		true,
		1,
		Nominomicon.BUTTON_SIZE + Nominomicon.BUTTON_PADDING * 2)
	self.grid:getInnerPanel():setWrapContents(true)
	self.grid:getInnerPanel():setPadding(Nominomicon.BUTTON_PADDING)
	self.grid:setSize(WIDTH * (1 / 2), HEIGHT - Nominomicon.BUTTON_SIZE - Nominomicon.PADDING)
	self:addChild(self.grid)

	self.toggleButton = Button()
	self.toggleButton:setSize(
		WIDTH * (1 / 2) - Nominomicon.PADDING * 2,
		Nominomicon.BUTTON_SIZE)
	self.toggleButton:setPosition(Nominomicon.PADDING, HEIGHT - Nominomicon.BUTTON_SIZE - Nominomicon.PADDING)
	self.toggleButton.onClick:register(function()
		self:sendPoke("toggleShowQuestProgress", nil, {})
	end)
	self:updateToggleButton()
	self:addChild(self.toggleButton)

	self.infoPanel = ScrollablePanel(GridLayout)
	self.infoPanel:setScrollBarOffset(Nominomicon.BUTTON_SIZE)
	self.infoPanel:getInnerPanel():setWrapContents(true)
	self.infoPanel:getInnerPanel():setPadding(0, 0)
	self.infoPanel:getInnerPanel():setUniformSize(true, 1, 0)
	self.infoPanel:getInnerPanel():setSize(WIDTH * (1 / 2), 0)
	self.infoPanel:setPosition(WIDTH * (1 / 2), 0)
	self.infoPanel:setSize(WIDTH * (1 / 2), HEIGHT)

	self.bossPanel = ScrollablePanel(GridLayout)
	self.bossPanel:setScrollBarOffset(Nominomicon.BUTTON_SIZE)
	self.bossPanel:getInnerPanel():setWrapContents(true)
	self.bossPanel:getInnerPanel():setPadding(0, 0)
	self.bossPanel:getInnerPanel():setUniformSize(true, 1, 0)
	self.bossPanel:getInnerPanel():setSize(WIDTH * (1 / 2), 0)
	self.bossPanel:setPosition(WIDTH * (1 / 2), 0)
	self.bossPanel:setSize(WIDTH * (1 / 2), HEIGHT)

	self.guideLabel = RichTextLabel()
	self.guideLabel:setSize(WIDTH * (1 / 2), 0)
	self.guideLabel:setWrapContents(true)
	self.guideLabel:setWrapParentContents(true)
	self.guideLabel.onSize:register(function()
		self.infoPanel:performLayout()
	end)
	self.infoPanel:addChild(self.guideLabel)

	self.closeButton = Button()
	self.closeButton:setSize(Nominomicon.BUTTON_SIZE, Nominomicon.BUTTON_SIZE)
	self.closeButton:setPosition(WIDTH - Nominomicon.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)
	self.closeButton:setZDepth(2)

	self.ready = false
	self.activeItem = false
	self.previousSelection = false
end

function Nominomicon:updateToggleButton()
	local hideQuestProgress = self:getState().hideQuestProgress

	if self.hideQuestProgress ~= hideQuestProgress then
		if not hideQuestProgress then
			self.toggleButton:setStyle(
				ButtonStyle(
					Nominomicon.ACTIVE_BUTTON_STYLE(),
					self:getView():getResources()))
			self.toggleButton:setText("Toggle Quest HUD Off")
			self.toggleButton:setToolTip(
				"Currently, the quest HUD is enabled.",
				"Click the button to disable the quest HUD.")
		else
			self.toggleButton:setStyle(
				ButtonStyle(
					Nominomicon.INACTIVE_BUTTON_STYLE(),
					self:getView():getResources()))
			self.toggleButton:setText("Toggle Quest HUD On")
			self.toggleButton:setToolTip(
				"Currently, the quest HUD is disabled.",
				"Click the button to enable the quest HUD.")
		end

		self.hideQuestProgress = hideQuestProgress
	end
end

function Nominomicon:getQuestStatusIcon(quest)
	if not quest.isQuest then
		return nil
	elseif quest.didComplete then
		return "Resources/Game/UI/Icons/Concepts/Complete.png"
	elseif quest.inProgress then
		return "Resources/Game/UI/Icons/Things/Compass.png"
	elseif not quest.canStart then
		return "Resources/Game/UI/Icons/Concepts/Lock.png", { 0.5, 0.5, 0.5, 1.0 }
	else
		return nil
	end
end

function Nominomicon:update(...)
	Interface.update(self, ...)

	if not self.ready then
		local state = self:getState()

		for i = 1, #state.quests do
			local quest = state.quests[i]

			local button = Button()
			button:setText(quest.name)
			button:setToolTip(
				ToolTip.Header(quest.name),
				ToolTip.Text(quest.description))
			button.onClick:register(self.selectItem, self, i)

			button:setStyle(
				ButtonStyle(
					Nominomicon.INACTIVE_BUTTON_STYLE(self:getQuestStatusIcon(quest)),
					self:getView():getResources()))
			button:setData("quest", quest)
			button:setID("Quest-" .. quest.id)

			self.grid:addChild(button)
		end

		self.grid:setScrollSize(self.grid:getInnerPanel():getSize())

		self.ready = true
	end

	if self.doFlagResizeLayout then
		if self.bossPanel then
			self.bossPanel:performLayout()
			self.bossPanel:setScroll(0, 0)
		end

		self.doFlagResizeLayout = false
	end

	self:updateToggleButton()
end

function Nominomicon:selectItem(index, button, mouseButton)
	local state = self:getState()
	local quest = state.quests[index]

	if mouseButton == 1 then
		if self.previousSelection then
			self.previousSelection:setStyle(
				ButtonStyle(
					Nominomicon.INACTIVE_BUTTON_STYLE(self:getQuestStatusIcon(self.previousSelection:getData("quest"))),
					self:getView():getResources()))
		end

		if self.previousSelection ~= button then
			button:setStyle(
				ButtonStyle(
					Nominomicon.ACTIVE_BUTTON_STYLE(self:getQuestStatusIcon(quest)),
					self:getView():getResources()))

			self.activeItem = index
			self.previousSelection = button

			self:sendPoke("select", nil, { index = index })
		else
			self.activeItem = false
			self.previousSelection = false
			self.guideLabel:setText("")
		end
	elseif mouseButton == 2 and quest.isQuest then
		local actions = {}

		table.insert(actions, {
			id = "view",
			verb = "View-Log",
			object = button:getText(),
			callback = function()
				self:selectItem(index, button, 1)
			end
		})

		if not quest.didComplete then
			table.insert(actions, {
				id = "show-guide",
				verb = "Show-Guide",
				object = button:getText(),
				callback = function()
					self:sendPoke("openQuestProgress", nil, { index = index })
				end
			})
		end

		self:getView():probe(actions)
	end
end

function Nominomicon:updateGuide()
	local state = self:getState()
	local currentQuest = state.currentQuest

	self.infoPanel:getInnerPanel():clearChildren()
	self.bossPanel:getInnerPanel():clearChildren()

	if currentQuest.bosses then
		self:removeChild(self.infoPanel)
		self:showBossDrops(currentQuest.bosses)
	else
		self:removeChild(self.bossPanel)

		self.infoPanel:addChild(self.guideLabel)
		self.guideLabel:setText(currentQuest)
		self.infoPanel:getInnerPanel():setScroll(0, 0)

		self:addChild(self.infoPanel)
	end
end

function Nominomicon:flagResizeLayout()
	self.doFlagResizeLayout = true
end

function Nominomicon:showBossDrops(bosses)
	local w, h = self.bossPanel:getInnerPanel():getSize()

	if not _MOBILE then
		w = w - ScrollablePanel.DEFAULT_SCROLL_SIZE
	end

	local root = self.bossPanel:getInnerPanel()

	for _, area in ipairs(bosses) do
		local areaLabel = RichTextLabel()
		areaLabel:setWrapContents(true)
		areaLabel:setSize(w, 0)
		areaLabel:setText({
			{
				t = "header",
				area.name
			},
			area.description
		})

		areaLabel.onSize:register(self.flagResizeLayout, self)

		root:addChild(areaLabel)

		for _, boss in ipairs(area.bosses) do
			if boss.count >= 1 or (not boss.isSpecial or _DEBUG) then
				local bossLabel = RichTextLabel()
				bossLabel:setWrapContents(true)
				bossLabel:setSize(w, 0)
				bossLabel:setText({
					{
						t = "header",
						boss.name
					},
					boss.description,
					"",
					boss.count >= 1 and string.format("You've killed %s %d %s.", boss.name, boss.count, boss.count > 1 and "times" or "time") or "You haven't killed this boss yet."
				})

				root:addChild(bossLabel)

				local itemLayout = GridLayout()
				itemLayout:setWrapContents(true)
				itemLayout:setPadding(Nominomicon.PADDING, Nominomicon.PADDING)
				itemLayout:setSize(w, 0)
				itemLayout:setUniformSize(true, ItemIcon.DEFAULT_SIZE, ItemIcon.DEFAULT_SIZE)

				for _, item in ipairs(boss.items) do
					local icon = ItemIcon()
					icon:setItemID(item.id)
					icon:setItemCount(item.count)
					icon:setIsDisabled(item.count == 0)
					icon:setToolTip(
						ToolTip.Header(item.name),
						ToolTip.Text(item.description))

					itemLayout:addChild(icon)
				end

				local _, itemLayoutHeight = itemLayout:getSize()
				local background = Panel()
				background:setStyle(PanelStyle({
					image = "Resources/Renderers/Widget/Panel/Group.9.png"
				}, self:getView():getResources()))
				background:setSize(w, itemLayoutHeight + Nominomicon.PADDING)
				background:addChild(itemLayout)

				root:addChild(background)
			end
		end
	end

	self:addChild(self.bossPanel)
end

return Nominomicon