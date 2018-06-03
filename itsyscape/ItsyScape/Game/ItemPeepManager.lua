--------------------------------------------------------------------------------
-- ItsyScape/Game/ItemPeepManager.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

ItemPeepManager = Class()
function ItemPeepManager.makePeepTypeFromID(id)
	return string.format("Resources.Item.%s.Peep")
end

function ItemPeepManager:new(director)
	self.items = {}
	self.director = director
end

-- Spawns an ItemPeep with the given item ID (e.g., AmuletOfYendor).
--
-- When the ItemPeep is no longer needed, a corresponding call to forget should
-- be used.
--
-- The logic is pretty straightforward: when you spawn an item, call get. When
-- you destroy an item, call forget. The peep is reference counted and will be
-- destroyed when the last item instance is destroyed.
function ItemPeepManager:get(id)
	local item = self.items[id]
	if item then
		item.ref = item.ref + 1
		return item.peep
	else
		item = { ref = 1 }
		local typeName = ItemPeepManager.makePeepTypeFromID(id)
		item.peep = self.director:addPeep(require(id))

		self.items[id] = item
		return item.peep
	end
end

-- Returns true if the ItemPeep with the given ID exists, false otherwise.
function ItemPeepManager:has(id)
	return self.items[id] ~= nil
end

-- Forgets an ItemPeep with the given ID.
--
-- When the ItemPeep is actually forgotten, the underlying Peep will be removed.
function ItemPeepManager:forget(id)
	local item = self.items[id]
	if item then
		item.ref = item.ref - 1
		if item.ref <= 0 then
			assert(item.ref == 0)
			self.director:removePeep(item.peep)
			self.items[id] = nil
		end
	end
end

return ItemPeepManager
