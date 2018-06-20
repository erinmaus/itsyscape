--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/PlayerEquipment.lua
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
local Widget = require "ItsyScape.UI.Widget"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local DraggableButton = require "ItsyScape.UI.DraggableButton"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local PlayerTab = require "ItsyScape.UI.Interfaces.PlayerTab"

local PlayerEquipment = Class(PlayerTab)
PlayerEquipment.PADDING = 8
PlayerEquipment.ICON_SIZE = 48
PlayerEquipment.BUTTON_PADDING = 2

function PlayerEquipment:new(id, index, ui)
	PlayerTab.new(self, id, index, ui)

	local panel = Panel()
	panel = Panel()
	panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Default.9.png"
	}, ui:getResources()))
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.layout = GridLayout()
	self.layout:setPadding(
		PlayerEquipment.PADDING,
		PlayerEquipment.PADDING)
	self.layout:setUniformSize(
		true,
		PlayerEquipment.ICON_SIZE + PlayerEquipment.BUTTON_PADDING * 2,
		PlayerEquipment.ICON_SIZE + PlayerEquipment.BUTTON_PADDING * 2)
	panel:addChild(self.layout)

	self.layout:setSize(self:getSize())

	self:addSlots({
		Equipment.PLAYER_SLOT_RIGHT_HAND,
		Equipment.PLAYER_SLOT_LEFT_HAND,
		Equipment.PLAYER_SLOT_HEAD,
		Equipment.PLAYER_SLOT_NECK,
		Equipment.PLAYER_SLOT_BODY,
		Equipment.PLAYER_SLOT_LEGS,
		Equipment.PLAYER_SLOT_FEET,
		Equipment.PLAYER_SLOT_HANDS,
		Equipment.PLAYER_SLOT_BACK,
		Equipment.PLAYER_SLOT_FINGER,
		Equipment.PLAYER_SLOT_POCKET,
		Equipment.PLAYER_SLOT_QUIVER,
	})
end

function PlayerEquipment:poke(actionID, actionIndex, e)
	if not PlayerTab.poke(self, actionID, actionIndex, e) then
		-- Nothing.
	end
end

function PlayerEquipment:addSlots(slots)
	for i = 1, #slots do
		local button = DraggableButton()
		local icon = ItemIcon()
		icon:setData('index', slots[i])
		icon:bind("itemID", "items[{index}].id")
		icon:bind("itemCount", "items[{index}].count")
		icon:bind("itemIsNoted", "items[{index}].noted")
		icon:setSize(
			PlayerEquipment.ICON_SIZE,
			PlayerEquipment.ICON_SIZE)
		icon:setPosition(
			PlayerEquipment.BUTTON_PADDING,
			PlayerEquipment.BUTTON_PADDING)

		button:setStyle(ButtonStyle({
			inactive = "Resources/Renderers/Widget/Button/InventoryItem.9.png",
			hover = "Resources/Renderers/Widget/Button/InventoryItem.9.png",
			pressed = "Resources/Renderers/Widget/Button/InventoryItem.9.png"
		}, self:getView():getResources()))

		button:addChild(icon)
		button:setData('icon', icon)
		button.onLeftClick:register(self.activate, self)
		button.onRightClick:register(self.probe, self)

		self.layout:addChild(button)
	end
end

function PlayerEquipment:probe(button)
	local index = button:getData('icon'):getData('index')
	local items = self:getState().items or {}
	local item = items[index]
	if item then
		local object
		do
			-- TODO: [LANG]
			local gameDB = self:getView():getGame():getGameDB()
			object = Utility.Item.getName(item.id, gameDB, "en-US")
			if not object then
				object = "*" .. item.id
			end
		end

		local actions = {}
		for i = 1, #item.actions do
			table.insert(actions, {
				id = item.actions[i].type,
				verb = item.actions[i].verb,
				object = object,
				callback = function()
					self:sendPoke("poke", nil, { index = index, id = item.actions[i].id })
				end
			})
		end

		table.insert(actions, {
			id = "Examine",
			verb = "Examine", -- TODO: [LANG]
			object = object,
			callback = function()
				-- TODO: examine item
				Log.info("It's a %s.", object)
			end
		})

		self:getView():probe(actions)
	end
end

function PlayerEquipment:activate(button)
	local index = button:getData('icon'):getData('index')
	local items = self:getState().items or {}
	local item = items[index]
	if item then
		local action = item.actions[1]
		if action then
			self:sendPoke("poke", nil, { index = index, id = action.id })
		end
	end
end

return PlayerEquipment
