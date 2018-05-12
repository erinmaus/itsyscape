--------------------------------------------------------------------------------
-- ItsyScape/Game/Body.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

Inventory = Class()
function Inventory:new()
	-- Nothing.
end

-- Adds item 'item' to the inventory.
function Inventory:add(item)
	Class.ABSTRACT()
end

-- Removes item from the inventory at the provided index. Returns the item or
-- nil if no item was at that index.
function Inventory:remove(index)
	return Class.ABSTRACT()
end

-- Returns true if there is an item at the provided index, false otherwise.
function Inventory:hasItem(index)
	Class.ABSTRACT()
end

-- Gets the item at the specified index.
function Inventory:getItem(index)
	Class.ABSTRACT()
end

-- Swaps the inventory slots.
function Inventory:swap(a, b)
	Class.ABSTRACT()
end

return Inventory

