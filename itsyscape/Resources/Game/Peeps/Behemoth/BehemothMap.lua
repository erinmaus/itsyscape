--------------------------------------------------------------------------------
-- Resources/Peeps/Behemoth/BehemothMap.lua
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
local BasicPortal = require "Resources.Game.Peeps.Props.BasicPortal"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local TeleportalBehavior = require "ItsyScape.Peep.Behaviors.TeleportalBehavior"

local BehemothMap = Class(BasicPortal)

function BehemothMap:new(resource, name, ...)
	BasicPortal.new(self, resource, name or 'BehemothMap', ...)
end

function BehemothMap:onSpawnedByPeep(e)
	self.behemoth = e.peep

	self.behemoth:listen('onPoof', self.onParentPoof, self)
end

function BehemothMap:onParentPoof()
	Utility.Peep.poof(self)
end

function BehemothMap:getPropState()
	local state = BasicPortal.getPropState(self)
	local portal = self:getBehavior(TeleportalBehavior)

	state.k = (portal and portal.k) or 0
	state.x = (portal and portal.x) or 0
	state.z = (portal and portal.z) or 0 
	state.bone = (portal and portal.bone) or "back"

	if self.behemoth then
		local actor = self.behemoth:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor

		if actor then
			state.actorID = actor:getID()
		end
	end

	return state
end

return BehemothMap
