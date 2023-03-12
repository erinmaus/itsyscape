--------------------------------------------------------------------------------
-- ItsyScape/UI/Interface.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"

local Interface = Class(Widget)

-- Constructs a new interface, (id, index), belonging to the UI model, 'ui'.
function Interface:new(id, index, view)
	Widget.new(self)

	self.id = id
	self.index = index
	self.view = view
end

-- Gets the UI model this interface belongs to.
function Interface:getUI()
	return self.view:getUI()
end

-- Gets the UI view this interface belongs to.
function Interface:getView()
	return self.view
end

-- Gets the interface ID.
function Interface:getID()
	return self.id
end

-- Gets the index of the interface.
function Interface:getIndex()
	return self.index
end

-- Called when the interface is poked.
function Interface:poke(actionID, actionIndex, e)
	if actionIndex == nil then
		local func = self[actionID]
		if func then
			local s, r = xpcall(func, debug.traceback, self, unpack(e, 1, e.n))
			if not s then
				io.stderr:write("error: ", r, "\n")
				self:sendPoke("$error", 1, { actionID = actionID, message = r })

				return false
			end

			return true
		end
	end

	return false
end

-- Utility to poke the correct Interface via the UI model.
function Interface:sendPoke(actionID, actionIndex, e)
	return self:getUI():poke(
		self:getID(),
		self:getIndex(),
		actionID,
		actionIndex,
		e)
end

-- Gets the state this Interface holds.
--
-- State is a table of values referenced by children widgets. For example, an
-- inventory widget may expect there to be an array called 'items' with fields
-- { id, count, noted }.
--
-- Returns the state. This state overrides the current state, if any.
--
-- By default, it requests the state from the UI model.
function Interface:getState()
	return self:getUI():pull(self:getID(), self:getIndex()) or {}
end

function Interface:examineItem(widget, inventory, index)
	local item = inventory[index]

	if not item then
		widget:setToolTip()
		return
	end

	local object, description, stats = Utility.Item.getInfo(
		item.id,
		self:getView():getGame():getGameDB())
	object = item.name or object
	description = item.description or description
	stats = item.stats or stats

	local action = item.actions[1]
	if action then
		object = action.verb .. " " .. object
	end

	local toolTip = {
		ToolTip.Header(object),
		ToolTip.Text(description)
	}

	if stats then
		stats = Utility.Item.groupStats(stats)

		if #stats.offensive > 0 then
			table.insert(toolTip, ToolTip.Header("Offense"))
			for i = 1, #stats.offensive do
				local stat = stats.offensive[i]
				local text = string.format("%s: %d", stat.niceName, stat.value)
				table.insert(toolTip, ToolTip.Text(text))
			end
		end

		if #stats.defensive > 0 then
			table.insert(toolTip, ToolTip.Header("Defense"))
			for i = 1, #stats.defensive do
				local stat = stats.defensive[i]
				local text = string.format("%s: %d", stat.niceName, stat.value)
				table.insert(toolTip, ToolTip.Text(text))
			end
		end

		if #stats.other > 0 then
			table.insert(toolTip, ToolTip.Header("Other"))
			for i = 1, #stats.other do
				local stat = stats.other[i]
				local text = string.format("%s: %d", stat.niceName, stat.value)
				table.insert(toolTip, ToolTip.Text(text))
			end
		end
	end

	widget:setToolTip(unpack(toolTip))
end

function Interface:getIsFullscreen()
	return false
end

return Interface
