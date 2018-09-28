--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicChest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local SimpleInventoryProvider = require "ItsyScape.Game.SimpleInventoryProvider"
local PlayerInventoryStateProvider = require "ItsyScape.Game.PlayerInventoryStateProvider"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local BasicChest = Class(Prop)

function BasicChest:new(...)
	Prop.new(self, ...)

	self:addBehavior(InventoryBehavior)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 1, 1)

	local inventory = self:getBehavior(InventoryBehavior)
	inventory.inventory = SimpleInventoryProvider(self)
end

function BasicChest:assign(director, key)
	Prop.assign(self, director, key)

	local inventory = self:getBehavior(InventoryBehavior)
	director:getItemBroker():addProvider(inventory.inventory)

	self:getState():addProvider("Item", PlayerInventoryStateProvider(self))
end

return BasicChest
