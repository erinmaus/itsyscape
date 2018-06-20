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
local SpellButton = require "ItsyScape.UI.SpellButton"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local PlayerTab = require "ItsyScape.UI.Interfaces.PlayerTab"

local PlayerSpells = Class(PlayerTab)

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
		SpellButton.DEFAULT_SIZE,
		SpellButton.DEFAULT_SIZE)
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
				local button = SpellButton()
				button:getIcon():setData('index', i)
				button:getIcon():bind("spellID", "spells[{index}].id")
				button:getIcon():bind("spellEnabled", "spells[{index}].enabled")
				button:getIcon():bind("spellActive", "spells[{index}].active")

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

	self:performLayout()

	self.numSpells = value
end

function PlayerSpells:drag(button, x, y)
	if self:getView():getRenderManager():getCursor() ~= button:getIcon() then
		self:getView():getRenderManager():setCursor(button:getIcon())
	end
end

function PlayerSpells:drop(button, x, y)
	if self:getView():getRenderManager():getCursor() == button:getIcon() then
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
	local index = button:getIcon():getData('index')
	local spells = self:getState().spells or {}
	local spell = spells[index]
	if spell then
		self:sendPoke("cast", nil, { spell = spell.id })
	end
end

return PlayerSpells
