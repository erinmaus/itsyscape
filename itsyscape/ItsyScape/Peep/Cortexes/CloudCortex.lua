--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/CloudCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Cortex = require "ItsyScape.Peep.Cortex"
local CloudBehavior = require "ItsyScape.Peep.Behaviors.CloudBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SkyBehavior = require "ItsyScape.Peep.Behaviors.SkyBehavior"

local CloudCortex = Class(Cortex)

function CloudCortex:new()
	Cortex.new(self)

	self:require(CloudBehavior)
	self:require(MovementBehavior)
	self:require(PositionBehavior)
end

function CloudCortex:update(delta)
	local game = self:getDirector():getGameInstance()
	local finished = {}

	for peep in self:iterate() do
		local movement = peep:getBehavior(MovementBehavior)
		local mapScript = Utility.Peep.getMapScript(peep)
		local sky = peep:getBehavior(SkyBehavior)

		if sky and movement then
			movement.velocity = sky.windDirection * sky.windSpeed
		end
	end
end

return CloudCortex
