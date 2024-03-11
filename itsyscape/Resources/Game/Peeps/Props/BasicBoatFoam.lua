--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicOcean.lua
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
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local PassableProp = require "Resources.Game.Peeps.Props.PassableProp"

local BasicOcean = Class(PassableProp)

function BasicOcean:new(...)
	PassableProp.new(self, ...)
end

function BasicOcean:onSpawnedByPeep(p)
	self.shipTarget = p and p.peep
end

function BasicOcean:getPropState()
	return {
		visible = not self.shipTarget or not self.shipTarget:hasBehavior(DisabledBehavior)
	}
end

return BasicOcean
