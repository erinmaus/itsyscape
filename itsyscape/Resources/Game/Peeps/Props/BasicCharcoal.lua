--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicCharcoal.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Curve = require "ItsyScape.Game.Curve"
local Utility = require "ItsyScape.Game.Utility"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PassableProp = require "Resources.Game.Peeps.Props.PassableProp"

local BasicCharcoal = Class(PassableProp)
BasicCharcoal.POST_FIRE_LIFESPAN = 15

function BasicCharcoal:new(resource, name, ...)
	PassableProp.new(self, resource, 'Charcoal', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(0.25, 0.25, 0.25)

	self.duration = math.huge
end

function BasicCharcoal:onSpawnedByFire(fire, duration)
	self.duration = duration + self.POST_FIRE_LIFESPAN
end

function BasicCharcoal:update(director, game)
	PassableProp.update(self, director, game)

	self.duration = self.duration - game:getDelta()
	if self.duration < 0 then
		Utility.Peep.poof(self)
	end
end

function BasicCharcoal:getPropState()
	return {
		duration = self.duration
	}
end

return BasicCharcoal
