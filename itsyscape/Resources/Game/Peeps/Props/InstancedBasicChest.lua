--------------------------------------------------------------------------------
-- Resources/Peeps/Props/InstancedBasicChest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local BasicChest = require "Resources.Game.Peeps.Props.BasicChest"
local InstancedInventoryBehavior = require "ItsyScape.Peep.Behaviors.InstancedInventoryBehavior"

local InstancedBasicChest = Class(BasicChest)

function InstancedBasicChest:new(...)
	BasicChest.new(self, ...)

	self:addBehavior(InstancedInventoryBehavior)
end

return InstancedBasicChest
