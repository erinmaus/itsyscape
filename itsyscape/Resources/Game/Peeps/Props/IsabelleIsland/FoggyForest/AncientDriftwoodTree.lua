--------------------------------------------------------------------------------
-- Resources/Peeps/Props/IsabelleIsland/FoggyForest/AncientDriftwoodTree.lua
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
local Probe = require "ItsyScape.Peep.Probe"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local BasicTree = require "Resources.Game.Peeps.Props.BasicTree"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"

local AncientDriftwoodTree = Class(BasicTree)
AncientDriftwoodTree.MAX_TICKS = 3

function AncientDriftwoodTree:new(...)
	BasicTree.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2, 4, 1)

	self:addBehavior(SizeBehavior)

	self.ticks = 0
	self.felled = false
end

function AncientDriftwoodTree:onResourceObtained(e)
	self.ticks = self.ticks + 1

	local map = Utility.Peep.getMap(self)
	local director = self:getDirector()
	local t = director:probe(self:getLayerName(), Probe.resource(map))

	if self.ticks < AncientDriftwoodTree.MAX_TICKS then
		self.spawnCooldown = 10

		director:broadcast(t, 'ancientDriftwoodTreeHit', { ticks = self.ticks, peep = e.peep })
	else
		director:broadcast(t, 'ancientDriftwoodTreeFelled', { ticks = self.ticks, peep = e.peep })
	end
end

return AncientDriftwoodTree
