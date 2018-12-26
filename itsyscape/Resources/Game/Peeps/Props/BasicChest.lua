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
local Utility = require "ItsyScape.Game.Utility"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local SimpleInventoryProvider = require "ItsyScape.Game.SimpleInventoryProvider"

local BasicChest = Class(Prop)

function BasicChest:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 1, 1)

	Utility.Peep.addInventory(self, SimpleInventoryProvider)
end

return BasicChest
