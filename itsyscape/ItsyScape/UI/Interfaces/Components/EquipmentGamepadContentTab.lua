--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/EquipmentGamepadContentTab.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Function = require "ItsyScape.Common.Function"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Widget = require "ItsyScape.UI.Widget"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local DraggableButton = require "ItsyScape.UI.DraggableButton"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.GamepadContentTab"
local Widget = require "ItsyScape.UI.Widget"

local EquipmentGamepadContentTab = Class(GamepadContentTab)
EquipmentGamepadContentTab.PADDING = 8
EquipmentGamepadContentTab.ICON_SIZE = 48
EquipmentGamepadContentTab.BUTTON_PADDING = 2

function EquipmentGamepadContentTab:new(interface)
	GamepadContentTab.new(self, interface)
end

function EquipmentGamepadContentTab:pokeEquipmentItem(index, actionID)
	self:getInterface():sendPoke("pokeEquipmentItem", nil, { index = index, id = actionID })
end

function EquipmentGamepadContentTab:probeEquipmentItem(index)
	self:getInterface():sendPoke("probeEquipmentItem", nil, { index = index })
end

function EquipmentGamepadContentTab:refresh(state)
	GamepadContentTab.refresh(self, state)

	-- TODO
end

function EquipmentGamepadContentTab:probe(index, button)
	local state = self:getState()
	if not state.items then
		return
	end

	local item = state.items[index]
	local item = items[index]
	if not item then
		return
	end

	local object = item.name

	local actions = {}
	for _, action in ipairs(item.actions) do
		table.insert(actions, {
			id = action.type,
			verb = action.verb,
			object = object,
			objectType = "item",
			callback = Function(self.pokeEquipmentItem, self, index, action.id)
		})
	end

	table.insert(actions, {
		id = "Examine",
		verb = "Examine",
		object = object,
		objectType = "item",
		callback = Function(self.examine, self, item)
	})

	local pokeMenu = self:getUIView():probe(actions)
	pokeMenu.onClose:register(Function(self.probeEquipmentItem, self, false))

	self:probeEquipmentItem(index)
end

function EquipmentGamepadContentTab:examine(item)
	self:getUIView():examine(self:getItemExamine(item))
end

function EquipmentGamepadContentTab:prepareToolTip(index, button)
	local icon = button:getData("icon")
	self:examineItem(icon, self:getState().items, index)
end

return EquipmentGamepadContentTab
