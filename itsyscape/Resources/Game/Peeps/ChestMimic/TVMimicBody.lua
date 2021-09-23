--------------------------------------------------------------------------------
-- Resources/Peeps/ChestMimic/TVMimicBody.lua
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

local TVMimicBody = Class(PassableProp)

function TVMimicBody:new(resource, name, ...)
	PassableProp.new(self, resource, name or 'TVMimicBody', ...)

	self:addBehavior(RotationBehavior)
end

function TVMimicBody:onSpawnedByPeep(e)
	self.chestMimic = e.peep

	self.chestMimic:listen('onPoof', self.onParentPoof, self)
end

function TVMimicBody:onParentPoof()
	Utility.Peep.poof(self)
end

function TVMimicBody:update(...)
	PassableProp.update(self, ...)

	if self.chestMimic then
		Utility.Peep.setPosition(self, Utility.Peep.getPosition(self.chestMimic))
		Utility.Peep.setRotation(self, Utility.Peep.getRotation(self.chestMimic))
	end
end

function TVMimicBody:getPropState()
	local state = PassableProp.getPropState(self)

	if self.chestMimic then
		local actor = self.chestMimic:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor

		if actor then
			state.actorID = actor:getID()
		end
	end

	state.color = { 0.2, 0.2, 0.2, 1.0 }

	return state
end

return TVMimicBody
