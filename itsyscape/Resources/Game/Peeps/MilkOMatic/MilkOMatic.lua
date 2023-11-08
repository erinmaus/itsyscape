--------------------------------------------------------------------------------
-- Resources/Game/Peeps/MilkOMatic/MilkOMatic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local MilkOMatic = Class(Prop)

function MilkOMatic:new(...)
	Prop.new(self, ...)

	self:addPoke('churn')

	self.ticks = 0
end

function MilkOMatic:getTicks()
	return self.ticks
end

function MilkOMatic:onChurn()
	self.ticks = self.ticks + 1
end

function MilkOMatic:getPropState()
	return { ticks = self.ticks }
end

return MilkOMatic
