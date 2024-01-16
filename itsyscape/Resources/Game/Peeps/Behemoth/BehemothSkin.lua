--------------------------------------------------------------------------------
-- Resources/Peeps/Behemoth/BehemothSkin.lua
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
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

local BehemothSkin = Class(PassableProp)

function BehemothSkin:new(resource, name, ...)
	PassableProp.new(self, resource, name or 'BehemothSkin', ...)

	self:addBehavior(RotationBehavior)
end

function BehemothSkin:onSpawnedByPeep(e)
	self.behemoth = e.peep

	self.behemoth:listen('onPoof', self.onParentPoof, self)
end

function BehemothSkin:onParentPoof()
	Utility.Peep.poof(self)
end

function BehemothSkin:getPropState()
	local state = PassableProp.getPropState(self)

	if self.behemoth then
		local actor = self.behemoth:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor

		if actor then
			state.actorID = actor:getID()
		end
	end

	return state
end

return BehemothSkin
