--------------------------------------------------------------------------------
-- ItsyScape/Game/ActionCommand/Item.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Component = require "ItsyScape.Game.ActionCommands.Component"

local Item = Class(Component)
Item.TYPE = "item"

function Item:new()
	Component.new(self)

	self.item = "Null"
	self.count = 1
end

function Item:getItem()
	return self.item
end

function Item:setItem(value)
	self.item = value or "Null"
end

function Item:getCount()
	return self.count
end

function Item:setCount(value)
	self.count = value or 1
end

function Item:serialize(t)
	Component.serialize(self, t)

	t.item = self.item
	t.count = self.count
end

return Item
