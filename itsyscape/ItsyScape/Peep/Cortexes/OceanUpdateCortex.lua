--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/OceanUpdateCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Cortex = require "ItsyScape.Peep.Cortex"
local OceanBehavior = require "ItsyScape.Peep.Behaviors.OceanBehavior"

local OceanUpdateCortex = Class(Cortex)

function OceanUpdateCortex:new()
	Cortex.new(self)

	self:require(OceanBehavior)

    self.startTime = love.timer.getTime()
end

function OceanUpdateCortex:update(delta)
    local time = love.timer.getTime() - self.startTime

    for peep in self:iterate() do
        local ocean = peep:getBehavior(OceanBehavior)
        if ocean then
            ocean.time = time
        end
    end
end

return OceanUpdateCortex
