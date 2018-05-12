--------------------------------------------------------------------------------
-- ItsyScape/Game/ItemManager.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ItemInstance = require "ItsyScape.Game.ItemInstance"

local ItemManager = Class()

function ItemManager:new(d)
	self.items = {}

	if type(d) == 'string' then
		self:loadFromFile(d)
	elseif type(d) == 'table' then
		self:loadFromTable(d)
	end
end

function ItemManager:loadFromFile(filename)
	local data = "return " .. love.filesystem.read(filename)
	local chunk = assert(loadstring(data))
	local result = setfenv(chunk, {})() or {}

	self:loadFromTable(result)
end

ItemManager.COLUMN_ID = 1
ItemManager.COLUMN_NOTEABLE = 2
ItemManager.COLUMN_STACKABLE = 3
ItemManager.COLUMN_USERDATA = 4

function ItemManager:loadFromTable(t)
	for i = 1, #t do
		local id, noteable, stackable, userdata = unpack(t[i])

		self:addItem(
			id,
			{
				noteable = noteable,
				stackable = stackable,
				userdata = userdata
			})
	end
end

-- Adds an item with the specified id and attributes.
--
-- Attributes can be:
--   * noteable (boolean): whether the item can be noted or not. Defaults to
--     true.
--   * stackable (boolean): whether the item is stackable. Defaults to true.
--   * userdata (boolean): whether the item has userdata. Defaults to false.
--
-- If userdata is true, noteable and stackable must be false. This is enforced.
function ItemManager:addItem(id, t)
	local item = self.items[id] or {}

	function toBoolean(value)
		if value == nil then
			return false
		else
			if value ~= false then
				return true
			else
				return false
			end
		end
	end

	item.noteable = toBoolean(t.noteable)
	item.stackable = toBoolean(t.noteable)
	item.userdata = toBoolean(t.userdata)

	-- If an item has userdata, it can't be notable nor stackable.
	-- How would that work?
	if item.userdata then
		item.noteable = false
		item.stackable = false
	end

	self.items[id] = item
end

function ItemManager:isNoteable(id)
	local item = self.items[id]
	if not item then
		return true
	else
		return item.noteable
	end
end

function ItemManager:isStackable(id)
	local item = self.items[id]
	if not item then
		return true
	else
		return item.stackable
	end
end

function ItemManager:hasUserdata(id)
	local item = self.items[id]
	if not item then
		return false
	else
		return item.userdata
	end
end

function ItemManager:instantiate(id)
	return ItemInstance(id, self)
end

return ItemManager
