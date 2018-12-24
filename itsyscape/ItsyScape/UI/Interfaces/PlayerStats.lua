--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/PlayerStats.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Widget = require "ItsyScape.UI.Widget"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local ToolTip = require "ItsyScape.UI.ToolTip"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local PlayerTab = require "ItsyScape.UI.Interfaces.PlayerTab"

local PlayerStats = Class(PlayerTab)
PlayerStats.PADDING = 8
PlayerStats.BUTTON_WIDTH = 72
PlayerStats.BUTTON_HEIGHT = 32
PlayerStats.SORT_ORDER = {
	["Magic"] = 1,
	["Wisdom"] = 2,
	["Constitution"] = 3,
	["Attack"] = 4,
	["Strength"] = 5,
	["Defense"] = 6,
	["Archery"] = 7,
	["Dexterity"] = 8,
	["Faith"] = 9,
	["Mining"] = 10,
	["Smithing"] = 11,
	["Crafting"] = 12,
	["Woodcutting"] = 13,
	["Firemaking"] = 14,
	["Fletching"] = 15,
	["Fishing"] = 16,
	["Cooking"] = 17,
	["Sailing"] = 18
}

function PlayerStats:new(id, index, ui)
	PlayerTab.new(self, id, index, ui)

	local panel = Panel()
	panel = Panel()
	panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Default.9.png"
	}, ui:getResources()))
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.layout = GridLayout()
	self.layout:setUniformSize(
		true,
		PlayerStats.BUTTON_WIDTH,
		PlayerStats.BUTTON_HEIGHT)
	self.layout:setPadding(PlayerStats.PADDING, PlayerStats.PADDING)
	panel:addChild(self.layout)

	self.layout:setSize(self:getSize())
end

function PlayerStats:performLayout()
	PlayerTab.performLayout(self)

	if self.buttons then
		for i = 1, #self.buttons do
			self:removeChild(self.buttons[i])
		end
	end
end

function PlayerStats:update(...)
	PlayerTab.update(self, ...)

	local state = self:getState()
	table.sort(
		state.skills,
		function(a, b)
			local i = PlayerStats.SORT_ORDER[a.name] or 0
			local j = PlayerStats.SORT_ORDER[b.name] or 0
			return i < j
		end)

	if not self.buttons or #self.buttons ~= #state.skills then
		if self.buttons then
			for i = 1, #self.buttons do
				self.layout:removeChild(self.buttons[i])
			end
		end

		self.buttons = {}
		self:populate(state.skills)
	end

	self:updateStats(state.skills)
end

function PlayerStats:populate(skills)
	for i = 1, #skills do
		local button = Button()

		table.insert(self.buttons, button)
		self.layout:addChild(button)
	end
end

function PlayerStats:updateStats(skills)
	for i = 1, #skills do
		local button = self.buttons[i]
		button:setData(skills[i].name)
		button:setText(string.format("%d/%d", skills[i].workingLevel, skills[i].baseLevel))

		local image, color
		if skills[i].workingLevel > skills[i].baseLevel then
			image = "Resources/Renderers/Widget/Button/Skill-Boosted.9.png"
			color = { Color(0, 1, 0, 1):get() }
		elseif skills[i].workingLevel < skills[i].baseLevel then
			image = "Resources/Renderers/Widget/Button/Skill-Debuffed.9.png"
			color = { Color(1, 0, 0, 1):get() }
		else
			image = "Resources/Renderers/Widget/Button/Skill-Base.9.png"
			color = { Color(1, 1, 1, 1):get() }
		end

		button:setStyle(ButtonStyle({
			inactive = image, hover = image, pressed = image,
			color = color,
			icon = { filename = string.format("Resources/Game/UI/Icons/Skills/%s.png", skills[i].name), x = 0.25, y = 0.5, width = 32, height = 32 },
			font = "Resources/Renderers/Widget/Common/TinySansSerif/Regular.ttf",
			fontSize = 18,
			textX = 0.9,
			textY = 0.6,
			textShadow = true,
			textAlign = 'right'
		}, self:getView():getResources()))

		button:setToolTip(
			ToolTip.Header(skills[i].name),
			ToolTip.Text(string.format("XP: %s", Utility.Text.prettyNumber(math.floor(skills[i].xp)))),
			ToolTip.Text(string.format("XP to Next Level: %s", Utility.Text.prettyNumber(math.floor(skills[i].xpNextLevel))))
		)

		button.onClick:register(self.openSkillGuide, self, skills[i].name)
	end
end

function PlayerStats:openSkillGuide(skill)
	self:sendPoke("open", nil, { skill = skill })
end

return PlayerStats
