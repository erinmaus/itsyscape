--------------------------------------------------------------------------------
-- Resources/Peeps/Theodyssius/TheodyssiusHead.lua
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

local TheodyssiusHead = Class(PassableProp)

function TheodyssiusHead:new(resource, name, ...)
	PassableProp.new(self, resource, name or 'TheodyssiusHead', ...)

	self:addBehavior(RotationBehavior)
end

function TheodyssiusHead:onSpawnedByPeep(e)
	self.theodyssius = e.peep

	self.theodyssius:listen('onPoof', self.onParentPoof, self)
end

function TheodyssiusHead:onParentPoof()
	Utility.Peep.poof(self)
end

function TheodyssiusHead:update(...)
	PassableProp.update(self, ...)

	if self.theodyssius then
		Utility.Peep.setPosition(self, Utility.Peep.getPosition(self.theodyssius))
	end
end

function TheodyssiusHead:getPropState()
	local state = PassableProp.getPropState(self)

	if self.theodyssius then
		local actor = self.theodyssius:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor

		if actor then
			state.eye = actor:getID()
		end

		local target = Utility.Peep.getPlayer(self):getBehavior(ActorReferenceBehavior)
		target = target and target.actor

		if target then
			state.target = target:getID()
		end
	end

	return state
end

return TheodyssiusHead
