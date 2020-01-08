--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/PlayerSpells.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Widget = require "ItsyScape.UI.Widget"
local DraggableButton = require "ItsyScape.UI.DraggableButton"
local SpellIcon = require "ItsyScape.UI.SpellIcon"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local PlayerTab = require "ItsyScape.UI.Interfaces.PlayerTab"

local PlayerSpells = Class(PlayerTab)
PlayerSpells.ICON_SIZE = 48
PlayerSpells.BUTTON_PADDING = 2

function PlayerSpells:new(id, index, ui)
	PlayerTab.new(self, id, index, ui)

	self.buttons = {}
	self.numSpells = 0
	self.onSpellsResized = Callback()

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
		PlayerSpells.ICON_SIZE + PlayerSpells.BUTTON_PADDING * 2,
		PlayerSpells.ICON_SIZE + PlayerSpells.BUTTON_PADDING * 2)
	panel:addChild(self.layout)

	self.layout:setSize(self:getSize())

	self.buttons = {}
end

function PlayerSpells:poke(actionID, actionIndex, e)
	if not PlayerTab.poke(self, actionID, actionIndex, e) then
		-- Nothing.
	end
end

function PlayerSpells:getNumSpells()
	return self.numSpells
end

function PlayerSpells:setNumSpells(value)
	value = value or self.numSpells
	assert(value >= 0 and value < math.huge, "too many or too little inventory value")

	if value ~= #self.buttons then
		if value < #self.buttons then
			while #self.buttons > value do
				local index = #self.buttons
				local top = self.buttons[index]

				self.layout:removeChild(top)
				table.remove(self.buttons, index)
			end
		else
			for i = #self.buttons + 1, value do
				local button = DraggableButton()
				local icon = SpellIcon()
				icon:setData('index', i)
				icon:bind("spellID", "spells[{index}].id")
				icon:bind("spellEnabled", "spells[{index}].enabled")
				icon:bind("spellActive", "spells[{index}].active")
				icon:setSize(PlayerSpells.ICON_SIZE, PlayerSpells.ICON_SIZE)
				icon:setPosition(
					PlayerSpells.BUTTON_PADDING,
					PlayerSpells.BUTTON_PADDING)

				button:addChild(icon)
				button:setData('icon', icon)
				button.onMouseEnter:register(self.hoverSpell, self)
				button.onMouseLeave:register(self.unhoverSpell, self)
				button.onLeftClick:register(self.castSpell, self)
				button.onDrag:register(self.drag, self)
				button.onDrop:register(self.drop, self)

				self.layout:addChild(button)
				table.insert(self.buttons, button)
			end
		end

		self.onSpellsResized(self, #self.buttons)
	end

	local state = self:getState()
	for i = 1, #self.buttons do
		local spell = state.spells[i]
		local button = self.buttons[i]

		local runes = {}
		for j = 1, #spell.items do
			local s = string.format("- %dx %s", spell.items[j].count, spell.items[j].name)
			table.insert(runes, ToolTip.Text(s))
		end

		button:setID("Spell-" .. spell.id)

		button:setToolTip(
			ToolTip.Header(spell.name),
			ToolTip.Text(spell.description),
			ToolTip.Text(string.format("Requires level %d Magic and:", spell.level)),
			unpack(runes))
	end

	self:performLayout()

	self.numSpells = value
end

function PlayerSpells:drag(button, x, y)
	if self:getView():getRenderManager():getCursor() ~= button:getData('icon') then
		self:getView():getRenderManager():setCursor(button:getData('icon'))
	end
end

function PlayerSpells:drop(button, x, y)
	if self:getView():getRenderManager():getCursor() == button:getData('icon') then
		self:getView():getRenderManager():setCursor(nil)
	end
end

function PlayerSpells:hoverSpell(button)
	-- Nothing.
end

function PlayerSpells:unhoverSpell(button)
	-- Nothing.
end

function PlayerSpells:castSpell(button)
	local index = button:getData('icon'):getData('index')
	local spells = self:getState().spells or {}
	local spell = spells[index]
	if spell then
		self:sendPoke("cast", nil, { spell = spell.id })
	end
end

return PlayerSpells
