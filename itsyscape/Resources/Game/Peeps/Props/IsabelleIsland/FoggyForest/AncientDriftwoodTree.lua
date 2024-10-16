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
AncientDriftwoodTree.MAX_TICKS = 4
AncientDriftwoodTree.NORMAL_COOLDOWN = 10
AncientDriftwoodTree.FELLED_COOLDOWN = 15

function AncientDriftwoodTree:new(...)
	BasicTree.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2, 4, 1)

	self.ticks = setmetatable({}, { __mode = "k" })
end

function AncientDriftwoodTree:onResourceObtained(e)
	self.ticks[e.peep] = (self.ticks[e.peep] or 0) + 1
	local ticks = self.ticks[e.peep]

	local map = Utility.Peep.getMapResource(self)
	local director = self:getDirector()
	local t = director:probe(self:getLayerName(), Probe.resource(map))

	if ticks <= AncientDriftwoodTree.MAX_TICKS then
		director:broadcast(t, 'ancientDriftwoodTreeHit', { ticks = ticks, peep = e.peep })

		self.spawnCooldown = AncientDriftwoodTree.NORMAL_COOLDOWN
	else
		director:broadcast(t, 'ancientDriftwoodTreeFelled', { ticks = ticks, peep = e.peep })
	
		self.spawnCooldown = AncientDriftwoodTree.FELLED_COOLDOWN
		self.ticks[e.peep] = nil
	end
end

return AncientDriftwoodTree
