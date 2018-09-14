--------------------------------------------------------------------------------
-- Resources/Peeps/Props/IsabelleIsland/AbandonedMine/Pillar.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local BasicRock = require "Resources.Game.Peeps.Props.BasicRock"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local Probe = require "ItsyScape.Peep.Probe"

local Pillar = Class(BasicRock)

function Pillar:new(...)
	BasicRock.new(self, ...)
end

function Pillar:onResourceObtained()
	local director = self:getDirector()
	local peeps = director:probe(Probe.resource("Peep", "GhostlyMinerForeman"))
	for _, peep in ipairs(peeps) do
		peep:poke('pillarMined', { pillar = self })
	end
end

return Pillar
