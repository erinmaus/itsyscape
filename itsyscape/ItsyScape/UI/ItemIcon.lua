--------------------------------------------------------------------------------
-- ItsyScape/UI/ItemIcon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Widget = require "ItsyScape.UI.Widget"

local ItemIcon = Class(Widget)
ItemIcon.DEFAULT_SIZE = 48

function ItemIcon:new()
	Widget.new(self)

	self.itemID = false
	self.itemCount = 1
	self.itemIsNoted = false
	self.isDisabled = false

	self:setSize(ItemIcon.DEFAULT_SIZE, ItemIcon.DEFAULT_SIZE)
end

function ItemIcon:setItemIsNoted(value)
	if value ~= nil then
		if value == false then
			self.itemIsNoted = false
		else
			self.itemIsNoted = true
		end
	end
end

function ItemIcon:getItemIsNoted()
	return self.itemIsNoted
end

function ItemIcon:setItemID(value)
	self.itemID = value or self.itemID
end

function ItemIcon:getItemID()
	return self.itemID
end

function ItemIcon:setItemCount(value)
	self.itemCount = value or self.itemCount
end

function ItemIcon:getItemCount()
	return self.itemCount
end

function ItemIcon:getIsDisabled()
	return self.isDisabled
end

function ItemIcon:setIsDisabled(value)
	self.isDisabled = value or false
end

return ItemIcon
