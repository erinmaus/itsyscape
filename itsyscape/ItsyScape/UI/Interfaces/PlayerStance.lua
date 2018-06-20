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
local Weapon = require "ItsyScape.Game.Weapon"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Widget = require "ItsyScape.UI.Widget"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local PlayerTab = require "ItsyScape.UI.Interfaces.PlayerTab"

local PlayerStance = Class(PlayerTab)
PlayerStance.PADDING = 8
PlayerStance.BUTTON_HEIGHT = 64
PlayerStance.STYLE = {
	[Weapon.STYLE_MAGIC] = {
		[Weapon.STANCE_AGGRESSIVE] = "Wisdom",
		[Weapon.STANCE_CONTROLLED] = "Magic",
		[Weapon.STANCE_DEFENSIVE] = "Defense"
	},

	[Weapon.STYLE_ARCHERY] = {
		[Weapon.STANCE_AGGRESSIVE] = "Dexterity",
		[Weapon.STANCE_CONTROLLED] = "Archery",
		[Weapon.STANCE_DEFENSIVE] = "Defense"
	},

	[Weapon.STYLE_MELEE] = {
		[Weapon.STANCE_AGGRESSIVE] = "Strength",
		[Weapon.STANCE_CONTROLLED] = "Attack",
		[Weapon.STANCE_DEFENSIVE] = "Defense"
	},
}

PlayerStance.ACTIVE_STYLE = function(skill)
	local t = {
		inactive = "Resources/Renderers/Widget/Button/SelectedAttackStyle-Inactive.9.png",
		hover = "Resources/Renderers/Widget/Button/SelectedAttackStyle-Hover.9.png",
		pressed = "Resources/Renderers/Widget/Button/SelectedAttackStyle-Pressed.9.png",
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Semibold.ttf",
		icon = { skill = string.format("Resources/Game/UI/Icons/Skills/%s.png", skill), x = 0.15 },
		fontSize = 26,
		textX = 0.3,
		textY = 0.7,
		textAlign = 'left'
	}

	if skill then
		t.icon = { filename = string.format("Resources/Game/UI/Icons/Skills/%s.png", skill), x = 0.15 }
	end

	return t
end

PlayerStance.INACTIVE_STYLE = function(skill)
	local t = {
		inactive = "Resources/Renderers/Widget/Button/UnselectedAttackStyle-Inactive.9.png",
		hover = "Resources/Renderers/Widget/Button/UnselectedAttackStyle-Hover.9.png",
		pressed = "Resources/Renderers/Widget/Button/UnselectedAttackStyle-Pressed.9.png",
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Semibold.ttf",
		fontSize = 26,
		textX = 0.3,
		textY = 0.7,
		textAlign = 'left'
	}

	if skill then
		t.icon = { filename = string.format("Resources/Game/UI/Icons/Skills/%s.png", skill), x = 0.15 }
	end

	return t
end

function PlayerStance:new(id, index, ui)
	PlayerTab.new(self, id, index, ui)

	self.panel = Panel()
	self.panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Default.9.png"
	}, ui:getResources()))
	self:addChild(self.panel)

	self.panel:setSize(self:getSize())

	self.buttons = {}
	local function addButton(stance, name)
		local button = Button()

		button.onClick:register(function()
			self:sendPoke("setStance", nil, { stance = stance })
		end)

		button:setData('stance', stance)

		button:setStyle(ButtonStyle(PlayerStance.INACTIVE_STYLE(), self:getView():getResources()))

		button:setText(name)

		self:addChild(button)
		table.insert(self.buttons, button)
	end

	addButton(Weapon.STANCE_AGGRESSIVE, "Aggressive")
	addButton(Weapon.STANCE_CONTROLLED, "Controlled")
	addButton(Weapon.STANCE_DEFENSIVE, "Defensive")
	do
		local button = Button()

		button.onClick:register(function()
			self:sendPoke("toggleSpell", nil, {})
		end)
		button:setStyle(ButtonStyle(PlayerStance.INACTIVE_STYLE(), self:getView():getResources()))
		button:setData('active', false)

		button:setText("Use Spell")

		self:addChild(button)
		self.buttons.toggleSpell = button
	end

	self:performLayout()
end

function PlayerStance:performLayout()
	PlayerTab.performLayout(self)

	local panelWidth, panelHeight = self:getSize()
	if self.buttons then
		local y = PlayerStance.PADDING
		for _, button in ipairs(self.buttons) do
			button:setSize(
				panelWidth - PlayerStance.PADDING * 2,
				PlayerStance.BUTTON_HEIGHT)
			button:setPosition(PlayerStance.PADDING, y)

			y = y + PlayerStance.BUTTON_HEIGHT + PlayerStance.PADDING
		end

		self.buttons.toggleSpell:setSize(
			panelWidth - PlayerStance.PADDING * 2,
			PlayerStance.BUTTON_HEIGHT)
		self.buttons.toggleSpell:setPosition(PlayerStance.PADDING, y)
	end
end

function PlayerStance:update(...)
	PlayerTab.update(self, ...)

	local state = self:getState()
	local style
	do
		local toggleButton = self.buttons.toggleSpell
		if state.useSpell then
			style = Weapon.STYLE_MAGIC

			if not toggleButton:getData('active') then
				toggleButton:setStyle(ButtonStyle(PlayerStance.ACTIVE_STYLE(), self:getView():getResources()))
				toggleButton:setData('active', true)
			end
		else
			style = state.style

			if toggleButton:getData('active') then
				toggleButton:setStyle(ButtonStyle(PlayerStance.INACTIVE_STYLE(), self:getView():getResources()))
				toggleButton:setData('active', false)
			end
		end
	end

	for i = 1, #self.buttons do
		local button = self.buttons[i]
		local stance = button:getData('stance')
		local selected = button:getData('selected')
		local skill = PlayerStance.STYLE[style][stance]
		if stance == state.stance or self.style ~= style then
			if not selected then
				button:setData('selected', true)
				button:setStyle(ButtonStyle(PlayerStance.ACTIVE_STYLE(skill), self:getView():getResources()))
			end
		elseif selected or self.style ~= style then
			button:setStyle(ButtonStyle(PlayerStance.INACTIVE_STYLE(skill), self:getView():getResources()))

			button:setData('selected', false)
		end
	end

	self.style = style
end

return PlayerStance
