--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Common/EquipmentStatsPanel.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Config = require "ItsyScape.Game.Config"
local Curve = require "ItsyScape.Game.Curve"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Icon = require "ItsyScape.UI.Icon"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Widget = require "ItsyScape.UI.Widget"

local EquipmentStatsPanel = Class(Widget)

EquipmentStatsPanel.DEFAULT_STAT_ROW_HEIGHT = 24
EquipmentStatsPanel.DEFAULT_TITLE_ROW_HEIGHT = 32
EquipmentStatsPanel.DEFAULT_MAX_STAT_ROWS = 8
EquipmentStatsPanel.DEFAULT_MAX_TITLE_ROWS = 2
EquipmentStatsPanel.DEFAULT_PADDING = 4

EquipmentStatsPanel.DEFAULT_WIDTH = 264
EquipmentStatsPanel.DEFAULT_HEIGHT = EquipmentStatsPanel.DEFAULT_STAT_ROW_HEIGHT * EquipmentStatsPanel.DEFAULT_MAX_STAT_ROWS + EquipmentStatsPanel.DEFAULT_MAX_TITLE_ROWS * EquipmentStatsPanel.DEFAULT_TITLE_ROW_HEIGHT

EquipmentStatsPanel.ACCURACY = {
	{ "AccuracyStab", "Stab" },
	{ "AccuracySlash", "Slash" },
	{ "AccuracyCrush", "Crush" },
	{ "AccuracyMagic", "Magic" },
	{ "AccuracyRanged", "Archery" }
}

EquipmentStatsPanel.DEFENSE = {
	{ "DefenseStab", "Stab" },
	{ "DefenseSlash", "Slash" },
	{ "DefenseCrush", "Crush" },
	{ "DefenseMagic", "Magic" },
	{ "DefenseRanged", "Archery" }
}

EquipmentStatsPanel.STRENGTH = {
	{ "StrengthMelee", "Melee" },
	{ "StrengthMagic", "Magic" },
	{ "StrengthRanged", "Archery" }
}

EquipmentStatsPanel.MISC = {
	{ "Prayer", "Divinity" }
}

function EquipmentStatsPanel:new(uiView, config)
	Widget.new(self)

	self.uiView = uiView
	self.config = config or {}

	self.statRowHeight = self.config.statRowHeight or self.DEFAULT_STAT_ROW_HEIGHT
	self.titleRowHeight = self.config.titleRowHeight or self.DEFAULT_TITLE_ROW_HEIGHT
	self.padding = self.config.padding or self.DEFAULT_PADDING

	self:setSize(
		self.config.width or self.DEFAULT_WIDTH,
		self.config.height or (self.DEFAULT_MAX_STAT_ROWS * self.DEFAULT_STAT_ROW_HEIGHT + self.titleRowHeight * self.DEFAULT_MAX_TITLE_ROWS))

	local width, height = self:getSize()

	self.statLayout = GridLayout()
	self.statLayout:setPadding(0, 0)
	self:addChild(self.statLayout)

	self.statLabels = {}
	self.differenceLabels = {}
	self.halfRows = {}
	self:_emitLayout(self.ACCURACY, "Attack")
	self:_emitLayout(self.DEFENSE, "Defense")
	self:_emitLayout(self.STRENGTH, "Strength")
	self:_emitLayout(self.MISC, "Misc")

	self:performLayout()
end

function EquipmentStatsPanel:_reset()
	for _, statLabel in pairs(self.statLabels) do
		statLabel:setText("0")
	end

	for _, differenceLabel in pairs(self.differenceLabels) do
		differenceLabel:setText("")
	end
end

function EquipmentStatsPanel:compareStats(stats, otherStats)
	if not otherStats then
		self:updateStats(stats)
		return
	end

	self:_reset()

	local better = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.stat.better"))
	local worse = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.stat.worse"))
	local neutral = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.stat.neutral"))
	local zero = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.stat.zero"))

	for _, statInfo in ipairs(stats) do
		local statName = statInfo.name
		local statValue = statInfo.value
		local otherStatValue = 0

		for _, otherStatInfo in ipairs(otherStats) do
			if otherStatInfo.name == statName then
				otherStatValue = otherStatInfo.value
				break
			end
		end

		local color, sign
		if statValue > otherStatValue then
			color = better
			sign = "+"
		elseif statValue < otherStatValue then
			color = worse
			sign = "-"
		else
			if statValue == 0 then
				color = zero
			else
				color = neutral
			end

			sign = "="
		end

		local statLabel = self.statLabels[statName]
		if statLabel then
			statLabel:setText({
				{ color:get() },
				string.format("%d", statValue)
			})
		end

		local differenceLabel = self.differenceLabels[statName]
		if differenceLabel then
			differenceLabel:setText({
				{ color:get() },
				string.format("%s", sign)
			})
		end
	end
end

function EquipmentStatsPanel:updateStats(stats)
	self:_reset()

	for _, statInfo in ipairs(stats) do
		local statName = statInfo.name
		local statValue = statInfo.value

		local statLabel = self.statLabels[statName]
		if statLabel then
			statLabel:setText(string.format("%d", statValue))
		end

		local differenceLabel = self.differenceLabels[statName]
		if differenceLabel then
			differenceLabel:setText("")
		end
	end
end

function EquipmentStatsPanel:_emitLayout(statsInfo, titleText)
	local width, height = self:getSize()
	local rowWidth = math.floor(width / 2)

	local layout = GridLayout()
	layout:setSize(rowWidth, 0)
	layout:setPadding(self.padding, self.padding)
	layout:setWrapContents(true)
	table.insert(self.halfRows, layout)

	local titleLabel = Label()
	titleLabel:setSize(rowWidth, self.titleRowHeight - self.padding * 2)
	titleLabel:setText(titleText)
	titleLabel:setStyle(LabelStyle({
		fontSize = self.titleRowHeight - self.padding * 2,
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
		textShadow = true
	}, self.uiView:getResources()))
	layout:addChild(titleLabel)

	local statLabelStyle = LabelStyle({
		fontSize = self.statRowHeight - self.padding * 2,
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
		textShadow = true
	}, self.uiView:getResources())

	local statDifferenceSize = math.max(statLabelStyle.font:getWidth("+"), statLabelStyle.font:getWidth("="), statLabelStyle.font:getWidth("-"))

	for _, statInfo in ipairs(statsInfo) do
		local statName, statText = unpack(statInfo)

		local statNameLabel = Label()
		statNameLabel:setStyle(statLabelStyle)
		statNameLabel:setSize(
			math.floor(rowWidth / 2),
			self.statRowHeight - self.padding * 2)
		statNameLabel:setText(statText)
		layout:addChild(statNameLabel)

		local statValueLabel = Label()
		statValueLabel:setSize(
			math.floor(rowWidth / 2) - self.padding * 4 - statDifferenceSize,
			self.statRowHeight - self.padding * 2)
		statValueLabel:setText("0")
		statValueLabel:setStyle(statLabelStyle)
		layout:addChild(statValueLabel)

		local statDifferenceLabel = Label()
		statDifferenceLabel:setSize(statDifferenceSize, self.statRowHeight - self.padding * 2)
		statDifferenceLabel:setStyle(statLabelStyle)
		layout:addChild(statDifferenceLabel)

		self.statLabels[statName] = statValueLabel
		self.differenceLabels[statName] = statDifferenceLabel
	end

	self.statLayout:addChild(layout)
end

function EquipmentStatsPanel:performLayout()
	local width, height = self:getSize()

	self.statLayout:setSize(width, height)

	local width, height = self:getSize()
	local rowWidth = math.floor(width / 2)

	for _, halfRow in ipairs(self.halfRows) do
		halfRow:setSize(rowWidth, 0)
		halfRow:performLayout()
	end

	self.statLayout:performLayout()
end

return EquipmentStatsPanel
