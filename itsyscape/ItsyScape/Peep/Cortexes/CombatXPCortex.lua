--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/CombatXPCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Cortex = require "ItsyScape.Peep.Cortex"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"

local CombatXPCortex = Class(Cortex)

function CombatXPCortex:new()
	Cortex.new(self)

	self:require(CombatStatusBehavior)
end

function CombatXPCortex:addPeep(peep)
	Cortex.addPeep(self, peep)

	peep:listen('hit', self.onHit, self)
end

function CombatXPCortex:removePeep(peep)
	Cortex.removePeep(self, peep)

	peep:silence('hit', self.onHit)
end

function CombatXPCortex:onHit(peep, p)
	if not p:getAggressor() then
		return
	end

	if not peep:hasBehavior(PlayerBehavior) then
		local status = peep:getBehavior(CombatStatusBehavior)
		if status then
			local damage = status.damage[p:getAggressor()] or 0
			status.damage[p:getAggressor()] = damage + p:getDamage()
		end
	end
end

return CombatXPCortex
