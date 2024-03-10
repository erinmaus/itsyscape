--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Mantok/CorpseBumps.lua
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
local PassableProp = require "Resources.Game.Peeps.Props.PassableProp"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

local CorpseBumps = Class(PassableProp)

function CorpseBumps:new(resource, name, ...)
	PassableProp.new(self, resource, name or 'MantokCorpseBumps', ...)

	self:addBehavior(RotationBehavior)
end

function CorpseBumps:onSpawnedByPeep(e)
	self.mantok = e.peep
	self.mantok:listen('onPoof', self.onParentPoof, self)
end

function CorpseBumps:onParentPoof()
	Utility.Peep.poof(self)
end

function CorpseBumps:update(...)
	PassableProp.update(self, ...)

	if self.mantok then
		Utility.Peep.setPosition(self, Utility.Peep.getPosition(self.mantok))
	end
end

function CorpseBumps:getPropState()
	local state = PassableProp.getPropState(self)

	if self.mantok then
		local actor = self.mantok:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor

		if actor then
			state.body = actor:getID()
		end
	end

	return state
end

return CorpseBumps
